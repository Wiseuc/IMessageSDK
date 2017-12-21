//
//  LTStack.m
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTStack.h"
@interface LTStack ()

@property (nonatomic, strong) NSMutableArray *datasource;
@end



@implementation LTStack

- (instancetype)init{
    self = [super init];
    if (self) {
        self.datasource  = [NSMutableArray array];
    }
    return self;
}



-(void)push:(OrgModel *)model{
    [self.datasource insertObject:model atIndex:0];
    
}


-(void)pop {
    [self.datasource removeObjectAtIndex:0];
}


-(void)clear {
    [self.datasource removeAllObjects];
}



-(OrgModel *)queryTopItem {
    return self.datasource.firstObject;
}



-(OrgModel *)queryBottomItem {
    return self.datasource.lastObject;
}


-(NSString *)queryStackDescription {
    NSMutableArray *arrM = [NSMutableArray array];
    for (OrgModel *model in self.datasource) {
        [arrM insertObject:model.NAME atIndex:0];
    }
    return [arrM componentsJoinedByString:@">>"];
}


-(NSUInteger)queryStackCount {
    return self.datasource.count;
}
@end
