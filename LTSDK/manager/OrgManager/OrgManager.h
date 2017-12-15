//
//  OrgManager.h
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
typedef void(^OrgManagerDownloadBlock)(LTError *error);
typedef void(^OrgCompleteHandler)(BOOL complete);
typedef void(^OrgVisibleRangeBlock)(BOOL hasOrgVisible, NSArray *visibleRangeArray);


//组织架构工具类：下载组织架构，解压
@interface OrgManager : NSObject

@property (nonatomic, strong) OrgManagerDownloadBlock downloadBlock;


//组织架构可视范围获取
+ (void)getOrgVisibleRange:(OrgVisibleRangeBlock)orgVisibleRangeBlock;

//组织架构下载并解压
+ (void)downloadAndParserOrgZipWithLocalOrgVersion:(BOOL)needLocalOrgVersion
                                   completeHandler:(OrgCompleteHandler)complete;



/**下载组织架构**/
+ (void)downloadOrgWithlocalVersion:(BOOL)isNeedLocalVersion
                          completed:(OrgManagerDownloadBlock)aDownloadBlock;



//清理组织架构文件
+ (BOOL)clearOrgFile;

@end
