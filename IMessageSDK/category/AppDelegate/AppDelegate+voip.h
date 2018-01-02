//
//  AppDelegate+voip.h
//  IMessageSDK
//
//  Created by JH on 2018/1/2.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate (voip)



/*!
 @method
 @abstract 请求Apns
 @discussion 备注
 @param aBlock 请求结果回调
 */
-(void)settingVoip:(AppDelegate_voip_settingVoipBlock)aBlock;


@end
