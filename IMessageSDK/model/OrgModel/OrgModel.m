//
//  OrgModel.m
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "OrgModel.h"

@implementation OrgModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _children = [NSArray array];
        _parent = [NSArray array];
        _lever  = 0;
        _isSelect = NO;
        _isAdd = NO;
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
