//
//  NSString+Extension.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (JHExtension)
- (NSString *)emoji;

- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;

- (NSString *)originName;

+ (NSString *)currentName;

- (NSString *)firstStringSeparatedByString:(NSString *)separeted;
@end
