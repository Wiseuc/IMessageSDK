//
//  ApnsManager.m
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "ApnsManager.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@interface ApnsManager ()
<
UNUserNotificationCenterDelegate
>
/*!
 @property
 @abstract 远程推送token
 */
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





-(void)settingApns {
    
    //注册apns
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        /**请求通知权限, 本地和远程共用**/
        [center requestAuthorizationWithOptions:
         UNAuthorizationOptionCarPlay |
         UNAuthorizationOptionSound |
         UNAuthorizationOptionBadge |
         UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
             if (granted) {
                 NSLog(@" iOS 10 申请远程通知权限成功");
             }else{
                 NSLog(@" iOS 10 申请远程通知权限失败");
             }
         }];
    }
    else if (@available(iOS 8.0, *))
    {
        /**
         UIUserNotificationSettings *setting =
         [UIUserNotificationSettings settingsForTypes:
         UIUserNotificationTypeSound |
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeAlert categories:nil];
         [UIApplication.sharedApplication registerUserNotificationSettings:setting];
         **/

    }
    /**注册**/
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}





/**
 注册远程通知代理
 
 1.已经注册远程通知
 2.注册失败
 3.接收远程通知
 **/

#ifdef __IPHONE_8_0
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"注册apns推送settings配置完成");
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenTemp = [[[[deviceToken description]
                                   stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                  stringByReplacingOccurrencesOfString:@">" withString:@""]
                                 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"注册apns推送成功:apns = %@",deviceTokenTemp);
    self.apnsToken = deviceTokenTemp;
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册apns推送失败：%@",error.localizedFailureReason);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}
#endif








-(NSString *)queryApnsToken {
    return self.apnsToken;
}












@end
