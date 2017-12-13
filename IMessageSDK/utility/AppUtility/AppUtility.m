//
//  AppUtility.m
//  IMessageSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "AppUtility.h"
#define kAppUtilityKey_IsFirstLaunching @"kAppUtilityKey_IsFirstLaunching"



@implementation AppUtility


+ (void)updateIsFirstLaunching:(BOOL)ret
{
    if (ret)
    {
        [NSUserDefaults.standardUserDefaults
         setObject:nil
         forKey:kAppUtilityKey_IsFirstLaunching];
    }else{
        [NSUserDefaults.standardUserDefaults
         setObject:@"isNotFitstLaunching"
         forKey:kAppUtilityKey_IsFirstLaunching];
    }
}
+ (BOOL)queryIsFirstLaunching
{
    BOOL ret = NO;
    NSString *obj =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kAppUtilityKey_IsFirstLaunching];
    if (obj == nil) {
        ret = YES;
    }
    return ret;
}




@end
