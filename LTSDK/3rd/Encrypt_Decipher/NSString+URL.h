//
//  NSString+URL.h
//  SchoolSafety
//
//  Created by wj on 15/8/26.
//  Copyright (c) 2015年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
void runCategoryForFramework37();
//void runCategoryForFramework(){}
@interface NSString (URL)

- (NSString *)URLEncode;

- (NSString *)URLDecode;

@end
