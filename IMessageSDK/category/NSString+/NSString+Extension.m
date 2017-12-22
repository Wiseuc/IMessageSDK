//
//  NSString+Extension.m
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


/**
 *  根据文字来计算宽和高
 *
 *  @param fontSize 字体大小
 *  @param maxSize  最大size
 *
 *  @return 计算好的宽度和高度
 */
- (CGSize)sizeWithFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize
{
    if (self.length == 0)
    {
        return CGSizeZero;
    }
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
}



@end
