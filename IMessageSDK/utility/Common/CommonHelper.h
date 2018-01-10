//
//  CommonHelper.h
//  YunPan
//
//  Created by Bruce Xu on 14-5-12.
//  Copyright (c) 2014年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LTSDKFull.h"

@interface CommonHelper : NSObject
+ (uint64_t)getFreeDiskspace;
+ (uint64_t)getTotalDiskspace;
+ (NSString *)getDiskSpaceInfo;

//将文件大小转化成M单位或者B单位
+ (NSString *)getFileSizeString:(NSString *)size;

//经文件大小转化成不带单位ied数字
+ (float)getFileSizeNumber:(NSString *)size;

//获取某文件的大小
+ (CGFloat)getFileSizeAtLocalPath:(NSString *)filePath;

+ (BOOL)isExistFile:(NSString *)fileName;//检查文件名是否存在
//传入文件总大小和当前大小，得到文件的下载进度
+ (float)getProgress:(int16_t)totalBytesExpectedToWrite totalBytesWritten:(int16_t)totalBytesWritten;

+ (LTFileType)fileType:(NSString *)localPath;

@end
