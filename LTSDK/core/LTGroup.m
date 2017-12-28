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




/**
 roomid:            10C755CEDC2540089ECFBB6AE6A5D8C3
 presence:          10c755cedc2540089ecfbb6ae6a5d8c3/江海
 roomJID:           10c755cedc2540089ecfbb6ae6a5d8c3@conference.duowin-server
 domain:            conference.duowin-server
 resource:          江海
 isCreateGroup:     NO
 datasource:        NSArray
 groupDetailModel:  群组信息 name  theme  intro  title  subTitle
 
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, strong) NSString *theme;
 @property (nonatomic, strong) NSString *introduction;
 @property (nonatomic, strong) NSString *notice;
 **/

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
{
    
    
    __weak typeof(self) weakself = self;
    [LTXMPPManager.share sendRequestCreateGroupWithGroupID:roomid
                                                    domain:conferenceDomain
                                                  resource:resource
                                                 completed:^(NSDictionary *dict, LTError *error) {
                                                    
                                                     //1a1be8d8181f4c7da89a8bc45d3d5389@conference.duowin-server/江海
                                                     /**判断是不是自己发起的创建群**/
                                                     NSString *form0 = [NSString stringWithFormat:@"%@/%@",roomJID,resource];
                                                     NSString *from = dict[@"from"];
                                                     if ([from isEqualToString:form0])
                                                     {
                                                         [weakself createGroupWithRoomID:roomid
                                                                                  domain:conferenceDomain
                                                                                    jids:(NSMutableArray *)jids
                                                          
                                                                           isCreateGroup:isCreateGroup
                                                                               groupName:groupName
                                                                              groupTheme:groupTheme
                                                                       groupIntroduction:groupIntroduction
                                                                             groupNotice:groupNotice
                                                                              createrJID:aCreaterJID];
                                                     }
                                                 }];
}


-(void)createGroupWithRoomID:(NSString *)aRoomID
                      domain:(NSString *)aDomain
                        jids:(NSMutableArray *)jids

               isCreateGroup:(BOOL)isCreateGroup
                   groupName:(NSString *)groupName
                  groupTheme:(NSString *)groupTheme
           groupIntroduction:(NSString *)groupIntroduction
                 groupNotice:(NSString *)groupNotice
                  createrJID:(NSString *)aCreaterJID
{
    [LTXMPPManager.share createGroupWithRoomID:aRoomID
                                        domain:aDomain
     
                                 isCreateGroup:isCreateGroup
                                     groupName:groupName
                                    groupTheme:groupTheme
                             groupIntroduction:groupIntroduction
                                   groupNotice:groupNotice
                                     completed:^(NSDictionary *dict, LTError *error) {
                                        
                                         /**
                                          from = "3d06a64e86fd421db468e040fa882d0e@conference.duowin-server";
                                          **/
                                         /**判断是不是自己发起的创建群**/
                                         NSString *from = dict[@"from"];
                                         if ([from containsString:[aRoomID lowercaseString]])
                                         {
                                             [self inviteGroupMembersWithRoomID:aRoomID
                                                                         domain:aDomain
                                                                           jids:jids
                                                                  isCreateGroup:isCreateGroup
                                                              groupIntroduction:groupIntroduction
                                                                     createrJID:aCreaterJID];
                                             
                                             
                                         }
                                     }];
}


/*!
 @method
 @abstract 插入群组成员
 @discussion <#备注#>
 @param aRoomID 群组ID
 @param aDomain 域名
 @param jids 成员
 @param isCreateGroup 是否群
 @param groupIntroduction 群描述
 @param aCreaterJID 创建着jid
 */
-(void)inviteGroupMembersWithRoomID:(NSString *)aRoomID
                             domain:(NSString *)aDomain
                               jids:(NSMutableArray *)jids
                      isCreateGroup:(BOOL)isCreateGroup
                  groupIntroduction:(NSString *)groupIntroduction
                         createrJID:(NSString *)aCreaterJID
{
    
    [LTXMPPManager.share inviteGroupMembersWithRoomID:aRoomID
                                               domain:aDomain
                                                 jids:jids
                                        isCreateGroup:isCreateGroup
                                    groupIntroduction:groupIntroduction
                                           createrJID:aCreaterJID
                                            completed:^(NSDictionary *dict, LTError *error) {
                                                
                                                
                                                
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



@end
