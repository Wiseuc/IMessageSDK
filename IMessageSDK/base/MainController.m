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


@interface MainController ()
@property (nonatomic, strong) LoginController     *loginController;
@property (nonatomic, strong) GuideController     *guideController;
@property (nonatomic, strong) TabbarController    *tabBarController;
@end




@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginController = [[LoginController alloc] init];
    self.guideController = [[GuideController alloc] init];
    self.tabBarController = [[TabbarController alloc] init];
    
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
                                                            [weakself loginSuccessAction];
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




- (void)loginSuccessAction {
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
            
        }
    }];
}
- (void)loginFailureAction {
    //    [_loginView hideServerView];
}


@end
