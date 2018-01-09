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









#pragma mark - public
//+ (NSString *)deviceIPAdress {
//    NSString *address = @"an error occurred when obtaining ip address";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    success = getifaddrs(&interfaces);
//    
//    if (success == 0) { // 0 表示获取成功
//        temp_addr = interfaces;
//        while (temp_addr != NULL) {
//            if( temp_addr->ifa_addr->sa_family == AF_INET) {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }else{
//                    // 找不到就返回 0.0.0.0
//                    address = @"0.0.0.0";
//                }
//            }
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    freeifaddrs(interfaces);
//    //    NSLog(@"手机的IP是：%@", address);
//    return address;
//}



+ (NSString *)getIOSVersion{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return [NSString stringWithFormat:@"%.1f",version];
}
+ (NSString *)applicationVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
+ (NSString *)applicationDisplayName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}
+ (NSString *)get_128Bytes_UUID{
    return [[[self class] uuid] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
+ (NSString *)get_32Bytes_UUID{
    NSString *uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuid;
}
+ (CGSize)getNSStringSize:(NSString *)str withFontSize:(CGFloat)fontSize forWidth:(CGFloat)width{
    NSDictionary *dict =
    [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize]
                                forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 1000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dict
                                    context:nil];
    return rect.size;
}




+ (NSString *)uuid{
    return [[NSUUID UUID] UUIDString];
}

@end
