//
//  LTINF.m
//  WiseUC
//
//  Created by JH on 2017/12/7.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "LTINF.h"
#define kLTINF_isDeployKey @"kLTINF_isDeployKey"
#define kLTINF_isLinuxKey @"kLTINF_isLinuxKey"
#define kLTINF_isCheckKey @"kLTINF_isCheckKey"
#define kLTINF_isAckEnableKey @"kLTINF_isAckEnableKey"

#define kLTINF_isMD5EnableKey @"kLTINF_isMD5EnableKey"
#define kLTINF_isLDAPAuthEnableKey @"kLTINF_isLDAPAuthEnableKey"
#define kLTINF_MsgServerConnAddrKey @"kLTINF_MsgServerConnAddrKey"
#define kLTINF_FtpURLServerConfigKey @"kLTINF_FtpURLServerConfigKey"

@interface LTINF ()

/**
 os = linux,
 ackEnable = 0,
 appstate = check
 MD5Enable = 0,
 LDAPAuthEnable = 0,

 MsgServerConnAddr = tcp://112.74.74.80:5225,
 ftpURLServerConfig = im.lituosoft.cn:6100,
 **/


/*!
 @property
 @abstract INF文件是否配置isLinux和isCheck
 */
@property (nonatomic, assign) BOOL isDeploy;
/*!
 @property
 @abstract 是否使用了Linux服务器
 */
@property (nonatomic, assign) BOOL isLinux;
/*!
 @property
 @abstract 是否审核通过
 */
@property (nonatomic, assign) BOOL isCheck;
/*!
 @property
 @abstract INF是否配置已阅未阅
 */
@property (nonatomic, assign) BOOL isAckEnable;


/*!
 @property
 @abstract INF是否MD5加密
 */
@property (nonatomic, assign) BOOL isMD5Enable;
/*!
 @property
 @abstract INF是否LDAP加密
 */
@property (nonatomic, assign) BOOL isLDAPAuthEnable;
/*!
 @property
 @abstract 消息漫游连接服务器地址（为空的话表示无消息漫游功能）
 */
@property (nonatomic, strong) NSString *MsgServerConnAddr;
/*!
 @property
 @abstract
 */
@property (nonatomic, strong) NSString *ftpURLServerConfig;

@end






@implementation LTINF


+ (instancetype)share {
    static LTINF *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTINF alloc] init];
    });
    return instance;
}

-(void)updateINF:(BOOL)ret key:(NSString *)key{
    [NSUserDefaults.standardUserDefaults
     setBool:ret
     forKey:key];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (BOOL)queryWithKey:(NSString *)key {
    BOOL ret =
    [NSUserDefaults.standardUserDefaults
     boolForKey:key];
    return ret;
}
- (void)deleteWithKey:(NSString *)key {
    [NSUserDefaults.standardUserDefaults
     setBool:NO
     forKey:key];
    [NSUserDefaults.standardUserDefaults synchronize];
}




#pragma mark -================= isDeploy

-(void)updateINFWithIsDeploy:(BOOL)isDeploy {
    [self updateINF:isDeploy key:kLTINF_isDeployKey];
}
- (BOOL)queryIsDeploy {
    return [self queryWithKey:kLTINF_isDeployKey];
}
- (void)deleteIsDeploy {
    [self deleteWithKey:kLTINF_isDeployKey];
}

#pragma mark -================= isLinux

-(void)updateINFWithIsLinux:(BOOL)ret {
[self updateINF:ret key:kLTINF_isLinuxKey];
}
- (BOOL)queryIsLinux {
    return [self queryWithKey:kLTINF_isLinuxKey];
}
- (void)deleteIsLinux {
    [self deleteWithKey:kLTINF_isLinuxKey];
}

#pragma mark -================= isLinux

-(void)updateINFWithIsCheck:(BOOL)ret {
    [self updateINF:ret key:kLTINF_isCheckKey];
}
- (BOOL)queryIsCheck {
    return [self queryWithKey:kLTINF_isCheckKey];
}
- (void)deleteIsCheck {
    [self deleteWithKey:kLTINF_isCheckKey];
}

#pragma mark -================= isAckEnable

-(void)updateINFWithIsAckEnable:(BOOL)ret {
    [self updateINF:ret key:kLTINF_isAckEnableKey];
}
- (BOOL)queryIsAckEnable {
    return [self queryWithKey:kLTINF_isAckEnableKey];
}
- (void)deleteIsAckEnable {
    [self deleteWithKey:kLTINF_isAckEnableKey];
}



#pragma mark -================= isMD5Enable

-(void)updateINFWithisMD5Enable:(BOOL)ret {
    [self updateINF:ret key:kLTINF_isMD5EnableKey];
}
- (BOOL)queryisMD5Enable {
    return [self queryWithKey:kLTINF_isMD5EnableKey];
}
- (void)deleteisMD5Enable {
    [self deleteWithKey:kLTINF_isMD5EnableKey];
}


#pragma mark -================= isLDAPAuthEnable

-(void)updateINFWithisLDAPAuthEnable:(BOOL)ret {
    [self updateINF:ret key:kLTINF_isLDAPAuthEnableKey];
}
- (BOOL)queryisLDAPAuthEnable {
    return [self queryWithKey:kLTINF_isLDAPAuthEnableKey];
}
- (void)deleteisLDAPAuthEnable {
    [self deleteWithKey:kLTINF_isLDAPAuthEnableKey];
}



#pragma mark -================= MsgServerConnAddr

-(void)updateINFWithMsgServerConnAddr:(NSString *)ret {
    [NSUserDefaults.standardUserDefaults
     setObject:ret
     forKey:kLTINF_MsgServerConnAddrKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (NSString *)queryMsgServerConnAddr {
    NSString *ret =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kLTINF_MsgServerConnAddrKey];
    return ret;
}
- (void)deleteMsgServerConnAddr {
    [NSUserDefaults.standardUserDefaults
     setObject:nil
     forKey:kLTINF_MsgServerConnAddrKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark -================= MsgServerConnAddr

-(void)updateINFWithFtpURLServerConfig:(NSString *)ret {
    [NSUserDefaults.standardUserDefaults
     setObject:ret
     forKey:kLTINF_FtpURLServerConfigKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (NSString *)queryFtpURLServerConfig {
    NSString *ret =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kLTINF_FtpURLServerConfigKey];
    return ret;
}
- (void)deleteFtpURLServerConfig {
    [NSUserDefaults.standardUserDefaults
     setObject:nil
     forKey:kLTINF_FtpURLServerConfigKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}
@end
