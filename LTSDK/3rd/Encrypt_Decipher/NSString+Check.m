//
//  NSString+Check.m
//  WiseUC
//
//  Created by 吴林峰 on 16/6/28.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "NSString+Check.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+AES128.h"
#import "Base64.h"

@implementation NSString (Check)

- (NSString *)stringAes128
{
    NSString *iv= @"usr@info/iv_Auth";
    NSString *key= @"usr@wiseuc/IDAuth";
    return [self stringAes128WithMD5Key:key iv:iv];
}

#pragma mark – private
- (NSString *)stringAes128WithMD5Key:(NSString *)key iv:(NSString *)iv
{
    const char *cStr = [key UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dst = [srcData AES128EncryptWithKey:result iv:iv];
    NSString *aes128Result = [Base64 encode:dst];
    return aes128Result;
}

@end
