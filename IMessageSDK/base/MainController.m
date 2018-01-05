//
//  MainController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "MainController.h"
#import "GuideController.h"
#import "TabbarController.h"
#import "LoginController.h"
#import "LTSDKFull.h"
#import "AppUtility.h"
#import "UIViewController+child.h"
#import "UIConfig.h"
#import "SVProgressHUD.h"
#import "DocManager.h"
#import "Message.h"
#import "NewRosterMessage.h"
#import "ApnsManager.h"
#import "VoipManager.h"
//#import "VideoController.h"
#import "AppDelegate+apns.h"
#import "AppDelegate+voip.h"



@interface MainController ()
@property (nonatomic, strong) LoginController     *loginController;
@property (nonatomic, strong) GuideController     *guideController;
@property (nonatomic, strong) TabbarController    *tabBarController;
//@property (nonatomic, strong) VideoController     *videoController;
@end




@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**信息监听**/
    [self addMessageBehaviorObserver];
    
    /**roster行为监测**/
    [self addFriendBehaviorObserver];
    
    self.loginController = [[LoginController alloc] init];
    self.guideController = [[GuideController alloc] init];
    self.tabBarController = [[TabbarController alloc] init];
//    self.videoController = [[VideoController alloc] init];
    
    //是否首次登录
    BOOL ret = [AppUtility queryIsFirstLaunching];
    if (ret)
    {
        __weak typeof(self) weakself = self;
        [self showGuideController];
        [self.guideController setEnterBlock:^(BOOL ret) {
            if (ret) {
                [AppUtility updateIsFirstLaunching:NO];
                [weakself showLoginController];
            }
        }];
        
    }else{
        /**是否有登录历史**/
        
        if ([LTLogin.share queryLastLoginUser])
        {
            [self showTabBarController];
            [LTLogin.share loginCheck:^(MyLoginState aLoginState) {
                
                switch (aLoginState) {
                    case MyLoginState_Login:
                    {
                        /**返回的是字典aUsername\ aPassword\ aIP\ aPort**/
                        NSDictionary  *userDict = [LTLogin.share queryLastLoginUser];
                        NSString *aUsername = userDict[@"aUsername"];
                        NSString *aPassword = userDict[@"aPassword"];
                        NSString *aIP = userDict[@"aIP"];
                        NSString *aPort = userDict[@"aPort"];
                        
                        __weak typeof(self) weakself = self;
                        [LTLogin.share asyncLoginWithUsername:aUsername
                                                     password:aPassword
                                                     serverIP:aIP
                                                         port:aPort
                                                    completed:^(LTError *error) {
                                                        if (error) {
                                                            NSLog(@"%@",error.localDescription);
                                                            [SVProgressHUD showErrorWithStatus:error.localDescription];
                                                            [weakself loginFailureAction];
                                                        }else{
                                                            NSLog(@"登录成功");
                                                            [weakself loginSuccessAction02];
                                                        }
                                                    }];
                    }
                        break;
                    default:
                        [self showLoginController];
                        break;
                }
                
            }];
            
        }else{
            
            [self showLoginController];
        }
    }
}

-(void)hiddenTbaBar {
    self.tabBarController.tabBar.hidden = YES;
}
-(void)showTbaBar {
    self.tabBarController.tabBar.hidden = NO;
}











- (void)showLoginController {
    [self jianghai_removeAllChildController];
    [self jianghai_addChildController:self.loginController];
}
- (void)showGuideController {
    [self jianghai_removeAllChildController];
    [self jianghai_addChildController:self.guideController];
}
- (void)showTabBarController {
    [self jianghai_removeAllChildController];
    [self jianghai_addChildController:self.tabBarController];
}
//- (void)showVideoControllerWithOtherPID:(NSString *)otherPID {
//    [self jianghai_removeAllChildController];
//    [self jianghai_addChildController:self.videoController];
//    self.videoController.otherPID = otherPID;
//}




- (void)loginSuccessAction02 {
    [kMainVC showTabBarController];
    
    //下载组织架构
    [LTOrg.share downloadOrg:^(GDataXMLDocument *doc, LTError *error) {
        if (error)
        {
            NSLog(@"组织架构下载失败");
        }else{
            NSLog(@"组织架构下载成功");
            /**更新doc**/
            [DocManager.share updateDocument:doc];
            
            /**浏览doc基本信息**/
            NSDictionary *dict = [DocManager.share queryDocumentDescribe];
            
            NSLog(@"%@",dict);
            
            
            /**
             Linphone
             
             [self settingPID];
             
             [self settingApnsToken];
             
             [self settingVoipToken];
             **/
            
        }
    }];
}
- (void)loginFailureAction {
    //    [_loginView hideServerView];
}







#pragma mark - observer message

/*!
 @method
 @abstract 信息监听
 @discussion 监听从服务器接收的信息
 */
-(void)addMessageBehaviorObserver {
    __weak typeof(self) weakself = self;
    [LTMessage.share queryMesageCompleted:^(NSDictionary *dict, LTError *error) {
        if (error)
        {
            [weakself dealError:error];
        }else{
            [weakself dealData:dict];
        }
    }];
}

