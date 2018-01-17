//
//  PreferenceManager.m
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "PreferenceManager.h"
#define kPreference_voice  @"kPreference_voice"
#define kPreference_virate @"kPreference_virate"
#define kPreference_roming @"kPreference_roming"



@implementation PreferenceManager


+ (instancetype)share {
    static PreferenceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PreferenceManager alloc] init];
    });
    return instance;
}



/**更新声音状态**/
- (void)updatePreference_voice:(BOOL)ret {
    [NSUserDefaults.standardUserDefaults
     setBool:ret
     forKey:kPreference_voice];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (BOOL)queryPreference_voice {
    BOOL ret =
    [NSUserDefaults.standardUserDefaults
     boolForKey:kPreference_voice];
    return ret;
}





/**更新震动状态**/
- (void)updatePreference_virate:(BOOL)ret {
    [NSUserDefaults.standardUserDefaults
     setBool:ret
     forKey:kPreference_virate];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (BOOL)queryPreference_virate {
    BOOL ret =
    [NSUserDefaults.standardUserDefaults
     boolForKey:kPreference_virate];
    return ret;
}







/**更新震动状态**/
- (void)updatePreference_roming:(BOOL)ret {
    [NSUserDefaults.standardUserDefaults
     setBool:ret
     forKey:kPreference_roming];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (BOOL)queryPreference_roming{
    BOOL ret =
    [NSUserDefaults.standardUserDefaults
     boolForKey:kPreference_roming];
    return ret;
}

@end
