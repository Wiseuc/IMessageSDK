//
//  XMPPManager+Friend.h
//  WiseUC
//
//  Created by wj on 16/3/18.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager.h"

@interface XMPPManager (Friend)
//请求添加好友
+ (void)addFriendJid:(NSString *)friendJid withName:(NSString *)name;
//删除好友
+ (void)deleteFriendJid:(NSString *)friendJid;
//同意添加好友
+ (void)agreeAddFriendJid:(NSString *)friendJid withName:(NSString *)name;
//拒绝添加好友
+ (void)refuseAddFriendJid:(NSString *)friendJid;
// 请求服务器获取好友
+ (void)requestFriends;

@end
