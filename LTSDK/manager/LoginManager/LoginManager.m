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
//#import "SoapRequest.h"
#import "Encrypt_Decipher.h"
//#import "UserManager.h"
//#import "XMPPManager.h"
#import "LTXMPPManager.h"
//#import "XMPPManager+IQ.h"
//#import "XMPPManager+Presence.h"
//#import "OrgManager.h"
//#import "GetGroupsDataModel.h"
//#import "XMLParserManager.h"
//#import "DownloadOrganizationsController.h"
//#import "AppDelegate+JPush.h"
//#import "SVProgressHUD+Custom.h"
//#define KLoginSuccess @"登录成功"



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


static LoginManager *helper = nil;
@implementation LoginManager
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LoginManager alloc] init];
    });
    return helper;
}

#pragma mark – 登录操作

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


- (void)loginWithPassword:(NSString *)password withLoginType:(LoginType)loginType {
    
    BOOL enableLDAP = loginType == LoginType_LDAP;
    NSString *ip = _imServerIp ? _imServerIp :_serverIP;
    
    [LTXMPPManager.share loginWithaIP:_serverIP
                                 port:_port
                             username:_username
                             password:_password
                           enableLDAP:NO
                            completed:^(id response, LTError *error) {
                                
                            }];
    
//    [XMPPManager.share loginWithaIP:_serverIP
//                               port:_port
//                           username:_username
//                           password:_password
//                         enableLDAP:NO
//                          completed:^(id response, LTError *error) {
//
////                              if(error)
////                              {
////                                  if(_loginCompleteHandler){
////                                      _loginCompleteHandler(error);
////                                  }
////                              }else{
////
////
////                              }
//                          }];
    
                              
                              //                              if ( info ) {
                              //
                              //                                /**保存用户信息*用于回填登录界面用户名密码框**/
                              //                                [LoginManager saveLastLoginUsername:_username
                              //                                                           password:_password
                              //                                                           serverIP:_serverIP
                              //                                                               port:_port];
                              //                                UserModel *userModel = (UserModel *)info;
                              //                                [UserManager shareInstance].noDisturbingForSound = YES;
                              //                                [UserManager shareInstance].currentUser = [[IUserInfo alloc] init];
                              //
                              //                                /**除掉 ‘/IphoneIM’**/
                              //                                NSString *jid = [[[NSString stringWithFormat:@"%@",
                              //                                                   [XMPPManager shareXMPPManager].xmppStream.myJID] componentsSeparatedByString:@"/"] objectAtIndex:0];
                              //                                NSDictionary *dict = @{
                              //                                                      @"jid":jid,
                              //                                                      @"username":_username,
                              //                                                      @"loginType":@(loginType),
                              //                                                      @"password":_password,
                              //                                                      @"serverIP":_serverIP,
                              //                                                      @"serverPort":_port,          //LoginManager的数据
                              //                                                      @"pid":userModel.PID,
                              //                                                      @"AccoutID":userModel.AccountID,
                              //                                                      @"orgName":userModel.AccountName
                              //                                                      };
                              //
                              //                                /**实际上dict是 LTUser 和 LTLogin 的合集**/
                              //                                /**UserManager shareInstance].currentUser 则是包括组织架构中的信息，用LTOrg替代**/
                              //
                              //
                              //                                /**储存用户信息: 到UserManager**/
                              //                                [[UserManager shareInstance].currentUser setValuesForKeysWithDictionary:dict];
                              //
                              //                                /**上线**/
                              //                                NSString *presenceJID =
                              //                                [NSString stringWithFormat:@"%@/IphoneIM",[UserManager shareInstance].currentUser.jid];
                              //                                [XMPPManager jid:presenceJID changePresenceStatuTo:PresenceType_Online];
                              //
                              //                                [self loginSuccess];
                              //                                [self downloadOrgFileAndReloadData];
                              //                                [XMPPManager requestHeaderIconURLWithJID:[UserManager shareInstance].currentUser.jid];
                              //                            }else {
                              //                                [self loginFailedByError:error];
                              //                            }
                              //                          }];
}

