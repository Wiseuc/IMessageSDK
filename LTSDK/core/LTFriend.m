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
    [LTXMPPManager.share sendRequestRosterCompleted:^(NSMutableArray *arrM, NSString *rosterVersion) {
        if (queryRostersBlock) {
            queryRostersBlock(arrM, nil);
        }
    }];
    
    
}


-(void)queryRosterVCardByJID:aJID completed:(LTFriend_queryRosterVCardBlock)queryRosterVCardBlock {
    [LTXMPPManager.share queryInformationByJid:aJID
                                     completed:^(NSDictionary *dict, LTError *error) {
                                         if (queryRosterVCardBlock) {
                                             queryRosterVCardBlock(dict);
                                         }
                                     }];
}


- (void)sendRequestAddFriendWithFriendJid:(NSString *)aFriendJid
                               friendName:(NSString *)aFriendName
                                completed:(LTFriend_addFriendBlock)aBlock {
    
    [LTXMPPManager.share sendRequestAddFriendWithFriendJid:aFriendJid
                                                friendName:aFriendName
                                                 completed:^(NSDictionary *dict, LTError *error) {
                                                     if (aBlock) {
                                                         aBlock(dict,error);
                                                     }
                                                 }];
}
@end
