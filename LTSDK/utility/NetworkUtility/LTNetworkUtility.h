//
//  NetworkUtility.h
//  Test
//
//  Created by 吴林峰 on 16/6/2.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM( NSInteger, JHNetworkType) {
    NetworkType_Unknown = -1,   //未知（网络连不上）
    NetworkType_ExtraIp = 0,    //外网
    NetworkType_InnerIp = 1,    //内网
};

/**
 *  内网，外网判断工具类
 */
@interface NetworkUtility : NSObject

/**
 * NetworkType_Unknown:找不到服务器地址,无网络
 * NetworkType_ExtraIp:外网地址
 * NetworkType_InnerIp:内网地址
 * @param hostName
 * @return
 */
+ (JHNetworkType)checkIpValid:(const NSString *)hostName;

@end
