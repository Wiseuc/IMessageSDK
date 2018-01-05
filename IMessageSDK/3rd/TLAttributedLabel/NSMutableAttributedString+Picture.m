//
//  NSMutableAttributedString+Picture.m
//  TLAttributedLabel
//
//  Created by andezhou on 15/8/12.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "NSMutableAttributedString+Picture.h"
#import "UIImageView+GIF.h"
#import <CoreText/CoreText.h>
#import "UIConfig.h"

static NSString *const BEGIN_FLAG = @"[/";
static NSString *const END_FLAG   = @"]";

@implementation NSMutableAttributedString (Picture)

// 获取图片高度
static CGFloat ascentCallback(void *ref) {
    TLAttributedImage *imageData = (__bridge TLAttributedImage*)ref;
    CGFloat height = attributedImageSize(imageData).height;
    
    CGFloat ascent = 0;
    CGFloat fontAscent  = CTFontGetAscent(imageData.fontRef);
    CGFloat fontDescent = CTFontGetDescent(imageData.fontRef);
    
    switch (imageData.imageAlignment){
        case TLImageAlignmentTop:
            ascent = fontAscent;
            break;
        case TLImageAlignmentCenter:{
            CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
            ascent = height / 2 + baseLine;
        }
            break;
        case TLImageAlignmentBottom:
            ascent = height - fontDescent;
            break;
        default:
            break;
    }
    return ascent;
}

// 调整图片对齐方式
static CGFloat descentCallback(void *ref) {
    TLAttributedImage *imageData = (__bridge TLAttributedImage*)ref;
    CGFloat height = attributedImageSize(imageData).height;
    
    if (!height) return 0;
    CGFloat descent = 0;
    CGFloat fontAscent  = CTFontGetAscent(imageData.fontRef);
    CGFloat fontDescent = CTFontGetDescent(imageData.fontRef);

    switch (imageData.imageAlignment) {
        case TLImageAlignmentTop:{
            descent = height - fontAscent;
            break;
        }
        case TLImageAlignmentCenter:{
            CGFloat baseLine = (fontAscent + fontDescent) / 2.f - fontDescent;
            descent = height / 2.f - baseLine;
        }
            break;
        case TLImageAlignmentBottom:{
            descent = fontDescent;
            break;
        }
        default:
            break;
    }
    
    return descent;
}

// 获取图片宽度
static CGFloat widthCallback(void *ref) {
    TLAttributedImage *imageData = (__bridge TLAttributedImage*)ref;
    return attributedImageSize(imageData).width;
}

static CGSize attributedImageSize(TLAttributedImage *imageData) {
    return CGSizeMake(imageData.imageSize.width + imageData.imageMargin.left + imageData.imageMargin.right,
                      imageData.imageSize.height+ imageData.imageMargin.top  + imageData.imageMargin.bottom);
}

// 创建图片attString
- (NSMutableAttributedString *)createImageAttributedString:(TLAttributedImage *)imageData {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;

    // 创建CTRun回调
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imageData));
    
    // 使用 0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *string = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];

    CFRelease(runDelegate);
    
    return attString;
}

