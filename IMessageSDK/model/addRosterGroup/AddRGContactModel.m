//
//  AddRGContactModel.m
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AddRGContactModel.h"

@implementation AddRGContactModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _phoneNumbers = [NSArray array];
    }
    return self;
}

@end
