//
//  AFNetworkManager.h
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTAFNetworking.h"
#import "LTAFNetworkReachabilityManager.h"

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailBlock)(NSError *error);
typedef void (^NetworkStatusBlock)(AFNetworkReachabilityStatus status);


@interface AFNetworkManager : NSObject
/**
 *  AF的post请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */

- (void)postRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock;



/**
 *  AF的get请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */

- (void)getRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock;



/**
 *  AF的网络监测
 *  @param networkStatusBlock    网络监测状态回调
 */
+ (void)networkMonitor:(NetworkStatusBlock)networkStatusBlock;




/**
 *  测试服务器网络
 *  @param hostName       目标服务器
 *  @param reachableBlock 网络是否可达
 */
- (void)networkMonitorHostName:(NSString *)hostName reachableBlock:(void(^)(BOOL reachable))reachableBlock;

@end
