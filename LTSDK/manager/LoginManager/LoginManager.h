//
//  LoginManager.h
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LoginHistoryModel.h"
#import "LTSDKFull.h"


/**
 * 登录状态枚举
 *
 *
 **/
typedef enum {
    LoginStateType_first,              //第一次登录
    LoginStateType_login,              //登录中
    LoginStateType_loginButTerminate,  //登录中，但销毁
    LoginStateType_logout,             //登出
}LoginStateType;


typedef enum {
    LoginType_Normal,
    LoginType_LDAP,
    LoginType_MD5
} LoginType;
typedef void(^LoginCompleteHandler)(LTError *error);



@interface LoginManager : NSObject
@property (nonatomic, strong) NSTimer *loginTimeoutTimer;   //!< 登录超时定时器
@property (nonatomic, assign) BOOL haveLogined;             //!< 已经登录过(不管成功，还是失败)
@property (nonatomic, assign) BOOL haveLaunched;            //!< 启动程序
@property (nonatomic, assign) LoginStateType loginStateType;
@property (nonatomic, strong) NSString *loginName;          //!< 登录名
@property (nonatomic, strong) NSString *loginPassword;      //!< 密码



+ (instancetype)shareHelper;
- (void)loginWithServerIP:(NSString *)serverIP
                     port:(NSString *)port
                 username:(NSString *)username
                 password:(NSString *)password
          completeHandler:(LoginCompleteHandler)complete;

@end
