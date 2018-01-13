//
//  AppDelegate.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "UIConfig.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AMapServices sharedServices].apiKey = kAMapApiKey;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.mainvc = [[MainController alloc] init];
    self.window.rootViewController = self.mainvc;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
