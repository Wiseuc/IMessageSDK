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


/**
 请求我已经加入的群组列表
 **/
- (void)sendRequestGroupCompleted:(LTXMPPManager_group_queryGroupsBlock)group_queryGroupsBlock;





/*!
 @method
 @abstract add：创建群组
 @discussion <#备注#>
 @param aGroupID 群组ID
 @param aDomain 域名
 @param aResource 资源
 @param aBlock 回调
 */
-(void)sendRequestCreateGroupWithGroupID:(NSString *)aGroupID
                                  domain:(NSString *)aDomain
                                resource:(NSString *)aResource
                               completed:(LTXMPPManager_group_createGroupBlock)aBlock;






/*!
 @method
 @abstract delete:删除群组
 @discussion <#备注#>
 @param aGroupID 群组ID
 @param aBlock 回调
 */
-(void)sendRequestDeleteGroupWithGroupID:(NSString *)aGroupID
                               completed:(LTXMPPManager_group_deleteGroupBlock)aBlock;

/**
 update
 删除群组成员
 **/



/**
 update
 添加群组成员
 **/




/**
 query
 查找群组
 **/




/**
 query
 获取群组资料VCard
 **/
- (void)sendRequestQueryGroupVCardInformationByGroupJid:(NSString *)aGroupJid
                                              completed:(LTXMPPManager_group_queryGroupVCardBlock)aBlock;




/**
 同意某人加入群组
 **/



/**
 拒绝某人加入群组
 **/





@end
