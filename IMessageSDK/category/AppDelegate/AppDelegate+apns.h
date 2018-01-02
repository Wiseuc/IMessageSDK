//
//  AppDelegate+apns.h
//  IMessageSDK
//
//  Created by JH on 2018/1/2.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (apns)


/*!
 @method
 @abstract 请求Apns
 @discussion <#备注#>
 @param aBlock 请求结果回调
 */
-(void)settingApns:(AppDelegate_apns_settingApnsBlock)aBlock;

@end
