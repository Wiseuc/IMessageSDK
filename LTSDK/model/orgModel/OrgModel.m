//
//  OrgModel.m
//  XMLParser
//
//  Created by 吴林峰 on 16/4/8.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "OrgModel.h"
#import "UIConfig.h"

@implementation OrgModel

- (instancetype)init
{
    if (self = [super init]) {
        _children = [NSArray array];
        _isExpand = NO;
        _isChoose = NO;
        _parent = [NSArray array];
        _parentIsChoose = [NSArray array];
        _lever = 0;
    }
    return self;
}

- (OrgItemType)orgItemType {
    return (OrgItemType)[_ITEMTYPE integerValue];
    
    
    
}

- (NSAttributedString *)subgroupAttributedString {
    NSString *subgroupString = [NSString stringWithFormat:@"%@ · %ld",self.NAME,(long)self.itemCount];
    NSMutableAttributedString *subgroupAttributedString = [[NSMutableAttributedString alloc] initWithString:subgroupString];
    NSRange range = [subgroupString rangeOfString:@" · "];
    [subgroupAttributedString addAttribute:NSForegroundColorAttributeName
                                     value:HEXCOLOR(0x107d22)
                                     range:NSMakeRange(range.location + range.length, subgroupString.length - (range.location + range.length))];
    
    
    
    return subgroupAttributedString;
}

- (void)addChild:(id)child
{
    NSMutableArray *children = [self.children mutableCopy];
    [children insertObject:child atIndex:0];
    self.children = [children copy];
}

@end
