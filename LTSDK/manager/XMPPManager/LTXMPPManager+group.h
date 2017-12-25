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


/**请求群组列表**/
- (void)sendRequestGroupCompleted:(LTXMPPManager_group_queryGroupsBlock)group_queryGroupsBlock;

/**获取群组资料VCard**/
- (void)sendRequestQueryGroupVCardInformationByGroupJid:(NSString *)aGroupJid completed:(LTXMPPManager_group_queryGroupVCardBlock)aBlock;

@end