- (void)loginSuccess {
    [[LoginManager shareHelper].loginTimeoutTimer invalidate];
    [LoginManager shareHelper].loginTimeoutTimer = nil;
//    [XMPPManager getAllSingleChatterPhotoHash];
//
//    /**极光推送-设置别名**/
//    [AppDelegateInstance JPush_setAlias];
//
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
    [[LoginManager shareHelper].loginTimeoutTimer invalidate];
    [LoginManager shareHelper].loginTimeoutTimer = nil;
    if ( _loginCompleteHandler ) {
        LTError *err = [LTError errorWithDescription:@"登录超时" code:(LTErrorLogin_loginTimeOut)];
        _loginCompleteHandler(err);
    }
}




- (void)loginFailedByError:(NSError *)error {
//    [[LoginManager shareHelper].loginTimeoutTimer invalidate];
//    [LoginManager shareHelper].loginTimeoutTimer = nil;
//
//    NSString *err = @"登录失败005";
//    if ( [error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"Connection refused"] )
//    {
//        if ( _loginCompleteHandler ) {
//            LTError *err = [LTError errorWithDescription:@"服务器地址错误" code:(LTErrorLogin_InvalidIp)];
//            _loginCompleteHandler(err);
//        }
//    }
//    else if ( error.userInfo[kStringXMPPIQAccessAuth] )
//    {
//        err = error.userInfo[kStringXMPPIQAccessAuth];
//
//        if ( _loginCompleteHandler ) {
//            LTError *error = [LTError errorWithDescription:err code:(LTErrorLogin_loginGeneralFailure)];
//            _loginCompleteHandler(error);
//        }
//    }
}

