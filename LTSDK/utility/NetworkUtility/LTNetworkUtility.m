//
//  NetworkUtility.m
//  Test
//
//  Created by 吴林峰 on 16/6/2.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "LTNetworkUtility.h"

#include <netdb.h>
#include <arpa/inet.h>
#include <sys/socket.h>

@implementation NetworkUtility

/**
 * -1:找不到服务器地址,无网络
 * 0:外网地址
 * 1:内网地址
 * @param hostName
 * @return
 */
+ (JHNetworkType)checkIpValid:(const NSString *)hostName {
    @try {
        NSString *ipAddress = [self getIPWithHostName:hostName];
        if ( !ipAddress ) {
            return NetworkType_Unknown;
        }
        
        BOOL isInnerIp = [self isInnerIp:ipAddress];
        if (isInnerIp) {
            return NetworkType_InnerIp;
        } else {
            return NetworkType_ExtraIp;
        }
    }
    @catch (NSError *error){
        return NetworkType_Unknown;
    }
    return NetworkType_Unknown;
}

#pragma mark – private

// 域名转IP地址
+ (NSString *)getIPWithHostName:(const NSString *)hostName
{
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname(hostN);
        if ( !phot ) {
            return nil;
        }
        
        struct in_addr ip_addr;
        memcpy(&ip_addr, phot->h_addr_list[0], 4);
        char ip[20] = {0};
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        
        NSString* strIPAddress = [NSString stringWithUTF8String:ip];
        return strIPAddress;
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}

// 判断IP地址内网、外网
+ (BOOL)isInnerIp:(NSString *)ipAddress{
    BOOL isInnerIp = NO;
    long long ipNum = [self getIpNum:ipAddress];
    /*
     私有IP: A类  10.0.0.0-10.255.255.255
     B类  172.16.0.0-172.31.255.255
     C类  192.168.0.0-192.168.255.255
     当然，还有127这个网段是环回地址
     */
    long long aBegin = [self getIpNum:@"10.0.0.0"];
    long long aEnd = [self getIpNum:@"10.255.255.255"];
    long long bBegin = [self getIpNum:@"172.16.0.0"];
    long long bEnd = [self getIpNum:@"172.31.255.255"];
    long long cBegin = [self getIpNum:@"192.168.0.0"];
    long long cEnd = [self getIpNum:@"192.168.255.255"];
    
    isInnerIp = [self isInnerWithUserIP:ipNum begin:cBegin end:cEnd]
    || [self isInnerWithUserIP:ipNum begin:bBegin end:bEnd]
    || [self isInnerWithUserIP:ipNum begin:aBegin end:aEnd]
    || [ipAddress isEqualToString:@"127.0.0.1"];
    
    return isInnerIp;
}

+ (long long)getIpNum:(NSString *)ipAddress {
    NSArray *ipArray = [ipAddress componentsSeparatedByString:@"."];
    long long a = [ipArray[0] longLongValue];
    long long b = [ipArray[1] longLongValue];
    long long c = [ipArray[2] longLongValue];
    long long d = [ipArray[3] longLongValue];
    
    long long ipNum = a * 256 * 256 * 256 + b * 256 * 256 + c * 256 + d;
    return ipNum;
}

+ (BOOL)isInnerWithUserIP:(long long)userIp begin:(long long)begin end:(long long)end {
    return (userIp >= begin) && (userIp <= end);
}

@end
