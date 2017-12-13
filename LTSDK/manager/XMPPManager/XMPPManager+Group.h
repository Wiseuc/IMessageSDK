//
//  XMPPManager+Group.h
//  WiseUC
//
//  Created by wj on 16/3/18.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager.h"

@interface XMPPManager (Group)

//获取群列表
+ (void)getGroups;
//获取群消息
+ (void)getGroupJid:(NSString *)groupJid;
//退出群
+ (void)getOutOfGroupJid:(NSString *)groupJid;
//删除群 销毁群
+(void)deleteGroupJid:(NSString *)groupJid;
//请出群 群主和管理员删除群成员
+ (void)pleaseGetOutOfTheGroupJid:(NSString *)groupJid withPersonJid:(NSString *)personJid;
//搜索所有群
+ (void)searchAllGroups:(NSString *)searchText withStartNo:(NSInteger)startNo withEndNo:(NSInteger)endNo withRealmName:(NSString *)realmName;
//申请进群
+ (void)applyGetIntoTheGroupJid:(NSString *)groupJid withAdmin:(NSString *)admin withName:(NSString *)groupName;
//拒绝加入群
+ (void)refuseAddGroupToPersonJid:(NSString *)personjid withGroupName:(NSString *)groupName;
//同意加入群
+(void)agreeAddGroupJid:(NSString *)groupJid toPerson:(NSString *)person byPersonJid:(NSString *)byJid;

@end
