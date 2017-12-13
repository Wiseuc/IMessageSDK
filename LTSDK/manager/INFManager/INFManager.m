//
//  INFManager.m
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "INFManager.h"

#import "LTHttpTool.h"
#import "LTIniHelper.h"
#import "LTNetworkUtility.h"
#import "LT_Macros.h"




@implementation INFManager

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static INFManager *helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}


-(void)downloadINFWithIP:(NSString *)aIP completed:(INFManagerDownloadINFBlock)downloadINFBlock {
    _INFManagerDownloadINFBlock = downloadINFBlock;
    
    // 外网登录配置文件地址
    // 内网登录配置文件地址
    NSString *extraIp = [NSString stringWithFormat:@"http://%@:14132/update/IMServerCfgWlan.inf",aIP];
    NSString *innerIp = [NSString stringWithFormat:@"http://%@:14132/update/IMServerCfg.inf",aIP];
    NSString *savePath = [kFtpConfigFile stringByAppendingPathComponent:@"IMServerCfg.inf"];
    
    NSString *ftpCfgFilePath = extraIp;
    JHNetworkType networkType = [NetworkUtility checkIpValid:aIP];
    switch (networkType) {
        case NetworkType_Unknown:
        {
            NSLog(@"网络环境：未知");
            LTError *error = [LTError errorWithDescription:@"网络环境：未知" code:(LTErrorNetworkUnknow)];
            _INFManagerDownloadINFBlock(nil,error);

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
    __weak typeof(self) weakself = self;
    [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
    [httpTool downLoadFromURL:[NSURL URLWithString:ftpCfgFilePath]
                     savePath:savePath
                progressBlock:nil
                   completion:^(id data, NSError *error) {
                       
                       if ( data ) {
                           /// 解析INF文件
                           NSDictionary *dict = [IniHelper parseIniFile:savePath pragram:nil];
                           if (dict != nil) {
                               //NSLog(@"解析INF文件===\n%@",dict);
                               _INFManagerDownloadINFBlock(dict,nil);
                               return;
                           }
                       } else {

                       }
                   }];
}



@end