// 先下载组织架构
- (void)downloadOrgFileAndReloadData
{
//    NSString *orgFilePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.xml"];
//    [UserManager shareInstance].currentUser.filePath = orgFilePath;
//    [OrgManager downloadAndParserOrgZipWithLocalOrgVersion:NO completeHandler:^(BOOL complete) {
//        if ( complete ) {
//            OrgModel *orgModel = [XMLParserManager getPersonInfoByJid:[UserManager shareInstance].currentUser.jid];
//            if (orgModel) {
//                [UserManager shareInstance].currentUser.jid = orgModel.JID;
//                [UserManager shareInstance].currentUser.username = orgModel.LoginName;
//                [UserManager shareInstance].currentUser.nickname = orgModel.NAME;
//                [UserManager shareInstance].currentUser.pid = orgModel.PID;
//            }
//
//            //上线
//            NSString *presenceJID = [NSString stringWithFormat:@"%@/IphoneIM",[UserManager shareInstance].currentUser.jid];
//            [XMPPManager jid:presenceJID changePresenceStatuTo:PresenceType_Online];
//
//            //获取头像
//            [XMPPManager requestHeaderIconURLWithJID:[UserManager shareInstance].currentUser.jid];
//
//            //获取可视范围
//            [OrgManager getOrgVisibleRange:^(BOOL hasOrgVisible, NSArray *visibleRangeArray) {
//                [[NSNotificationCenter defaultCenter]
//                 postNotificationName:Wiseuc_Notification_OrgDownloadAndOrgvisibleRange object:nil];
//            }];
//        }
//    }];
//    //获取群组信息
//    GetGroupsDataModel *getGroupsDataModel = [[GetGroupsDataModel alloc] init];
//    [getGroupsDataModel getGroupsDataDictionary];
}
//
//#pragma mark – 登录历史
//
//+ (void)saveLastLoginUsername:(NSString *)username
//                     password:(NSString *)password
//                     serverIP:(NSString *)serverIP
//                         port:(NSString *)port {
//    NSDictionary *newAccount = @{@"username":username,
//                                 @"password":password,
//                                 @"serverIP":serverIP,
//                                 @"port":port};
//    LoginHistoryModel *model = [[LoginHistoryModel alloc] init];
//    [model setValuesForKeysWithDictionary:newAccount];
//    [LoginManager saveLoginAccount:model];
//}
//
//+ (void)saveLoginAccount:(LoginHistoryModel *)newAccount {
//    NSDictionary *newAccountDict = [self dictionaryWithAccount:newAccount];
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *historyAccount = [userDefaults objectForKey:Wiseuc_NSUserDefaults_HistoryAccount];
//    if ( historyAccount && historyAccount.count > 0 ) {
//        NSMutableArray *mHisAccount = [NSMutableArray arrayWithArray:historyAccount];
//        NSMutableArray *tempMHisAccount = [NSMutableArray arrayWithArray:historyAccount];
//        for ( NSDictionary *accountDict in tempMHisAccount ) {
//            if ( [accountDict[@"username"] isEqualToString:newAccount.username] ) {
//                [mHisAccount removeObject:accountDict];
//            }
//        }
//
//        if ( mHisAccount.count >= 4 ) {
//            [mHisAccount removeObjectAtIndex:mHisAccount.count - 1];
//        }
//        [mHisAccount insertObject:newAccountDict atIndex:0];
//        [userDefaults setObject:mHisAccount forKey:Wiseuc_NSUserDefaults_HistoryAccount];
//        [userDefaults synchronize];
//    }
//    else {
//        historyAccount = [NSArray arrayWithObject:newAccountDict];
//        [userDefaults setObject:historyAccount forKey:Wiseuc_NSUserDefaults_HistoryAccount];
//        [userDefaults synchronize];
//    }
//}
//
//+ (void)deleteLoginAccount:(LoginHistoryModel *)account {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *historyAccount = [userDefaults objectForKey:Wiseuc_NSUserDefaults_HistoryAccount];
//    if ( historyAccount && historyAccount.count > 0 ) {
//        NSMutableArray *mHisAccount = [NSMutableArray arrayWithArray:historyAccount];
//        NSMutableArray *tempMHisAccount = [NSMutableArray arrayWithArray:historyAccount];
//        for ( NSDictionary *accountDict in tempMHisAccount ) {
//            if ( [accountDict[@"username"] isEqualToString:account.username] ) {
//                [mHisAccount removeObject:accountDict];
//            }
//        }
//        [userDefaults setObject:mHisAccount forKey:Wiseuc_NSUserDefaults_HistoryAccount];
//        [userDefaults synchronize];
//    }
//}
//
//+ (NSArray *)loginHistory {
//    NSArray *loginHistoryAccountArray = [[NSUserDefaults standardUserDefaults] objectForKey:Wiseuc_NSUserDefaults_HistoryAccount];
//    if ( loginHistoryAccountArray.count > 0 ) {
//        return loginHistoryAccountArray;
//    }
//    return nil;
//}
//
//+ (LoginHistoryModel *)lastLoginHistoryModel {
//    if ( [self loginHistory] ) {
//        NSDictionary *lastAccout = [self loginHistory][0];
//        LoginHistoryModel *lastHistoryModel = [[LoginHistoryModel alloc] init];
//        lastHistoryModel.username = lastAccout[@"username"];
//        lastHistoryModel.serverIP  = lastAccout[@"serverIP"];
//        lastHistoryModel.password  = lastAccout[@"password"];
//        lastHistoryModel.port = lastAccout[@"port"];
//        return lastHistoryModel;
//    }
//    return nil;
//}
//
//#pragma mark - private
//
//+ (NSDictionary *)dictionaryWithAccount:(LoginHistoryModel *)account {
//    return @{@"username":account.username,
//             @"password":account.password,
//             @"serverIP":account.serverIP,
//             @"port":account.port};
//}

@end
