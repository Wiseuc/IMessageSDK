//
//  NSData+AES128.m
//  WiseUC
//
//  Created by 吴林峰 on 16/6/12.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "NSData+AES128.h"

@implementation NSData (AES128)

- (NSData *)AES128Operation:(CCOperation)operation key:(unsigned char *)key iv:(NSString *)iv
{
//    char keyPtr[kCCKeySizeAES128 + 1];
//    memset(keyPtr, 0, sizeof(keyPtr));
//    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          key,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)AES128EncryptWithKey:(unsigned char *)key iv:(NSString *)iv
{
    return [self AES128Operation:kCCEncrypt key:key iv:iv];
}

//- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv
//{
//    return [self AES128Operation:kCCDecrypt key:key iv:iv];
//}

@end
