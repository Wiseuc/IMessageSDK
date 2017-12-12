//
//  NSString+DES.h
//  SoapTest
//
//  Created by 吴林峰 on 15/8/24.
//  Copyright (c) 2015年 guoguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DES)

// DES 加密
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

// DES 解密
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

@end
