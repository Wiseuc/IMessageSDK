//
//  LTGroup.m
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTGroup.h"
#import "LTXMPPManager+group.h"
@implementation LTGroup

+ (instancetype)share {
    static LTGroup *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTGroup alloc] init];
    });
    return instance;
}


-(void)queryGroupsCompleted:(LTGroup_queryGroupsBlock)queryGroupsBlock  {
    _queryGroupsBlock = queryGroupsBlock;
    
    [LTXMPPManager.share sendRequestGroupCompleted:^(NSMutableArray *arrM, NSString *groupVersion) {
        if (_queryGroupsBlock) {
            self.queryGroupsBlock(arrM, nil);
        }
    }];
}


-(void)queryGroupVCardByGroupJID:(NSString *)aGroupJID  completed:(LTGroup_queryGroupVCardBlock)queryGroupVCardBlock {
    [LTXMPPManager.share sendRequestQueryGroupVCardInformationByGroupJid:aGroupJID completed:^(NSDictionary *dict) {
        if (queryGroupVCardBlock) {
            queryGroupVCardBlock(dict);
        }
    }];
}






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
                               completed:(LTGroup_createGroupBlock)aBlock
{
    [LTXMPPManager.share sendRequestCreateGroupWithGroupID:aGroupID
                                                    domain:aDomain
                                                  resource:aResource
                                                 completed:^(LTError *error) {
                                                     if (aBlock) {
                                                         aBlock(error);
                                                     }
                                                 }];
}





/*!
 @method
 @abstract delete:删除群组
 @discussion 备注
 @param aGroupID 群组ID
 @param aBlock 回调
 */
-(void)sendRequestDeleteGroupWithGroupID:(NSString *)aGroupID
                               completed:(LTGroup_deleteGroupBlock)aBlock
{
    [LTXMPPManager.share sendRequestDeleteGroupWithGroupID:aGroupID
                                                 completed:^(LTError *error) {
                                                     if (aBlock) {
                                                         aBlock(error);
                                                     }
                                                 }];
}





//-(void)createGroupWithRoomID:(NSString *)roomid
//                     roomJID:(NSString *)roomJID
//                    presence:(NSString *)presence
//                      domain:(NSString *)domain
//                    resource:(NSString *)resource
//               isCreateGroup:(BOOL)isCreateGroup
//                  datasource:(NSMutableArray *)datasouce
//            groupDetailModel:(GroupDetailsModel *)groupDetailModel
//{
//    self.roomID = roomid;
//    self.presence = presence;
//    self.roomJID = roomJID;
//    self.domain = domain;
//    self.resource = resource;
//    self.isCreateGroup = isCreateGroup;
//    self.datasource = [datasouce copy];
//    self.groupDetailModel = groupDetailModel;
//
//    [XMPPManager sendPresenceToRoomID:self.roomID domain:self.domain resource:self.resource];
//}





@end
