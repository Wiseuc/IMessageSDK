//
//  LTGroup.h
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTError.h"
typedef void(^LTGroup_queryGroupsBlock)(NSMutableArray *groups, LTError *error);
typedef void(^LTGroup_queryGroupVCardBlock)(NSDictionary *dict);
typedef void(^LTGroup_createGroupBlock)(LTError *error);
typedef void(^LTGroup_deleteGroupBlock)(LTError *error);



@interface LTGroup : NSObject
@property (nonatomic, strong) LTGroup_queryGroupsBlock queryGroupsBlock;


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 请求群组列表
 @discussion 回调返回群组列表
 */
- (void)queryGroupsCompleted:(LTGroup_queryGroupsBlock)queryGroupsBlock;



/*!
 @method
 @abstract 获取群组VCard
 @discussion 回调返回群组列表
 @param aGroupJID 群组jid
 */
-(void)queryGroupVCardByGroupJID:(NSString *)aGroupJID  completed:(LTGroup_queryGroupVCardBlock)queryGroupVCardBlock;





/*!
 @method
 @abstract 创建群组
 @discussion <#备注#>
 
 @param roomid 群组ID  如：10C755CEDC2540089ECFBB6AE6A5D8C3
 @param roomJID 群租jid  如：10c755cedc2540089ecfbb6ae6a5d8c3@conference.duowin-server/江海
 @param presence 如：10c755cedc2540089ecfbb6ae6a5d8c3@conference.duowin-server/江海
 @param conferenceDomain 如：conference.duowin-server
 @param resource 群主名字  如：江海
 @param jids 成员jid数组（不带／IphoneIM）
 
 @param isCreateGroup （0:创建讨论组  1:创建群）
 @param groupName 群组名称
 @param groupTheme 群主题
 @param groupIntroduction 群介绍
 @param groupNotice 群公告
 
 @param aBlock 回调
 */
-(void)sendRequesCreateGroupWithRoomID:(NSString *)roomid
                               roomJID:(NSString *)roomJID
                              presence:(NSString *)presence
                      conferenceDomain:(NSString *)conferenceDomain
                              resource:(NSString *)resource
                                  jids:(NSMutableArray *)jids

                         isCreateGroup:(BOOL)isCreateGroup
                             groupName:(NSString *)groupName
                            groupTheme:(NSString *)groupTheme
                     groupIntroduction:(NSString *)groupIntroduction
                           groupNotice:(NSString *)groupNotice
                            createrJID:(NSString *)aCreaterJID

                             completed:(LTGroup_createGroupBlock)aBlock;




/*!
 @method
 @abstract delete:删除群组
 @discussion 备注
 @param aGroupID 群组ID
 @param aBlock 回调
 */
-(void)sendRequestDeleteGroupWithGroupID:(NSString *)aGroupID
                               completed:(LTGroup_deleteGroupBlock)aBlock;





@end
