//
//  INFManager.h
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
typedef void(^INFManagerDownloadINFBlock)(NSDictionary *infDict, LTError *error);

@interface INFManager : NSObject

@property (nonatomic, strong) INFManagerDownloadINFBlock INFManagerDownloadINFBlock;
+ (instancetype)share;


// 下载 IMServerCfg 配置文件
//- (void)downloadIMServerCfgWithServerIP:(NSString *)ServerIP
//                               complete:(AppManagerDownloadINFBlock)downloadINFBlock;

- (void)downloadINFWithIP:(NSString *)aIP
                completed:(INFManagerDownloadINFBlock)downloadINFBlock;
@end
