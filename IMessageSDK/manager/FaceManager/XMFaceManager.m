//
//  XMFaceManager.m
//  XMChatBarExample
//
//  Created by shscce on 15/8/25.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMFaceManager.h"

@interface XMFaceManager ()

@property (strong, nonatomic) NSMutableArray *emojiFaceArrays;
@property (strong, nonatomic) NSMutableArray *recentFaceArrays;
@end

@implementation XMFaceManager


- (instancetype)init{
    if (self = [super init]) {
        _emojiFaceArrays = [NSMutableArray array];
        
        NSArray *faceArray = [NSArray arrayWithContentsOfFile:[XMFaceManager defaultEmojiFacePath]];
        [_emojiFaceArrays addObjectsFromArray:faceArray];

        NSArray *recentArrays = [[NSUserDefaults standardUserDefaults] arrayForKey:@"recentFaceArrays"];
        if (recentArrays) {
            _recentFaceArrays = [NSMutableArray arrayWithArray:recentArrays];
        }else{
            _recentFaceArrays = [NSMutableArray array];
        }
        
    }
    return self;
}


#pragma mark - Class Methods

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}


#pragma mark - Emoji相关表情处理方法

+ (NSArray *)emojiFaces{
    return [[XMFaceManager shareInstance] emojiFaceArrays];
}


+ (NSString *)defaultEmojiFacePath{
    return [[NSBundle mainBundle] pathForResource:@"face" ofType:@"plist"];
}

+ (NSString *)faceImageNameWithFaceID:(NSUInteger)faceID{
    if (faceID == 999) {
        return @"[删除]";
    }
    for (NSDictionary *faceDict in [[XMFaceManager shareInstance] emojiFaceArrays]) {
        if ([faceDict[kFaceIDKey] integerValue] == faceID) {
            return faceDict[kFaceImageNameKey];
        }
    }
    return @"";
}

+ (NSString *)faceNameWithFaceID:(NSUInteger)faceID{
    if (faceID == 999) {
        return @"[删除]";
    }
    for (NSDictionary *faceDict in [[XMFaceManager shareInstance] emojiFaceArrays]) {
        if ([faceDict[kFaceIDKey] integerValue] == faceID) {
            return faceDict[kFaceNameKey];
        }
    }
    return @"";
}


+ (NSString *)emotionStrWithString:(NSString *)text
{
    // 1、通过正则表达式来匹配字符串
    NSArray *resultArray = [[self class] findImagesRegexArraysWithString:text];
    
    // 2、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        
        NSInteger num = 0;
        
        for (NSDictionary *dict in [[XMFaceManager shareInstance] emojiFaceArrays]) {
            if ([dict[kFaceNameKey]  isEqualToString:subStr]) {
                NSString *gifStr = [NSString stringWithFormat:@"[/%@]",dict[kFaceImageNameKey]];
//                NSString *gifStr = [NSString stringWithFormat:@"%@",dict[kFaceImageNameKey]];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:gifStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                break;
            }
            
            num ++ ;
            
            if (num == [[XMFaceManager shareInstance] emojiFaceArrays].count) {
                NSMutableString *subStrM = [NSMutableString stringWithFormat:@"%@",subStr];
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                
                NSRange rang1 = [subStrM rangeOfString:@"<i@"];
                [subStrM replaceCharactersInRange:rang1 withString:@"[/"];
                
                NSRange rang2 = [subStrM rangeOfString:@">"];
                [subStrM replaceCharactersInRange:rang2 withString:@"]"];
                
                
                [imageDic setObject:subStrM forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
            
        }
    }
    
    // 3、从后往前替换，否则会引起位置问题
    NSMutableString *mStr = [NSMutableString stringWithString:text];
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        [mStr replaceCharactersInRange:range withString:imageArray[i][@"image"]];
    }
    return mStr;
}



+ (BOOL)hasEmotionStrWithString:(NSString *)text
{
    NSArray *resultArray = [[self class] emojiFaceRegexArraysWithString:text];
    return resultArray.count;
}

