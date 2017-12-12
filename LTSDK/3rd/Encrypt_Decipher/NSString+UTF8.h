//
//  NSString+UTF8.h
//  SoapTest
//
//  Created by 吴林峰 on 15/8/24.
//  Copyright (c) 2015年 guoguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTF8)

// UTF8 编码：对字符串进行UTF-8编码：输出str字符串的UTF-8格式
- (NSString *)UTF8Encode;

// UTF8 解码：把str字符串以UTF-8规则进行解码
- (NSString *)UTF8Decode;

@end
