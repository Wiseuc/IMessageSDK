//
//  NSString+Json.h
//  SchoolSafety
//
//  Created by 吴林峰 on 15/8/26.
//  Copyright (c) 2015年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// 字典转 json
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

@end
