//
//  NSData+AES128.h
//  WiseUC
//
//  Created by 吴林峰 on 16/6/12.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AES128)

- (NSData *)AES128Operation:(CCOperation)operation key:(unsigned char *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(unsigned char *)key iv:(NSString *)iv;
//- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

@end
