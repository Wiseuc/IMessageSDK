//
//  UIImage+Color2Image.m
//  WiseUC
//
//  Created by umi on 2017/4/4.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "UIImage+Color2Image.h"

@implementation UIImage (Color2Image)
+ (UIImage*)imageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    
    return theImage;
}


@end
