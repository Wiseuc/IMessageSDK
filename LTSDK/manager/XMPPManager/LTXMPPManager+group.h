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
 @abstract add：发送创建群组请求
 @discussion <#备注#>
 @param aGroupID 群组ID
 @param aDomain 域名
 @param aResource 资源
 @param aBlock 回调
 */
-(void)sendRequestCreateGroupWithGroupID:(NSString *)aGroupID
                                  domain:(NSString *)aDomain
                                resource:(NSString *)aResource
                               completed:(LTXMPPManager_group_didReceiveCreateGroupResponseBlock)aBlock;

/*!
 @method
 @abstract 创建群组
 @discussion <#备注#>
 @param aRoomID <#描述1#>
 @param aDomain <#描述2#>
 
 @param isCreateGroup 创建群／组
 @param groupName 名称
 @param groupTheme 主题
 @param groupIntroduction 简介
 @param groupNotice 公告
 @param aBlock 回调
 */
-(void)createGroupWithRoomID:(NSString *)aRoomID
                      domain:(NSString *)aDomain

               isCreateGroup:(BOOL)isCreateGroup
                   groupName:(NSString *)groupName
                  groupTheme:(NSString *)groupTheme
           groupIntroduction:(NSString *)groupIntroduction
                 groupNotice:(NSString *)groupNotice
                   completed:(LTXMPPManager_group_createGroupBlock)aBlock;






/**插入群组成员**/

/*!
 @method
 @abstract 插入群组成员
 @discussion <#备注#>
 @param groupMembers 成员jid
 @param roomID 群组ID
 @param domain 域名
 @param roomSubject 简介
 
 @param roomCreaterJID 创建着jid
 @param isCreateGroup 是否创建群
 @param aBlock 回调
 */

//- (void)inviteGroupMembers:(NSArray *)groupMembers
//                  toRoomID:(NSString *)roomID
//                    domain:(NSString *)domain

//               createGroup:(BOOL)isCreateGroup
//               roomSubject:(NSString *)roomSubject
//            roomCreaterJID:(NSString *)roomCreaterJID
//                 completed:(LTXMPPManager_group_inviteGroupMembersBlock)aBlock


-(void)inviteGroupMembersWithRoomID:(NSString *)aRoomID
                             domain:(NSString *)aDomain
                               jids:(NSMutableArray *)jids
                      isCreateGroup:(BOOL)isCreateGroup
                  groupIntroduction:(NSString *)groupIntroduction
                         createrJID:(NSString *)aCreaterJID
                          completed:(LTXMPPManager_group_inviteGroupMembersBlock)aBlock;







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
