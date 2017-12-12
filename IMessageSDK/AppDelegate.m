//
//  AppDelegate.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    MainController *mainvc = [[MainController alloc] init];
    self.window.rootViewController = mainvc;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
