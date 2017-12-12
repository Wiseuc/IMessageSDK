//
//  AppManager.m
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "AppManager.h"

#import <UIKit/UIDevice.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "LTHttpTool.h"
//#import "UserManager.h"
#import "LTIniHelper.h"
#import "LTNetworkUtility.h"
#import "LT_Macros.h"



@implementation AppManager
#pragma mark - public
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }else{
                    // 找不到就返回 0.0.0.0
                    address = @"0.0.0.0";
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
//    NSLog(@"手机的IP是：%@", address);
    return address;
}



+ (NSString *)getIOSVersion{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return [NSString stringWithFormat:@"%.1f",version];
}
+ (NSString *)applicationVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
+ (NSString *)applicationDisplayName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}
+ (NSString *)get_128Bytes_UUID{
    return [[[self class] uuid] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
+ (NSString *)get_32Bytes_UUID{
    NSString *uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuid;
}
+ (CGSize)getNSStringSize:(NSString *)str withFontSize:(CGFloat)fontSize forWidth:(CGFloat)width{
    NSDictionary *dict =
    [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize]
                                forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 1000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dict
                                    context:nil];
    return rect.size;
}

+ (void)clearCacheAction:(void(^)(BOOL clearFinished))complete{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       
                       BOOL ret = YES;
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               ret = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       complete(ret);
                   });
}
//获取缓存大小。。
+ (CGFloat)cacheSize {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [[self class] folderSizeAtPath:cachPath];
}






/**
 
 解析INF文件==={
 MsgServerConnAddr = tcp://112.74.74.80:5225,
 os = linux,
 ackEnable = 0,
 MD5Enable = 0,
 ftpURLServerConfig = im.lituosoft.cn:6100,
 LDAPAuthEnable = 0,
 appstate = check
 }
 
 #define kLDAPAuthEnable         @"LDAPAuthEnable"
 #define kMD5Enable              @"MD5Enable"
 #define kAckEnable              @"ackEnable"
 #define kFtpURLServerConfig     @"ftpURLServerConfig"
 #define kMsgServerConnAddr      @"MsgServerConnAddr"
 #define kOS                     @"os"
 #define kappstate               @"appstate"
 
 
 [NSMutableDictionary dictionaryWithDictionary:
 @{
 kLDAPAuthEnable:@([LDAPAuthEnable boolValue]),
 kMD5Enable:@([MD5Enable boolValue]),
 kFtpURLServerConfig:ftpURLServerConfig,
 kAckEnable:@([ackEnable boolValue]),
 kOS:os,
 kappstate:appstate,
 }];
 **/


+(void)downloadIMServerCfgWithServerIP:(NSString *)ServerIP
                              complete:(AppManagerDownloadINFBlock)downloadINFBlock {
    
    // 外网登录配置文件地址
    // 内网登录配置文件地址
    NSString *extraIp = [NSString stringWithFormat:@"http://%@:14132/update/IMServerCfgWlan.inf",ServerIP];
    NSString *innerIp = [NSString stringWithFormat:@"http://%@:14132/update/IMServerCfg.inf",ServerIP];
    NSString *savePath = [kFtpConfigFile stringByAppendingPathComponent:@"IMServerCfg.inf"];
    

    NSString *ftpCfgFilePath = nil;
    JHNetworkType networkType = [NetworkUtility checkIpValid:ServerIP];
    switch (networkType) {
        case NetworkType_Unknown:
        {
            NSLog(@"网络环境：未知");
            LTError *error = [LTError errorWithDescription:@"网络环境：未知" code:(LTErrorNetworkUnknow)];
            downloadINFBlock(nil,error);
        }
            break;
            
        case NetworkType_ExtraIp:
        {
            NSLog(@"网络环境：外网");
            ftpCfgFilePath = extraIp;
        }
            break;
            
        case NetworkType_InnerIp:
        {
            NSLog(@"网络环境：内网");
            ftpCfgFilePath = innerIp;
        }
            break;
    }
    
    
    
        HttpTool *httpTool = [[HttpTool alloc] init];
        [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
        [httpTool downLoadFromURL:[NSURL URLWithString:ftpCfgFilePath]
                         savePath:savePath
                    progressBlock:nil
                       completion:^(id data, NSError *error) {
                           if ( data ) {
                               /// 解析INF文件
                               NSDictionary *IMServerCfgDict = [self parseIniFile:savePath pragram:nil];
                               if (IMServerCfgDict != nil) {
                                   NSLog(@"解析INF文件===%@",IMServerCfgDict);
                                   //TempBlock(IMServerCfgDict);
                                   return;
                               }
                           } else {
                               
                           }
                       }];
    
    
    
}




+ (NSDictionary *)parseIniFile:(NSString *)iniFilePath pragram:(NSDictionary *)pragram {
    return [IniHelper parseIniFile:iniFilePath pragram:pragram];
}
+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
+ (NSString *)uuid{
    return [[NSUUID UUID] UUIDString];
}
+ (CGFloat)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [[self class] fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
