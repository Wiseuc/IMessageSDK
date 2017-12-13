//
//  AppUtility.h
//  IMessageSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtility : NSObject


/*!
 @method
 @abstract 是否第一次运行
 @discussion null
 */
+ (void)updateIsFirstLaunching:(BOOL)ret;
+ (BOOL)queryIsFirstLaunching;



@end
