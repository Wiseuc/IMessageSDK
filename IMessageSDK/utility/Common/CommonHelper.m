//
//  CommonHelper.m
//  YunPan
//
//  Created by Bruce Xu on 14-5-12.
//  Copyright (c) 2014年 Pansoft. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper


+(NSString *)getFileSizeString:(NSString *)size
{
    if ( [size hasSuffix:@"B"] ||
        [size hasSuffix:@"K"] ||
        [size hasSuffix:@"M"] ) {
        return size;
    }
    
    if([size floatValue]>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",[size floatValue]/1024/1024];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",[size floatValue]/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",[size floatValue]];
    }
}

+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)//是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)//是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)//是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else//没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+ (CGFloat)getFileSizeAtLocalPath:(NSString *)filePath
{
    NSFileManager *manger = [NSFileManager defaultManager];
    if ( [manger fileExistsAtPath:filePath] ) {
        return [[manger attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (NSString *)getDocumentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize/totalSize;
}

+ (uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

+ (uint64_t)getTotalDiskspace {
    uint64_t totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalSpace;
}

+(NSString *)getDiskSpaceInfo{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
    }else
        return nil;
    
    NSString *infostr = [NSString stringWithFormat:@"%.2f GB 可用/总共 %.2f GB", ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f, ((totalSpace/1024.0f)/1024.0f)/1024.0f];
    return infostr;
    
}

+ (float)getProgress:(int16_t)totalBytesExpectedToWrite totalBytesWritten:(int16_t)totalBytesWritten
{
    return 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
}

+ (LTFileType)fileType:(NSString *)localPath
{
    BOOL isDir;
    if([[NSFileManager defaultManager] fileExistsAtPath:localPath isDirectory:&isDir] && isDir){
        return LTFileType_NoFound;
    }
    else if ( [localPath hasSuffix:@".DS_Store"] )
    {
        return LTFileType_NoFound;
    }
    
    // 返回图片类型
    if ([[localPath pathExtension] isEqualToString:@"jpg"] ||
        [[localPath pathExtension] isEqualToString:@"png"] ||
        [[localPath pathExtension] isEqualToString:@"jpeg"] ) {
        return LTFileType_Picture;
    }
    
    // 返回音频类型
    if ([[localPath pathExtension] isEqualToString:@"mp3"] ||
        [[localPath pathExtension] isEqualToString:@"amr"] ||
        [[localPath pathExtension] isEqualToString:@"mp4"] ) {
        return LTFileType_Audio;
    }
    
    // 返回文本类型
    if ([[localPath pathExtension] isEqualToString:@"doc"] ||
        [[localPath pathExtension] isEqualToString:@"xls"] ||
        [[localPath pathExtension] isEqualToString:@"pdf"] ||
        [[localPath pathExtension] isEqualToString:@"text"]||
        [[localPath pathExtension] isEqualToString:@"zip"]) {
        return LTFileType_Text;
    }
    return LTFileType_Default;
}

@end
