//
//  LinphoneManager.m
//  LTSDK
//
//  Created by JH on 2017/12/29.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LT_LinphoneManager.h"
#import "Encrypt_Decipher.h"
#import "LT_HttpRequestManager.h"


@interface LT_LinphoneManager ()
{
//    LinphoneAccountCreator *account_creator;
//    LinphoneProxyConfig *newProxyConfig;
    
    NSString *_voip;               //voip推送令牌
    NSString *_apns;               //apns推送令牌
    NSNumber *_platform;           //platform平台
    NSString *_serverip;           //服务器ip
    NSString *_serverport;         //服务器端口
    NSString *_voipPort;           //sip端口：5060，25060
    NSString *_accountID;          //
    
    NSString *_username;   //普通登录——用户名
    NSString *_password;   //普通登录--密码
    NSString *_registerIdentifies; //唯一标识，也是注册的东西 如手机号，用户id  sip:028@192.168.1.168
    NSString *_registerJIDIdentifies; //唯一标识JID
    NSString *_voipTransport;      //tcp,udp,tls
    
    NSString *_displayName;//普通登录--一般就是用户名
    NSString *_domain;     //普通登录--域名
}
@property (nonatomic, strong) LinphoneManager_settingPushKitBlock settingPushKitBlock;  //Pushkit初始化设置回调
@end







@implementation LT_LinphoneManager




+ (instancetype)share {
    static LT_LinphoneManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LT_LinphoneManager alloc] init];
    });
    return instance;
}




/*!
 @method
 @abstract 初始化设置
 @discussion
 @param apns 远程推送apnsToken
 @param voip voipToken
 @param platform     平台 （1.iOS  2.Android  3.Window）
 @param serverip     服务器地址
 @param serverPort   服务器端口
 @param voipport     sip服务端口(默认为5060，默认的端口在部署到外网的时候会被电信运营商屏蔽，因此需要配合服务端修改为其他端口 如：25060)
 @param username     用户名
 @param password     密码
 @param registerIdentifies 用户唯一标识（一般为pid，jid,手机号）
 @param registerJIDIdentifies JID
 @param transport    数据传输方式tcp(推荐使用)，udp，ssl／tls
 @param completed    回调：sip服务是否注册成功
 */
-(void)settingPushKitManagerWithAPNsToken:(NSString *)apns
                                VoIPToken:(NSString *)voip
                                 platform:(NSNumber *)platform
                                 serverip:(NSString *)serverip
                               serverPort:(NSString *)serverPort
                                 voipPort:(NSString *)voipport
                                accountID:(NSString *)accountID

                                 username:(NSString *)username
                                 password:(NSString *)password
                       registerIdentifies:(NSString *)registerIdentifies
                    registerJIDIdentifies:(NSString *)jid
                                transport:(NSString *)transport
                                completed:(LinphoneManager_settingPushKitBlock)block
{
    
    _apns                  = apns;
    _voip                  = voip;
    _platform              = platform;
    _serverip              = serverip;
    _serverport            = serverPort;
    _voipPort              = voipport;
    _accountID             = accountID;
    
    _username              = username;
    _password              = password;
    _registerIdentifies    = registerIdentifies;
    _registerJIDIdentifies = jid;
    _voipTransport         = transport;
    self.settingPushKitBlock = block;
    
    
    
    //推送证书到公司服务器
    [self pushTokenToCompanyServerWithAPNsToken:_apns
                                      VoIPToken:_voip
                                       platform:_platform
                                       serverIP:_serverip
                                       voipPort:_voipPort
                                      accountID:_accountID];
    
    
    //用户向服务器注册sip服务
    [self sipRegisterWithUserName:_username
                         Password:_password
                       Identifies:_registerIdentifies
                    jidIdentifies:_registerJIDIdentifies
                     voipServerIP:_serverip
                         voipPort:_voipPort
                        Transport:_voipTransport];
    
}




/**
 推送证书到公司服务器
 **/
- (void)pushTokenToCompanyServerWithAPNsToken:(NSString *)apns
                                    VoIPToken:(NSString *)voip
                                     platform:(NSNumber *)platform
                                     serverIP:(NSString *)serverip
                                     voipPort:(NSString *)voipport
                                    accountID:(NSString *)accountID
{
    if ([apns isEqualToString:@""]          || apns == nil          ||
        [voip isEqualToString:@""]          || voip == nil          ||
        [serverip isEqualToString:@""]      || serverip == nil      ||
        [voipport isEqualToString:@""]      || voipport == nil       )
    {
        NSLog(@"==========================error=============================");
        NSLog(@"PushKitManager错误: 视频通话注册信息不全,请完善后重试！");
        NSLog(@"apns: %@",apns);
        NSLog(@"voip: %@",voip);
        NSLog(@"platform: %@",platform);
        NSLog(@"voipserverip  : %@",serverip);
        NSLog(@"voipport  : %@",voipport);
        NSLog(@"accountID  : %@",accountID);
        NSLog(@"==========================error=============================");
        return;
    }
    
    
    //url: 192.168.1.199:25060/mobile/user/updatePushToken
    //1.ios  2.android
    NSString *urlString  = [NSString stringWithFormat:@"%@:%@/%@",serverip,voipport,@"mobile/user/updatePushToken"];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *loginToken = [[NSString stringWithFormat:@"%@%@",accountID,idfv] md5];
    
    NSDictionary  *parameters = @{
                                  @"platform":@(1),
                                  @"voip":voip,
                                  @"apns":apns,
                                  @"loginToken":loginToken
                                  };
    
    HttpRequestManager *manager = [[HttpRequestManager alloc] init];
    [manager postWithUrlString:urlString
                    parameters:parameters
               complitionBlock:^(NSURLSessionDataTask *task, id response, NSError *error) {
                   if (response)
                   {
                       NSLog(@"Linphone:调试：%@",response);
                       if ([response[@"s"] isEqualToNumber:@(1001)]) {
                           NSLog(@"语音视频相关证书apns、voip上传成功！");
                       }
                   } else {
                       NSLog(@"调试：%@",error.localizedDescription);  /**不支持的URL**/
                       NSLog(@"证书上传失败，请检查 1.服务器是否打开 2.请配合服务端设置相关信息！");
                   }
               }];
}






