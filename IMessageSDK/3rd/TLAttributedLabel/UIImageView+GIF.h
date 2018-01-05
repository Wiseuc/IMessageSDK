//
//  UIImageView+GIF.h
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GIF)

// 从指定的路径加载GIF并创建UIImageView
+ (UIImageView *)imageViewWithGIFFile:(NSString *)file frame:(CGRect)frame;

- (void)imageView:(UIImageView *)imageView withGIFFile:(NSString *)file;

- (void)imageViewWithGIFImage:(UIImage *)image;

@end
