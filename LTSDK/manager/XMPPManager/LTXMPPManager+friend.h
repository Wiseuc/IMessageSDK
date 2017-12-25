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


/**通过JID获取资料**/
- (void)queryInformationByJid:(NSString *)aJID completed:(LTXMPPManager_iq_queryInformationByJidBlock)aBlock;


@end
