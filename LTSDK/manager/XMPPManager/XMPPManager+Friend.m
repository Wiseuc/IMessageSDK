//
//  XMPPManager+Friend.m
//  WiseUC
//
//  Created by wj on 16/3/18.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager+Friend.h"

@implementation XMPPManager (Friend)
/*
 主动
 1.申请加好友
 SENT:
 <iq id="jcl_173" type="set"><query xmlns="jabber:iq:roster">
         <item jid="test003@duowin-server" name="test003">
             <group>
                   我的同事
             </group>
         </item>
         </query>
 </iq>
 
 
 
 
 RECV:
 <iq type='set'><query xmlns='jabber:iq:roster' ver='952'><item jid='test003@duowin-server' name='test003' subscription='none'><group>我的同事</group></item></query></iq>
 RECV:
 <iq id='jcl_173' type='result' from='刘腮宝@duowin-server/WinduoIM' to='刘腮宝@duowin-server/WinduoIM'/>
 */

//请求添加好友 (是好友就订阅消息，不是就取消订阅)
+ (void)addFriendJid:(NSString *)friendJid withName:(NSString *)name
{
    NSString *elementID = kStringXMPPElementIDAddFriend;
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" elementID:elementID];
    //    [XMPPIQ iqWithType:@"set" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    
    NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
    [item addAttributeWithName:@"jid" stringValue:friendJid];
    [item addAttributeWithName:@"name" stringValue:name];
    
    NSXMLElement *group = [NSXMLElement elementWithName:@"group"];
    [group setStringValue:@"我的同事"];
    [query addChild:item];
    [item addChild:group];
    [iq addChild:query];
    //发送请求
    [[XMPPManager shareXMPPManager].xmppStream sendElement:iq];
    
    //在线状态，订阅
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:kStringXMPPTo stringValue:friendJid];
    [presence addAttributeWithName:@"type" stringValue:kStringXMPPPresenceTypeSubscribe];
    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceShow]];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:presence];
}
//删除好友
+ (void)deleteFriendJid:(NSString *)friendJid
{
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:kStringXMPPTo stringValue:friendJid];
    [presence addAttributeWithName:@"type" stringValue:@"unsubscribe"];
    
    [[XMPPManager shareXMPPManager].xmppStream sendElement:presence];
}
//同意添加好友
+ (void)agreeAddFriendJid:(NSString *)friendJid withName:(NSString *)name
{
    NSString *elementID = kStringXMPPElementIDAgreeAddFriend;
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
    [item addAttributeWithName:@"jid" stringValue:friendJid];
    [item addAttributeWithName:@"name" stringValue:name];
    NSXMLElement *group = [NSXMLElement elementWithName:@"group"];
    [group setStringValue:@"我的同事"];
    [query addChild:item];
    [item addChild:group];
    [iq addChild:query];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:iq];
    
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:kStringXMPPTo stringValue:friendJid];
    [presence addAttributeWithName:@"type" stringValue:kStringXMPPPresenceSubscribed];
    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceShow]];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:presence];
    
    if (kSolveBug_AcceptNewFriendRequest) {
        XMPPPresence *presence2 = [XMPPPresence presence];
        [presence2 addAttributeWithName:kStringXMPPTo stringValue:friendJid];
        [presence2 addAttributeWithName:@"type" stringValue:kStringXMPPPresenceTypeSubscribe];
        [presence2 addChild:[NSXMLElement elementWithName:kStringXMPPPresenceShow]];
        [[XMPPManager shareXMPPManager].xmppStream sendElement:presence2];
    }
}
//拒绝添加好友
+ (void)refuseAddFriendJid:(NSString *)friendJid
{
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:kStringXMPPTo stringValue:friendJid];
    [presence addAttributeWithName:@"type" stringValue:@"unsubscribed"];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    [presence addChild:show];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:presence];
}

// 请求服务器获取好友
+ (void)requestFriends
{
    // 生成一串xml数据，向服务器获取好友信息
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    //  XMPPIQ *iq = [XMPPIQ iqWithType:kStringXMPPIQTypeGet elementID:kStringXMPPElementIDRoster];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"id" stringValue:kStringXMPPElementIDRoster];
    [iq addChild:query];
    
    NSLog(@"获取好友：iq :%@",iq);
    
    // 向服务器发送请求，获取好友列表
    [[XMPPManager shareXMPPManager].xmppStream sendElement:iq];
}
@end
