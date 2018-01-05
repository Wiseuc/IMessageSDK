//
//  UIImageView+GIF.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/8.
//  Copyright (c) 2015年 周安德. All rights reserved.
//

#import "UIImageView+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation UIImageView (GIF)

+ (UIImageView *)imageViewWithGIFFile:(NSString *)file frame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];

    // 加载gif文件数据
    NSData *gifData = [NSData dataWithContentsOfFile:file];

    // GIF动画图片数组
    NSMutableArray *frames = nil;
    // 图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    // 动画时长
    CGFloat animationTime = 0.f;

    if (src) {
        // 获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        // 实例化图片数组
        frames = [NSMutableArray arrayWithCapacity:count];

        for (size_t i = 0; i < count; i++) {
            // 获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);

            // 获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];

            if (image) {
                [frames addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }

        CFRelease(src);
    }

    [imageView setImage:[frames firstObject]];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:animationTime];
    [imageView startAnimating];
    
    if ( frames.count == 0 ) {
        [imageView setImage:[UIImage imageNamed:@"loading_wait"]];
    }
    
    return imageView;
}

- (void)imageView:(UIImageView *)imageView withGIFFile:(NSString *)file
{    
    // 加载gif文件数据
    NSData *gifData = [NSData dataWithContentsOfFile:file];
    
    // GIF动画图片数组
    NSMutableArray *frames = nil;
    // 图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    // 动画时长
    CGFloat animationTime = 0.f;
    
    if (src) {
        // 获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        // 实例化图片数组
        frames = [NSMutableArray arrayWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            // 获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);
            
            // 获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            
            if (image) {
                [frames addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }
        
        CFRelease(src);
    }
    
    if ( frames.count == 0 ) {
        [imageView setImage:[UIImage imageNamed:@"loading_wait"]];
    }
    else {
        [imageView setImage:[frames firstObject]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setAnimationImages:frames];
        [imageView setAnimationDuration:animationTime];
        [imageView startAnimating];
    }
    

//    return imageView;
}

- (void)imageViewWithGIFImage:(UIImage *)image
{
    NSData *gifData = nil;
    if (UIImagePNGRepresentation(image) == nil) {
        
        gifData = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        gifData = UIImagePNGRepresentation(image);
    }
    
    // GIF动画图片数组
    NSMutableArray *frames = nil;
    // 图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    // 动画时长
    CGFloat animationTime = 0.f;
    
    if (src) {
        // 获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        // 实例化图片数组
        frames = [NSMutableArray arrayWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            // 获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);
            
            // 获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            
            if (image) {
                [frames addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }
        
        CFRelease(src);
    }
    
    [self setImage:[frames firstObject]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setAnimationImages:frames];
    [self setAnimationDuration:animationTime];
    [self startAnimating];
    
    if ( frames.count == 0 ) {
        [self setImage:[UIImage imageNamed:@"loading_wait"]];
    }
    
}

@end
