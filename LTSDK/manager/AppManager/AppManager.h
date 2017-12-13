//
//  AppManager.h
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LTSDKFull.h"

typedef void(^AppManagerDownloadINFBlock)(NSDictionary *infDict, LTError *error);


@interface AppManager : NSObject
@property (nonatomic, strong) AppManagerDownloadINFBlock downloadINFBlock;


+ (instancetype)share;

#pragma mark - 获取本地 IP 地址
+ (NSString *)deviceIPAdress;
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





//清理缓存
+ (void)clearCacheAction:(void(^)(BOOL clearFinished))complete;
//缓存大小计算
+ (CGFloat)cacheSize;
//文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath;
// 下载 IMServerCfg 配置文件
- (void)downloadIMServerCfgWithServerIP:(NSString *)ServerIP
                               complete:(AppManagerDownloadINFBlock)downloadINFBlock;
//解析 ini 文件
+ (NSDictionary *)parseIniFile:(NSString *)iniFilePath
                       pragram:(NSDictionary *)pragram;

@end
