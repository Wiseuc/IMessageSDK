//
//  ApnsManager.h
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ApnsManager_settingApnsBlock)(NSError *error);

@interface ApnsManager : NSObject

/*!
 @method
 @abstract 初始化
 @result  登陆管理类
 */
+ (instancetype)share;





-(void)updateApns:(NSString *)apns;
- (NSString *)queryApns;
- (void)deleteApns;

@end
