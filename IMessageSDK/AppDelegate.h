//
//  AppDelegate.h
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"
typedef void (^AppDelegate_apns_settingApnsBlock)(NSString *ret, NSError *error);
typedef void (^AppDelegate_voip_settingVoipBlock)(NSString *ret, NSError *error);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainController *mainvc;





@property (nonatomic, strong) AppDelegate_apns_settingApnsBlock apns_settingApnsBlock;
@property (nonatomic, strong) AppDelegate_voip_settingVoipBlock voip_settingVoipBlock;
@end

