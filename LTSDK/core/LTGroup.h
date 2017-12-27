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
 @abstract add：创建群组
 @discussion 备注
 @param aGroupID 群组ID
 @param aDomain 域名
 @param aResource 资源
 @param aBlock 回调
 */
-(void)sendRequestCreateGroupWithGroupID:(NSString *)aGroupID
                                  domain:(NSString *)aDomain
                                resource:(NSString *)aResource
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




-(void)createGroupWithRoomID:(NSString *)roomid
                     roomJID:(NSString *)roomJID
                    presence:(NSString *)presence
                      domain:(NSString *)domain
                    resource:(NSString *)resource
               isCreateGroup:(BOOL)isCreateGroup
                  datasource:(NSMutableArray *)datasouce
            groupDetailModel:(GroupDetailsModel *)groupDetailModel;





@end
