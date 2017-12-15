//
//  LTXMPPManager+group.h
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
void runCategoryForFramework41();


@interface LTXMPPManager (group)


/**请求好友列表**/
- (void)sendRequestGroupCompleted:(LTXMPPManager_friend_queryGroupsBlock)friend_queryGroupsBlock;



@end
