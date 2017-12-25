//
//  LTFriend.m
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTFriend.h"
#import "LTXMPPManager+friend.h"

@implementation LTFriend

+ (instancetype)share {
    static LTFriend *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTFriend alloc] init];
    });
    return instance;
}


-(void)queryRostersCompleted:(LTFriend_queryRostersBlock)queryRostersBlock {
    _queryRostersBlock = queryRostersBlock;
    
    [LTXMPPManager.share sendRequestRosterCompleted:^(NSMutableArray *arrM, NSString *rosterVersion) {
        if (_queryRostersBlock) {
            self.queryRostersBlock(arrM, nil);
        }
    }];
    
    
}


-(void)queryInformationByJID:aJID completed:(LTUser_queryInformationByJIDBlock)queryInformationByJIDBlock {
    [LTXMPPManager.share queryInformationByJid:aJID
                                     completed:^(NSDictionary *dict, LTError *error) {
                                         if (queryInformationByJIDBlock) {
                                             queryInformationByJIDBlock(dict);
                                         }
                                     }];
}



@end
