//
//  LTXMPPManager.h
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
#import "XMPPLib.h"
#import "XMPPManager+IQ.h"
#import "AppManager.h"
#import "XMPPStream+secure.h"
#import "Encrypt_Decipher.h"
#import "LT_Macros.h"
typedef void(^LTXMPPManagerLoginBlock)(LTError *error);



@interface LTXMPPManager : NSObject
{
    BOOL _enableLDAP;
    NSString *_ip;
    NSString *_port;
    NSString *_username;
    NSString *_password;
}
@property (nonatomic, strong) LTXMPPManagerLoginBlock aXMPPManagerLoginBlock;
@property (nonatomic, strong) XMPPStream    *aXMPPStream;
@property (nonatomic, strong) XMPPRoster    *aXMPPRoster;
@property (nonatomic, strong) XMPPReconnect *aXMPPReconnect;
@property (nonatomic, strong) XMPPAutoPing  *aXMPPAutoPing;
@property (nonatomic, strong) XMPPRosterCoreDataStorage  *aXMPPRosterCoreDataStorage;


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  ..
 */
+ (instancetype)share;


/*!
 @method
 @abstract 登录操作
 @discussion 使用auth-server连接服务器，获取真实用户登录信息
 @param aIP ip
 @param aPort 端口
 @param aUsername 用户名
 @param aPassword 密码
 */
- (void)loginWithaIP:(NSString *)aIP
                port:(NSString *)aPort
            username:(NSString *)aUsername
            password:(NSString *)aPassword
          enableLDAP:(BOOL)aEnableLDAP
           completed:(LTXMPPManagerLoginBlock)aXMPPManagerLoginBlock;



/*!
 @method
 @abstract 再次连接服务器
 @discussion 接收到授权iq后，使用返回的真实信息重连服务器
 @param aJID jid
 @param aPassword 密码
 @param aResource 资源
 */
- (void)loginAgainWithJID:(NSString *)aJID
                 password:(NSString *)aPassword
                 resource:(NSString *)aResource;


/*!
 @method
 @abstract 验证密码
 @discussion null
 */
-(void)loginAuthWithPassword:(NSString *)aPassword;


@end
