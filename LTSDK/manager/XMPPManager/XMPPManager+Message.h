//
//  XMPPManager+Message.h
//  WiseUC
//
//  Created by mxc235 on 16/6/24.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager.h"

@interface XMPPManager (Message)

// 发送正在输入的消息
+ (void)sendInputStatusToJid:(NSString *)jid;

// 邀请进群的消息
+ (void)inviteGroupMembers:(NSArray *)groupMembers toRoomID:(NSString *)roomID domain:(NSString *)domain roomSubject:(NSString *)roomSubject roomCreaterJID:(NSString *)roomCreaterJID createGroup:(BOOL)isCreateGroup;

// 发送接收到的消息已经读取
+ (void)sendHasReadMessage:(NSString *)messageId ToJid:(NSString *)jid ;


@end
