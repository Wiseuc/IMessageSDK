//
//  LinphoneManager.h
//  LTSDK
//
//  Created by JH on 2017/12/29.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"

typedef void(^LinphoneManager_settingPushKitBlock)(NSDictionary *dict, LTError *error);


@interface LT_LinphoneManager : NSObject


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;






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
                                completed:(LinphoneManager_settingPushKitBlock)block;




@end
