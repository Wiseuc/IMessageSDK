//
//  HttpRequestManager.h
//  WisdomCommunity
//
//  Created by mxc235 on 2016/11/16.
//  Copyright © 2016年 wiseuc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Encrypt_Decipher.h"

//#import "NSArray+ShowChinese.h"
//#import "NSDictionary+ShowChinese.h"
//#import "NSDictionary+GetObjectForKey.h"

//#import <AFNetworking/AFNetworking.h>
//#import "AFNetworking"
#import "LTAFNetworking.h"
#import "LTAFNetworkReachabilityManager.h"



typedef void (^HttpRequestBlock)(NSURLSessionDataTask * task,id response, NSError *error);
typedef void (^NetworkStatusBlock)(AFNetworkReachabilityStatus status);

@interface HttpRequestManager : NSObject

+ (HttpRequestManager *)shareManager;

- (void)postWithUrlString:(NSString *)urlString parameters:(id)parameters complitionBlock:(HttpRequestBlock)block;

/**
 *  AF的网络监测
 *
 *  @param networkStatusBlock    网络监测状态回调
 *
 */
+ (void)networkMonitor:(NetworkStatusBlock)networkStatusBlock;


@end
