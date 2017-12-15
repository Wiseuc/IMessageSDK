//
//  LTGroup.m
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTGroup.h"
#import "LTXMPPManager+group.h"
@implementation LTGroup

+ (instancetype)share {
    static LTGroup *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTGroup alloc] init];
    });
    return instance;
}


-(void)queryGroupsCompleted:(LTGroup_queryGroupsBlock)queryGroupsBlock  {
    _queryGroupsBlock = queryGroupsBlock;
    
    [LTXMPPManager.share sendRequestGroupCompleted:^(NSMutableArray *arrM, NSString *groupVersion) {
        if (_queryGroupsBlock) {
            self.queryGroupsBlock(arrM, nil);
        }
    }];
}



@end
