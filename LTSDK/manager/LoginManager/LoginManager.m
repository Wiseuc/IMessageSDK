//
//  LoginManager.m
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "LoginManager.h"
#import "AppManager.h"
#import "INFManager.h"
#import "LTIniHelper.h"
#import "Encrypt_Decipher.h"
#import "LTXMPPManager.h"
#import "LTXMPPManager+iq.h"
#import "LT_OrgManager.h"
#import "LT_OrgModel.h"
#define KLoginFailed_NetWorkingError @"网络异常"
#define KLoginFailed_FetchOrgFileError @"组织架构获取失败"
#define KLoginFailed_FetchLoginConfigError @"登录配置获取失败，请检查网络是否畅通！"
#define KLoginFailed_TimeOut @"登录超时"





@interface LoginManager ()
{
    NSString *_serverIP;
    NSString *_port;
    NSString *_username;
    NSString *_password;
    NSString *_imServerIp;
    LoginCompleteHandler _loginCompleteHandler;
}
@end







@implementation LoginManager




#pragma mark - Public

- (void)loginWithServerIP:(NSString *)serverIP
                     port:(NSString *)port
                 username:(NSString *)username
                 password:(NSString *)password
          completeHandler:(LoginCompleteHandler)complete
{
    _loginCompleteHandler = [complete copy];
    _serverIP = serverIP;
    _port = port;
    _username = username;
    _password = password;
    // 登录计时器
    [LoginManager shareHelper].loginTimeoutTimer =
    [NSTimer scheduledTimerWithTimeInterval:15
                                     target:self
                                   selector:@selector(loginTimeout)
                                   userInfo:nil
                                    repeats:NO];
    
    [INFManager.share downloadINFWithIP:serverIP
                              completed:^(NSDictionary *infDict, LTError *error) {
                                  if (error)
                                  {
                                      _loginCompleteHandler(error);
                                  }else{
                                       BOOL LDAPEnable = [infDict[kLDAPAuthEnable] boolValue];
                                       BOOL MD5Enable  = [infDict[kMD5Enable] boolValue];

                                       LoginType loginType = LoginType_Normal;
                                       if ( LDAPEnable ) {
                                           loginType = LoginType_LDAP;
                                       }else if ( MD5Enable ) {
                                           loginType = LoginType_MD5;
                                       }
                                       [self loginByLoginType:loginType];
                                  }
                              }];
}

- (void)loginByLoginType:(LoginType)loginType {
    NSString *password = [NSString stringWithString:_password];

    switch ( loginType ) {
        case LoginType_Normal: {
            [self loginWithPassword:password withLoginType:LoginType_Normal];
        }
            break;
        case LoginType_MD5: {
            [self loginWithPassword:[password md5] withLoginType:LoginType_MD5];
        }
            break;
        case LoginType_LDAP: {
            
        }
            break;
        default:
            break;
    }
}

- (void)loginWithPassword:(NSString *)password
            withLoginType:(LoginType)loginType {
    
//    BOOL enableLDAP = loginType == LoginType_LDAP;
//    NSString *ip = _imServerIp ? _imServerIp :_serverIP;
    __weak typeof(self) weakself = self;
    [LTXMPPManager.share loginWithaIP:_serverIP
                                 port:_port
                             username:_username
                             password:_password
                           enableLDAP:NO
                            completed:^(LTError *error) {
                                if (error)
                                {
                                    _loginCompleteHandler(error);
                                    [weakself loginFailure];
                                }else{
                                    [weakself loginSuccess];
                                }
                            }];
}











#pragma mark - Private

- (void)loginSuccess {
    /**销毁定时器**/
    [self destoryTimer];
    
    /**上线**/
    [self changePresenceStatuToOnline];
    
    /**下载组织架构**/
    //[self downloadOrg];
    
    /**更新最后的登录用户**/
    [self updateLastLoginUser];
    
    
//    [XMPPManager getAllSingleChatterPhotoHash];
//    /**极光推送-设置别名**/
//    [AppDelegateInstance JPush_setAlias];
//    /**保存pid**/
//    AppDelegateInstance.pidToken = UserManager.shareInstance.currentUser.pid;
    /**发送登录成功的通知**/
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:Wiseuc_Notification_LoginSuccess object:nil];

    if ( _loginCompleteHandler ) {
        _loginCompleteHandler(nil);
    }
}

/**登录超时**/
- (void)loginTimeout {
    [self destoryTimer];
    if ( _loginCompleteHandler ) {
        LTError *err = [LTError errorWithDescription:@"登录超时" code:(LTErrorLogin_loginTimeOut)];
        _loginCompleteHandler(err);
    }
}

/**登录失败**/
-(void)loginFailure {
    [self destoryTimer];
}

/**销毁定时器**/
- (void)destoryTimer {
    [self.loginTimeoutTimer invalidate];
    self.loginTimeoutTimer = nil;
}

/**上线**/
- (void)changePresenceStatuToOnline {
    
//    NSDictionary  *userDict = [LTUser.share queryUser];
//    NSString *UserName = userDict[@"UserName"];
//    NSString *JID = userDict[@"JID"];
//    NSString *IMPwd = userDict[@"IMPwd"];
    
    //[XMPPManager jid:JID changePresenceStatuTo:PresenceType_Online];
    //[XMPPManager requestHeaderIconURLWithJID:[UserManager shareInstance].currentUser.jid];
}


/**登录历史**/
- (void)updateLastLoginUser {
    [LTLogin.share updateLastLoginUserWithUsername:_username
                                          password:_password
                                                ip:_serverIP
                                              port:_port];
}



#pragma mark - Init

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    static LoginManager *helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [[LoginManager alloc] init];
    });
    return helper;
}



@end
