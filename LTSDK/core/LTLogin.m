//
//  LTLogin.m
//  WiseUC
//
//  Created by JH on 2017/12/6.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "LTLogin.h"
//#import "XMPPManager.h"
//#import "AppDelegate+XMPP.h"
#import "LTSVProgressHUD.h"
#import "LoginManager.h"
#import "LTXMPPManager+presence.h"

#define kLTLogin_lastLoginUserKey @"LTLogin_loginUserKey"
#define kLTLogin_loginStateKey @"LTLogin_loginStateKey"
#define kLTLoginKey_logout @"kLTLoginKey_logout"


@interface LTLogin ()
{
    LTLogin_LoginBlock _loginBlock;
    LTLogin_LoginCheckBlock _loginCheckBlock;
    LTLogin_LogoutBlock _logoutBlock;
}
@end




@implementation LTLogin


+ (instancetype)share {
    static LTLogin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTLogin alloc] init];
    });
    return instance;
}


/**登录**/
-(void)asyncLoginWithUsername:(NSString *)aUsername
                     password:(NSString *)aPassword
                     serverIP:(NSString *)aIP
                         port:(NSString *)aPort
                    completed:(LTLogin_LoginBlock)aLoginBlock {
    _loginBlock = aLoginBlock;
    
    
    NSString *errorDsc = nil;
    if ( aUsername.length == 0 ) {
        errorDsc = @"用户名不能为空";
    } else if ( aPassword.length == 0 ) {
        errorDsc = @"密码不能为空";
    } else if ( aIP.length == 0 ) {
        errorDsc = @"服务器地址不能为空";
    } else if ( aPort.length == 0 ) {
        errorDsc = @"端口号不能为空";
    }
    
    if ( errorDsc ) {
        if ( aLoginBlock ) {
            LTError *error = [LTError errorWithDescription:errorDsc code:(LTErrorGeneral)];
            aLoginBlock(error);
        }
        return;
    }
    
    __weak typeof(self) weakself = self;
    [LoginManager.shareHelper loginWithServerIP:aIP
                                           port:aPort
                                       username:aUsername
                                       password:aPassword
                                completeHandler:^(LTError *error) {
                                    if (error)
                                      {
                                          _loginBlock(error);
                                          [weakself updateLoginState:NO];
                                      }else {
                                          _loginBlock(nil);
                                          [weakself loginSuccessAction];
                                          [weakself updateLoginState:YES];
                                          [weakself updateLastLoginUserWithUsername:aUsername
                                                                           password:aPassword
                                                                                 ip:aIP
                                                                               port:aPort];
                                      }
                                    
                                    
                                }];
    
}

/**登录成功操作**/
- (void)loginSuccessAction {
    
}
/**登录失败操作**/
- (void)loginFailureAction {

}



-(void)loginCheck:(LTLogin_LoginCheckBlock)aLoginCheckBlock {
    _loginCheckBlock = aLoginCheckBlock;
    /**登录历史**/
    NSDictionary *aLastLoginUser = [self queryLastLoginUser];
    /**登录状态**/
    BOOL aLoginState = [self queryLoginState];
    
    if (aLastLoginUser)
    {
        if (aLoginState)
        {
            _loginCheckBlock(MyLoginState_Login);
        }else{
            _loginCheckBlock(MyLoginState_Logout);
        }
    }else{
        _loginCheckBlock(MyLoginState_NoLoginRecord);
    }
}

/**登出**/
-(void)asyncLogout{    
    [self updateLoginState:NO];
    
    [LTXMPPManager.share sendPresenceUNAvailable]; //发送离线
    [LTXMPPManager.share clear];
}














#pragma mark -================= 是否登录

/**更新用户登录状态**/
- (void)updateLoginState:(BOOL)ret {
    [NSUserDefaults.standardUserDefaults
     setBool:ret
     forKey:kLTLogin_loginStateKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (BOOL)queryLoginState {
    BOOL ret =
    [NSUserDefaults.standardUserDefaults
     boolForKey:kLTLogin_loginStateKey];
    return ret;
}

- (void)deleteLoginState {
    [NSUserDefaults.standardUserDefaults
     setBool:NO
     forKey:kLTLogin_loginStateKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}







#pragma mark -================= 登录历史

/**更新最后登录用户**/
- (void)updateLastLoginUserWithUsername:(NSString *)aUsername
                               password:(NSString *)aPassword
                                     ip:(NSString *)aIP
                                   port:(NSString *)aPort {
    NSDictionary *dict = @{
        @"aUsername":aUsername,
        @"aPassword":aPassword,
        @"aIP":aIP,
        @"aPort":aPort
    };
    [NSUserDefaults.standardUserDefaults
     setObject:dict
     forKey:kLTLogin_lastLoginUserKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSDictionary *)queryLastLoginUser {
    NSDictionary *dict =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kLTLogin_lastLoginUserKey];
    return dict;
}

- (void)deleteLastLoginUser {
    [NSUserDefaults.standardUserDefaults
     setObject:nil forKey:kLTLogin_lastLoginUserKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
