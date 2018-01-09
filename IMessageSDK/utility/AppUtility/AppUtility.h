//
//  AppUtility.h
//  IMessageSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUtility : NSObject


/*!
 @method
 @abstract 是否第一次运行
 @discussion null
 */
+ (void)updateIsFirstLaunching:(BOOL)ret;
+ (BOOL)queryIsFirstLaunching;



#pragma mark - 获取本地 IP 地址
//+ (NSString *)deviceIPAdress;
#pragma mark - 获取应用版本
+ (NSString *)applicationVersion;
#pragma mark - 获取应用名称
+ (NSString *)applicationDisplayName;
#pragma mark - 获取IOS系统版本
+ (NSString *)getIOSVersion;
#pragma mark -- 获取128位UUID
+ (NSString *)get_128Bytes_UUID;
#pragma mark -- 获取32位UUID
+ (NSString *)get_32Bytes_UUID;
#pragma mark -- 获取字符串 size
+ (CGSize)getNSStringSize:(NSString *)str
             withFontSize:(CGFloat)fontSize
                 forWidth:(CGFloat)width;


@end
