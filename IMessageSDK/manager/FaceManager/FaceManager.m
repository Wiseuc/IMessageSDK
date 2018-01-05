//
//  FaceManager.m
//  IMessageSDK
//
//  Created by JH on 2018/1/5.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "FaceManager.h"

@implementation FaceManager


+ (instancetype)share {
    static FaceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FaceManager alloc] init];
    });
    return instance;
}







@end
