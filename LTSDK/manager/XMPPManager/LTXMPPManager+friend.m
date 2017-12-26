//
//  LTXMPPManager+friend.m
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager+friend.h"
void runCategoryForFramework40(){}
@implementation LTXMPPManager (friend)


/**获取好友列表**/
-(void)sendRequestRosterCompleted:(LTXMPPManager_friend_queryRostersBlock)friend_queryRostersBlock {
    
    self.friend_queryRostersBlock = friend_queryRostersBlock;
    // 生成一串xml数据，向服务器获取好友信息
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    //  XMPPIQ *iq = [XMPPIQ iqWithType:kStringXMPPIQTypeGet elementID:kStringXMPPElementIDRoster];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"id" stringValue:kStringXMPPElementIDRoster];
    [iq addChild:query];
    NSLog(@"获取好友：iq :%@",iq);
    [self.aXMPPStream sendElement:iq];
}



//获取个人消息
-(void)queryInformationByJid:(NSString *)aJID completed:(LTXMPPManager_friend_queryRosterVCardBlock)aBlock {
    self.friend_queryRosterVCardByJidBlock = aBlock;
    NSString *elementID = @"rstrone";
    XMPPJID *to = [XMPPJID jidWithString:aJID];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
    [query addAttributeWithName:kStringXMPPVersion stringValue:@"0"];
    [iq addChild:query];
    [self.aXMPPStream sendElement:iq];
}



/**添加好友**/
- (void)sendRequestAddFriendWithFriendJid:(NSString *)aFriendJid
                               friendName:(NSString *)aFriendName
                                completed:(LTXMPPManager_friend_addFriendBlock)aBlock {
    
    self.friend_addFriendBlock = aBlock;
    NSString *elementID = kStringXMPPElementIDAddFriend;
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    
    NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
    [item addAttributeWithName:@"jid" stringValue:aFriendJid];
    [item addAttributeWithName:@"name" stringValue:aFriendName];
    
    NSXMLElement *group = [NSXMLElement elementWithName:@"group"];
    [group setStringValue:@"我的同事"];
    [query addChild:item];
    [item addChild:group];
    [iq addChild:query];
    //发送请求
    [self.aXMPPStream sendElement:iq];
    
    
    //在线状态，订阅
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:kStringXMPPTo stringValue:aFriendJid];
    [presence addAttributeWithName:@"type" stringValue:@"subscribe"];
    [presence addChild:[NSXMLElement elementWithName:@"show"]];
    [self.aXMPPStream sendElement:presence];
}








@end