/**
 向服务器注册sip服务
 
 @param username 用户名
 @param password 密码
 @param serverIP 服务器ip
 @param identifies 唯一标识
 @param serverPort 端口
 @param transport 传输方式
 */
- (void)sipRegisterWithUserName:(NSString *)username
                       Password:(NSString *)password
                     Identifies:(NSString *)identifies
                  jidIdentifies:(NSString *)jid
                   voipServerIP:(NSString *)voipServerIP
                       voipPort:(NSString *)voipPort
                      Transport:(NSString *)transport {
    
    if ([username isEqualToString:@""]     ||  username == nil     ||
        [password isEqualToString:@""]     ||  password == nil     ||
        [voipServerIP isEqualToString:@""] ||  voipServerIP == nil ||
        [identifies isEqualToString:@""]   ||  identifies == nil   ||
        [jid isEqualToString:@""]          ||  jid == nil          ||
        [voipPort isEqualToString:@""]     ||  voipPort == nil     ||
        [transport isEqualToString:@""]    ||  transport == nil     )
    {
        return;
    }
    NSLog(@"==========================message=============================");
    NSLog(@"username:     %@",username);
    NSLog(@"password:     %@",password);
    NSLog(@"voipServerIP: %@",voipServerIP);
    NSLog(@"identifies:   %@",identifies);
    NSLog(@"jid:          %@",jid);
    NSLog(@"voipPort:     %@",voipPort);
    NSLog(@"transport:    %@",transport);
    NSLog(@"==========================message=============================");
    
    
    
    /**
     username       sip:219@demo.wiseuc.com
     password       666666
     displayName2:  80010;80010@wiseuc
     domain:        demo.wiseuc.com:25060
     port:          nil
     transport:     tcp
     **/
    
    NSString *account     = [NSString stringWithFormat:@"sip:%@@%@",identifies,voipServerIP]; // sip:028@192.168.1.168
    NSString *domainstr   = [NSString stringWithFormat:@"%@:%@",voipServerIP,voipPort];   //192.168.1.168:5060
    NSString *displayName = [NSString stringWithFormat:@"%@;%@",username,jid];  /**80010;80010@wiseuc**/
    [self registerWithUsername:account
                      password:password
                   displayName:displayName
                        domain:domainstr
                          port:nil
                 withTransport:transport];
}



/**
 注册
 
 @param username 用户名
 @param password 密码
 @param displayName 显示的名字
 @param domain 域名
 @param port 端口
 @param transport 传输方式
 @return 返回值
 */
- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
                 displayName:(NSString *)displayName
                      domain:(NSString *)domain
                        port:(NSString *)port
               withTransport:(NSString *)transport
{
    /**
     username       sip:219@demo.wiseuc.com
     password       666666
     displayName2:  80010;80010@wiseuc
     domain:        demo.wiseuc.com:25060
     port:          nil
     transport:     tcp
     **/
    
//    [self resetLinphoneCore];
//    linphone_account_creator_set_username(account_creator, username.UTF8String);
//    linphone_account_creator_set_password(account_creator, password.UTF8String);
//    linphone_account_creator_set_domain(account_creator, domain.UTF8String);
//    linphone_account_creator_set_display_name(account_creator, displayName.UTF8String);
//
//    //传输方式
//    linphone_account_creator_set_transport(account_creator,linphone_transport_parse(transport.lowercaseString.UTF8String));
//    LinphoneManager *lm = LinphoneManager.instance;
//    if (newProxyConfig != NULL) {
//        const LinphoneAuthInfo *auth = linphone_proxy_config_find_auth_info(newProxyConfig);
//        linphone_core_remove_proxy_config(LC, newProxyConfig);
//        if (auth) {
//            linphone_core_remove_auth_info(LC, auth);
//        }
//    }
//
//
//    //配置文件
//    newProxyConfig = linphone_account_creator_configure(account_creator);
//    if (newProxyConfig) {
//        [lm configurePushTokenForProxyConfig:newProxyConfig];
//        linphone_core_set_default_proxy_config(LC, newProxyConfig);
//        [[LinphoneManager.instance fastAddressBook] reload];
//
//        [NSNotificationCenter.defaultCenter addObserver:self
//                                               selector:@selector(callUpdate:)
//                                                   name:kLinphoneCallUpdate
//                                                 object:nil];
//        if (_linphoneManagerSettingPushKitBlock) {
//            _linphoneManagerSettingPushKitBlock(YES);
//        }
//    } else {
//        if (_linphoneManagerSettingPushKitBlock) {
//            _linphoneManagerSettingPushKitBlock(NO);
//        }
//    }
}












@end
