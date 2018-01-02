//
//  VoipManager.m
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "VoipManager.h"
#import <PushKit/PushKit.h>
#import "LTSDKFull.h"
#import "ApnsManager.h"
#define kVoipManager_voipToken @"kVoipManager_voipToken"
#define kVoipManager_pid    @"kVoipManager_pid"
@interface VoipManager ()
<
PKPushRegistryDelegate
>

/*!
 @property
 @abstract VoIPToken
 */
@property (nonatomic, strong) NSString  *voipToken;  //

@property (nonatomic, strong) VoipManager_settingVoipBlock settingVoipBlock;
@end



@implementation VoipManager


+ (instancetype)share {
    static VoipManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VoipManager alloc] init];
    });
    return instance;
}


#pragma mark -================= apns

-(void)updateVoip:(NSString *)ret {
    [NSUserDefaults.standardUserDefaults
     setObject:ret
     forKey:kVoipManager_voipToken];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (NSString *)queryVoip {
    NSString *ret =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kVoipManager_voipToken];
    return ret;
}
- (void)deleteVoip {
    [NSUserDefaults.standardUserDefaults
     setObject:nil
     forKey:kVoipManager_voipToken];
    [NSUserDefaults.standardUserDefaults synchronize];
}






#pragma mark -================= pid

-(void)updatePID:(NSString *)ret {
    [NSUserDefaults.standardUserDefaults
     setObject:ret
     forKey:kVoipManager_pid];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (NSString *)queryPID {
    NSString *ret =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kVoipManager_pid];
    return ret;
}
- (void)deletePID {
    [NSUserDefaults.standardUserDefaults
     setObject:nil
     forKey:kVoipManager_pid];
    [NSUserDefaults.standardUserDefaults synchronize];
}







/*!
 @method
 @abstract 向sip服务器传递相关参数
 @discussion <#备注#>
 */
-(void)settingParametersToServer {
    
    NSDictionary *userDict  = [LTUser.share queryUser];
    NSDictionary *loginDict = [LTLogin.share queryLastLoginUser];
    
    
    
    NSString *apns        = [ApnsManager.share queryApns];
    NSString *voip        = [VoipManager.share queryVoip];
    NSNumber *platform    = @(1);
    NSString *aIP         = loginDict[@"aIP"];
    NSString *aPort       = loginDict[@"aPort"];
    
    NSString *voipPort    = @"25060";
    NSString *aAccountID  = userDict[@"AccountID"];
    NSString *aUserName   = loginDict[@"aUsername"];
    NSString *aIMPwd      = loginDict[@"aPassword"];
    NSString *registerIdentifies     = [VoipManager.share queryPID];
    NSString *registerJIDIdentifies  = userDict[@"JID"];
    
    NSString *transport  = @"tcp";
    
    [LTVideo.share settingPushKitManagerWithAPNsToken:apns
                                            VoIPToken:voip
                                             platform:platform
                                             serverip:aIP
                                           serverPort:aPort
     
                                             voipPort:voipPort
                                            accountID:aAccountID
                                             username:aUserName
                                             password:aIMPwd
     
                                   registerIdentifies:registerIdentifies
                                registerJIDIdentifies:registerJIDIdentifies
                                            transport:transport
                                            completed:^(NSDictionary *dict, LTError *error) {
                                                
                                                
                                                
                                                
                                                
                                            }];
}


@end
