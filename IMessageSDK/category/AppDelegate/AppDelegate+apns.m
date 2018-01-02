//
//  AppDelegate+apns.m
//  IMessageSDK
//
//  Created by JH on 2018/1/2.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AppDelegate+apns.h"
#import <UserNotifications/UserNotifications.h>
#import "ApnsManager.h"
@interface AppDelegate ()
<
UNUserNotificationCenterDelegate
>

@end



@implementation AppDelegate (apns)


/*!
 @method
 @abstract 请求Apns
 @discussion <#备注#>
 @param aBlock 请求结果回调
 */
-(void)settingApns:(AppDelegate_apns_settingApnsBlock)aBlock
{
    self.apns_settingApnsBlock = aBlock;
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
        UIUserNotificationSettings *setting =
        [UIUserNotificationSettings settingsForTypes:
         UIUserNotificationTypeSound |
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeAlert categories:nil];
        [UIApplication.sharedApplication registerUserNotificationSettings:setting];
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
    if (self.apns_settingApnsBlock) {
        self.apns_settingApnsBlock(deviceTokenTemp, nil);
    }
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册apns推送失败：%@",error.localizedFailureReason);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}
#endif

@end
