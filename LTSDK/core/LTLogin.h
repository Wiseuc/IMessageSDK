//
//  LTLogin.h
//  WiseUC
//
//  Created by JH on 2017/12/6.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTError.h"




typedef enum : NSUInteger {
    MyLoginState_NoLoginRecord = 1, /**无登录记录**/
    MyLoginState_Login,  /**有登录记录，登录状态**/
    MyLoginState_Logout  /**有登录记录，登出状态**/
} MyLoginState;


typedef void(^LTLogin_LoginBlock)(LTError *error);
typedef void(^LTLogin_LoginCheckBlock)(MyLoginState aLoginState);
typedef void(^LTLogin_LogoutBlock)(LTError *error);





@interface LTLogin : NSObject


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 登录
 @discussion Async异步登录
 @param aUsername     用户名
 @param aPassword     密码
 @param aIP     服务器地址
 @param aPort         端口
 @param aLoginBlock 回调
 */
- (void)asyncLoginWithUsername:(NSString *)aUsername
                      password:(NSString *)aPassword
                      serverIP:(NSString *)aIP
                          port:(NSString *)aPort
                     completed:(LTLogin_LoginBlock)aLoginBlock;


/*!
 @method
 @abstract 登出
 @discussion Async异步登出
 */
-(void)asyncLogout;




/*!
 @method
 @abstract 登录检测
 @discussion 用于网络状态改变，来检测登录状态，
 1.如果已经登录状态，略过，
 2.如果为登出状态和非登录中状态，则会执行LTClientDelegate 的代理方法 -(void)willAutoLogin用于准备自动登录
 */
- (void)loginCheck:(LTLogin_LoginCheckBlock)aLoginCheckBlock;



/*!
 @method
 @abstract 获取最后一个用户
 @discussion 返回的是字典aUsername\ aPassword\ aIP\ aPort
 @result  字典
 */
- (NSDictionary *)queryLastLoginUser;
- (void)deleteLastLoginUser;
- (void)updateLastLoginUserWithUsername:(NSString *)aUsername
                               password:(NSString *)aPassword
                                     ip:(NSString *)aIP
                                   port:(NSString *)aPort;





#pragma mark -================= 登录状态
- (void)updateLoginState:(BOOL)ret ;
- (BOOL)queryLoginState ;
- (void)deleteLoginState ;


@end
