//
//  LinphoneManager.m
//  LTSDK
//
//  Created by JH on 2017/12/29.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LinphoneManager.h"

@interface LinphoneManager ()
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
@property (nonatomic, strong) UIViewController *chatterController;  //视频语音控制器
@property (nonatomic, strong) UIViewController *mainController;  //程序主控制器
@property (nonatomic, strong) LinphoneManager_settingPushKitBlock settingPushKitBlock;  //Pushkit初始化设置回调
@end







@implementation LinphoneManager




+ (instancetype)share {
    static LinphoneManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LinphoneManager alloc] init];
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
 @param chatterVC    视频语音控制器
 @param mainVC       主控制器
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
                                chatterVC:(UIViewController *)chatterController
                                   mainVC:(UIViewController *)mainController
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
    _chatterController     = chatterController;
    _mainController        = mainController;
    self.settingPushKitBlock = block;
    
    
    
    
    
}





@end
