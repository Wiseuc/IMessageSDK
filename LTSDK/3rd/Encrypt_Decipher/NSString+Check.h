//
//  NSString+Check.h
//  WiseUC
//
//  Created by 吴林峰 on 16/6/28.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  校验、验证 (aes128、)
 */
@interface NSString (Check)

/**
 *  由IMServer服务端， web服务器同时处理，客户端采用Aes128(aes/cbc/pkcs7) 做为加密用户密码字段传送给服务端进行对比认证。
 加密iv= usr@info/iv_Auth
 加密key= usr@wiseuc/IDAuth
 Ps:  src表示原字符， dst 表示加密之后的字符，
 加密过程  dst=base64(Aes (src, md5(key)))
 *
 */
- (NSString *)stringAes128;

@end