// 转换成消息描述（会话最后一条消息用）     sdfsdf[表情][表情]sdfsd
+ (NSString *)formatEmotionStrWithString:(NSString *)text
{
    // 1、通过正则表达式来匹配字符串
    NSArray *resultArray = [[self class] findImagesRegexArraysWithString:text];
    
    // 2、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        NSInteger num = 0;
        for (NSDictionary *dict in [[XMFaceManager shareInstance] emojiFaceArrays]) {
            if ([dict[kFaceNameKey]  isEqualToString:subStr]) {
                NSString *gifStr = @"[表情]";
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:gifStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                break;
            }
            
            num ++ ;
            if (num == [[XMFaceManager shareInstance] emojiFaceArrays].count) {
                
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                NSString *gifStr = @"[图片]";
                [imageDic setObject:gifStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    
    // 3、从后往前替换，否则会引起位置问题
    NSMutableString *mStr = [NSMutableString stringWithString:text];
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        [mStr replaceCharactersInRange:range withString:imageArray[i][@"image"]];
    }
    return mStr;
}


+ (NSArray *)emojiFaceRegexArraysWithString:(NSString *)text
{
    NSString *regex_emoji = @"(<i@)((\\d|\\d\\d|10\\d|11\\d)\\.gif)(>)"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    return resultArray;
}





+ (NSArray *)findImagesRegexArraysWithString:(NSString *)text
{
    NSString *regex_emoji = @"(<i@)(.*?)(>)"; //匹配表情
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





+ (NSString *)filterImageString:(NSString *)sourceText
{
    NSArray *resultArray = [[self class] findImagesRegexArraysWithString:sourceText];
    NSMutableString *mStr = [NSMutableString stringWithString:sourceText];
    //根据匹配范围来用图片进行相应的替换
    for (NSInteger i = (NSInteger)resultArray.count - 1; i >= 0; i--) {
        NSTextCheckingResult *match = resultArray[i];
        //获取原字符串中对应的值
        NSString *imgStr = [mStr substringWithRange:[match range]];
        
        if (imgStr.length < 12) {
            continue;
        }
        [mStr replaceCharactersInRange:[match range] withString:@""];
    }
    return mStr;
}

+ (BOOL)hasImgWithString:(NSString *)sourceText {
    NSArray *resultArray = [[self class] findImagesRegexArraysWithString:sourceText];
    
    NSMutableString *mStr = [NSMutableString stringWithString:sourceText];
    //根据匹配范围来用图片进行相应的替换
    for (NSInteger i = (NSInteger)resultArray.count - 1; i >= 0; i--) {
        NSTextCheckingResult *match = resultArray[i];
        //获取原字符串中对应的值
        NSString *imgStr = [mStr substringWithRange:[match range]];
        
        if (imgStr.length > 11 ) {
            return YES;
            break;
        }
    }
    return NO;
}

#pragma mark - 最近使用表情相关方法
/**
 *  获取最近使用的表情图片
 *
 *  @return
 */
+ (NSArray *)recentFaces{
    return [[XMFaceManager shareInstance] recentFaceArrays];
}


+ (BOOL)saveRecentFace:(NSDictionary *)recentDict{
    for (NSDictionary *dict in [[XMFaceManager shareInstance] recentFaceArrays]) {
        if ([dict[@"face_id"] integerValue] == [recentDict[@"face_id"] integerValue]) {
            NSLog(@"已经存在");
            return NO;
        }
    }
    [[[XMFaceManager shareInstance] recentFaceArrays] insertObject:recentDict atIndex:0];
    if ([[XMFaceManager shareInstance] recentFaceArrays].count > 8) {
        [[[XMFaceManager shareInstance] recentFaceArrays] removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[[XMFaceManager shareInstance] recentFaceArrays] forKey:@"recentFaceArrays"];
    return YES;
}

@end