// 检查并处理图片
- (NSMutableArray *)setImageAlignment:(TLImageAlignment)imageAlignment
                          imageMargin:(UIEdgeInsets)imageMargin
                            imageSize:(CGSize)imageSize
                                 font:(UIFont *)font {
    NSMutableArray *images = [NSMutableArray array];

    // 通过递归查询出所有的图片
    [self detectImagesInString:self.string images:images imageAlignment:imageAlignment];
    
    CGSize oldSize = imageSize;
    // 替换图片
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    for (TLAttributedImage *imageData in images) {
        if ( [imageData.imageName rangeOfString:@"."].location == NSNotFound ) {
            continue;
        }
        
        UIImage *image = [UIImage imageNamed:imageData.imageName];
        
        BOOL hasImage = YES;
        // 判断图片是否存在
        if (!image) {
            
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",kPictureFilePath,imageData.imageName];
        image = [UIImage imageWithContentsOfFile:imagePath];
            
            imageSize = image.size;
            
            if (!image) {
                image = [UIImage imageNamed:@"loading_wait"];
                imageSize = CGSizeMake(60, 60);
                hasImage = NO;
            }
            
            if (imageSize.width > 200) {
                imageSize.height = 200 / imageSize.width * imageSize.height;
                imageSize.width = 200;
            }
        }
        // 设置图片size
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            imageData.imageSize = CGSizeMake(font.pointSize, font.pointSize);
        }else {
            imageData.imageSize = imageSize;
        }
        
        // 设置fontRef,方便设置图片位置
        imageData.fontRef = fontRef;
        imageData.imageMargin = imageMargin;
        
        // 设置类型，可为UIImage和UIView
        if ([imageData.imageName rangeOfString:@".gif"].location == NSNotFound || hasImage == NO) {
            imageData.attributedImage = image;
        }else {
            NSString *path = [[NSBundle mainBundle] pathForResource:imageData.imageName ofType:nil];
            
            if (path) {
                
            }else{
                path = [NSString stringWithFormat:@"%@/%@",kPictureFilePath,imageData.imageName];
            }
            
            UIImageView *imageView = [UIImageView imageViewWithGIFFile:path
                                                                 frame:CGRectZero];
            imageData.attributedImage = imageView;
        }

        // 获取图片imageAttString
        NSMutableAttributedString *imageAttString = [self createImageAttributedString:imageData];
        
        // imageAttString替换文字AttString
        NSString *imageStr = [NSString stringWithFormat:@"%@%@%@", BEGIN_FLAG, imageData.imageName, END_FLAG];
        NSRange range = [self.string rangeOfString:imageStr];
        
        // 图片替换
        [self replaceCharactersInRange:range withAttributedString:imageAttString];
        
        imageSize = oldSize;
    }
    
    // 返回包含图片的数组
    return images;
}

// 递归查询出所有的图片
- (void)detectImagesInString:(NSString *)string
                      images:(NSMutableArray *)images
              imageAlignment:(TLImageAlignment)imageAlignment {
   
    NSRange range1 = [string rangeOfString:BEGIN_FLAG];
    if ( range1.location == NSNotFound ) {
        return;
    }
    NSRange range2 = [string rangeOfString:END_FLAG options:NSCaseInsensitiveSearch range:NSMakeRange(range1.location + range1.length, string.length - range1.location - range1.length)];
    // 开始查找
    if ( range1.location < range2.location && range2.location != NSNotFound && range1.location != NSNotFound) {
        NSUInteger location = range1.location + range1.length;
        NSUInteger length = range2.location - location;

        // 图片名
        NSString *imageName = [string substringWithRange:NSMakeRange(location, length)];
        
        // 初始化图片数据模型
        TLAttributedImage *imageData = [[TLAttributedImage alloc] init];
        imageData.imageName = imageName;
        imageData.imageAlignment = imageAlignment;
        
        // 添加到图片数组
        [images addObject:imageData];
        
        // 递归继续查询
        NSString *result = [string substringFromIndex:range2.location + range2.length];
        [self detectImagesInString:result images:images imageAlignment:imageAlignment];
    }
    
//    NSArray *resultArray = [[self class] findImagesRegexArraysWithString:string];
//    for(NSTextCheckingResult *match in resultArray) {
//        //获取数组元素中得到range
//        NSRange range = [match range];
//        
//        // 图片名
//        NSString *imageName = [string substringWithRange:NSMakeRange(range.location + 2, range.length - 3)];
//        
//        if ( [imageName rangeOfString:@"."].location != NSNotFound ) {
//            // 初始化图片数据模型
//            TLAttributedImage *imageData = [[TLAttributedImage alloc] init];
//            imageData.imageName = imageName;
//            imageData.imageAlignment = imageAlignment;
//            
//            // 添加到图片数组
//            [images addObject:imageData];
//        }
//        
//        
//        // 递归继续查询
//        NSString *result = [string substringFromIndex:range.location + range.length];
//        [self detectImagesInString:result images:images imageAlignment:imageAlignment];
//    }
    
    
}

+ (NSArray *)findImagesRegexArraysWithString:(NSString *)text
{
    NSString *regex_emoji = @"\\[(.*?)]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    return resultArray;
}

+ (NSArray *)findImagesWithString:(NSString *)text
{
    NSArray *resultArray = [[self class] findImagesRegexArraysWithString:text];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        
        if (subStr.length < 12) {
            continue;
        }
        
        NSMutableString *subStrM = [NSMutableString stringWithFormat:@"%@",subStr];
        
        NSRange rang1 = [subStrM rangeOfString:@"<i@"];
        [subStrM replaceCharactersInRange:rang1 withString:@""];
        
        NSRange rang2 = [subStrM rangeOfString:@">"];
        [subStrM replaceCharactersInRange:rang2 withString:@""];
        
        [imageArray addObject:subStrM];
    }
    return imageArray;
}

@end
