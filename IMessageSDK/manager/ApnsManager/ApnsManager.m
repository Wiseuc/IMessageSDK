//
//  ApnsManager.m
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "ApnsManager.h"
#define kApnsManager_apnsToken @"kApnsManager_apnsToken"

@interface ApnsManager ()
@property (nonatomic, strong) NSString  *apnsToken;

@end



@implementation ApnsManager


+ (instancetype)share {
    static ApnsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ApnsManager alloc] init];
    });
    return instance;
}



#pragma mark -================= apns

-(void)updateApns:(NSString *)apns {
    [NSUserDefaults.standardUserDefaults
     setObject:apns
     forKey:kApnsManager_apnsToken];
    [NSUserDefaults.standardUserDefaults synchronize];
}
- (NSString *)queryApns {
    NSString *ret =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kApnsManager_apnsToken];
    return ret;
}
- (void)deleteApns {
    [NSUserDefaults.standardUserDefaults
     setObject:nil
     forKey:kApnsManager_apnsToken];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