/**
 chat：
 
 {
 UID = 6D1FA0C4ABD74F0EACB360E1E52E37DB;
 body = "信息文本";
 bodyType = "text";
 conversationName = "萧凡宇";
 currentMyJID = "江海@duowin-server";
 currentOtherJID = "萧凡宇@duowin-server";
 from = "萧凡宇@duowin-server";
 stamp = "2018-01-04 15:55:37";
 to = "江海@duowin-server";
 type = chat;
 
 
 groupchat：
 
 {
 SenderJID = "萧凡宇@duowin-server";
 UID = F2827F0ABD56458DB2C317D3703B1DF9;
 body = "信息文本";
 bodyType = "text";
 conversationName = "力拓大家庭群组";
 currentMyJID = "江海@duowin-server";
 currentOtherJID = "82eb16e3b6c141ee968c7528cf7ab493@conference.duowin-server";
 from = "82eb16e3b6c141ee968c7528cf7ab493@conference.duowin-server";
 stamp = "2018-01-04 16:00:50";
 to = "江海@duowin-server";
 type = groupchat;
 }
 **/
-(void)dealData:(NSDictionary *)dict {
    Message *msg = [[Message alloc] init];
    msg.currentMyJID = dict[@"currentMyJID"];
    msg.currentOtherJID = dict[@"currentOtherJID"];
    msg.conversationName = dict[@"conversationName"];
    msg.stamp = dict[@"stamp"];
    msg.body = dict[@"body"];
    msg.bodyType = dict[@"bodyType"];
    msg.from = dict[@"from"];
    msg.to = dict[@"to"];
    msg.type = dict[@"type"];
    msg.UID = dict[@"UID"];
    msg.SenderJID = dict[@"SenderJID"];
    [msg jh_saveOrUpdate];
    // [self refreshData];
}
/**处理错误**/
-(void)dealError:(LTError *)error {
    switch (error.code) {
        case LTErrorLogin_SessionReplace:
        {
            /**异地登录**/
            [SVProgressHUD showInfoWithStatus:error.localDescription];
            [LTLogin.share asyncLogout];
            [self showLoginController];
        }
            break;
            
        default:
            break;
    }
}






#pragma mark - observer roster
/**添加好友行为（添加好友，删除好友等）监测**/
-(void)addFriendBehaviorObserver {

    [LTFriend.share addFriendBehaviorObserver:^(NSDictionary *dict) {
        NSString *key = dict.allKeys.firstObject;

        /**对方请求添加好友**/
        if ([key isEqualToString:@"subscribe"])
        {
            [self addFriendMessage:dict];
        }
        else
        {
            
        }
    }];
}

/**将好友请求放在消息**/
-(void)addFriendMessage:(NSDictionary *)dict {
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];
    
    NewRosterMessage *message = [[NewRosterMessage alloc] init];
    message.currentMyJID = myJID;
    message.currentOtherJID = dict[@"subscribe"];
    message.body = nil;
    message.from = [dict[@"subscribe"] componentsSeparatedByString:@"@"].firstObject;
    message.type = @"NewRoster";
    [message jh_saveOrUpdate];
}










#pragma mark - Private

-(void)settingApnsToken
{
    [ApnsManager.share deleteApns];
    [kAppDelegate settingApns:^(NSString *ret, NSError *error) {
        if (error)
        {
            
        }
        else
        {
            [ApnsManager.share updateApns:ret];
            [self settingParametersToSip];
        }
    }];
}
-(void)settingVoipToken
{
    [VoipManager.share deleteVoip];
    [kAppDelegate settingVoip:^(NSString *ret, NSError *error) {
        if (error)
        {
            
        }
        else
        {
            [VoipManager.share updateVoip:ret];
            [self settingParametersToSip];
        }
    }];
}
/**获取自己的PID**/
-(void)settingPID
{
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *JID = userDict[@"JID"];
    [LTUser.share sendRequestPidWithJid:JID completed:^(NSDictionary *dict, LTError *error) {
       
        NSString *key = dict.allKeys.firstObject;        
        if ([key isEqualToString:@"myPID"])
        {
            NSString *value = dict[@"myPID"];
            
            [VoipManager.share updatePID:value];
            [self settingParametersToSip];
        }
//        else if ([key isEqualToString:@"otherPID"])
//        {
//            NSString *value = dict[@"otherPID"];
//            VoipManager.share.otherPID = value;
//        }
    }];
    
}

/**
 Sip服务器设置相关参数
 **/
-(void)settingParametersToSip
{
    NSString *apns = [ApnsManager.share queryApns];
    NSString *voip = [VoipManager.share queryVoip];
    NSString *pid  = [VoipManager.share queryPID];

    NSLog(@"apns == %@ ",apns);
    NSLog(@"voip == %@ ",voip);
    NSLog(@"pid == %@ ",pid);

    if (apns == nil || apns.length == 0)
    {
        return;
    }
    if (voip == nil || voip.length == 0)
    {
        return;
    }
    if (pid == nil || pid.length == 0)
    {
        return;
    }

    [VoipManager.share settingParametersToServer];
}




@end
