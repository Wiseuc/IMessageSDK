//
//  LTXMPPManager+friend.h
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
void runCategoryForFramework40();

@interface LTXMPPManager (friend)

/**请求好友列表**/
- (void)sendRequestRosterCompleted:(LTXMPPManager_friend_queryRostersBlock)friend_queryRostersBlock;

/**获取资料VCard**/
- (void)queryInformationByJid:(NSString *)aJID completed:(LTXMPPManager_friend_queryRosterVCardBlock)aBlock;

/**请求添加好友**/
- (void)sendRequestAddFriendWithFriendJid:(NSString *)aFriendJid friendName:(NSString *)aFriendName completed:(LTXMPPManager_friend_addFriendBlock)aBlock;

/**同意添加好友**/
- (void)acceptAddFriendJid:(NSString *)aFriendJid friendName:(NSString *)aFriendName;

//拒绝添加好友
- (void)refuseAddFriendJid:(NSString *)aFriendJid;

//删除好友
- (void)deleteFriendJid:(NSString *)aFriendJid;
@end
