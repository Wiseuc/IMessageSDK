//
//  HttpRequestManager.m
//  WisdomCommunity
//
//  Created by mxc235 on 2016/11/16.
//  Copyright © 2016年 wiseuc. All rights reserved.
//

#import "LT_HttpRequestManager.h"
#import "Encrypt_Decipher.h"
#define kApi_KeyCode                   @"gzRN53VWRF9BYUXo"

@implementation HttpRequestManager

+ (HttpRequestManager *)shareManager
{
    static HttpRequestManager *manager = nil;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        manager = [[HttpRequestManager alloc] init];
    });
    return manager;
}

- (void)postWithUrlString:(NSString *)urlString parameters:(id)parameters complitionBlock:(HttpRequestBlock)block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *K = @"";
    NSDictionary *parameter = nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)parameters];

    if (parameters) {
        NSArray *arr = [dict allKeys];
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString *key in arr) {
            K = [NSString stringWithFormat:@"%@%@=%@&",K,key,dict[key]];
        }
        
        K = [K substringToIndex:K.length - 1];
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc]initWithDictionary:dict];
        K = [NSString stringWithFormat:@"%@%@",K,kApi_KeyCode];
        [dictM setValue:[K md5] forKey:@"k"];
        parameter = dictM;
        
    }else{
        
        
        K = [NSString stringWithFormat:@"loginToken=%@%@",dict[@"loginToken"],kApi_KeyCode];
        
        [dict setValue:[K md5] forKey:@"k"];
        
        parameter = dict;
    }
    
    
    
    [manager POST:urlString
       parameters:parameter
         progress:^(NSProgress * _Nonnull uploadProgress)  {}
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if (responseObject) {
            if ([responseObject[@"s"] isEqualToNumber:@(1099)] && [responseObject[@"m"] isEqualToString:@"登录Token已失效"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                     [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LoginOut object:@"账号已在其它地方登录"];
                });
               
            }else{
                if (block) {
                    block(task,responseObject,nil);
                }
            }
        }else{
            if (block) {
                block(task,responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block) {
            block(task,nil,error);
        }
    }];
}

+ (void)networkMonitor:(NetworkStatusBlock)networkStatusBlock
{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        networkStatusBlock(status);
        
    }];
}

@end
