//
//  OrgManager.h
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
typedef void(^LT_OrgManagerDownloadBlock)(LTError *error);
typedef void(^OrgVisibleRangeBlock)(BOOL hasOrgVisible, NSArray *visibleRangeArray);


//组织架构工具类：下载组织架构，解压
@interface LT_OrgManager : NSObject
@property (nonatomic, strong) LT_OrgManagerDownloadBlock downloadBlock;


//组织架构可视范围获取
+ (void)getOrgVisibleRange:(OrgVisibleRangeBlock)orgVisibleRangeBlock;


/**下载组织架构**/
+ (void)downloadOrgWithlocalVersion:(BOOL)isNeedLocalVersion
                          completed:(LT_OrgManagerDownloadBlock)aDownloadBlock;


//清理组织架构文件
+ (BOOL)clearOrgFile;

/**通过jid获取详细信息**/
+ (NSDictionary *)queryInformationByJid:(NSString *)aJID;
@end
