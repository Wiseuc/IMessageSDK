//
//  AFNetworkManager.m
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "LTAFNetworkManager.h"

@implementation AFNetworkManager
/**
 *  AF的post请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
- (void)postRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 请求类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 响应返回类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 成功回调
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败回调
        if (failBlock) {
            failBlock(error);
        }
    }];
}

/**
 *  AF的get请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
- (void)getRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFail:(FailBlock)failBlock
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 请求类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 响应返回类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 失败回调
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败回调
        if (failBlock) {
            failBlock(error);
        }
    }];
}

/**
 *  AF的网络监测
 *
 *  @param networkStatusBlock    网络监测状态回调
 *
 */
+ (void)networkMonitor:(NetworkStatusBlock)networkStatusBlock
{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //一旦网络状态发生改变,就会立刻走这个回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        networkStatusBlock(status);
        
    }];
}

@end
