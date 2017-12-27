//
//  LTXMPPManager+group.m
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager+group.h"
void runCategoryForFramework41(){}

@implementation LTXMPPManager (group)


- (void)sendRequestGroupCompleted:(LTXMPPManager_group_queryGroupsBlock)group_queryGroupsBlock {
    self.group_queryGroupsBlock = group_queryGroupsBlock;
    
    NSMutableString *host = [[NSMutableString alloc] initWithString:self.aXMPPStream.myJID.full];
    [host remainAfterString:@"@"];
    //  NSString *hostName = @"duowin-server/IphoneIM";
    XMPPJID *to = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@.%@", @"conference", host]];
    XMPPIQ *iq = [XMPPIQ iqWithType: @"get" to:to elementID:@"groups"];
    [iq addAttributeWithName:@"var" stringValue:@"self"];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns: @"jabber:iq:browse"];
    [query addAttributeWithName:@"ver" stringValue:0];
    [iq addChild:query];
    [self.aXMPPStream sendElement:iq];
}

//获取群资料
- (void)sendRequestQueryGroupVCardInformationByGroupJid:(NSString *)aGroupJid
                                              completed:(LTXMPPManager_group_queryGroupVCardBlock)aBlock
{
    self.group_queryGroupVCardBlock = aBlock;
    //  NSString *to = groupJid;
    NSString *elementID = kStringXMPPElementIDRoster4One;
    XMPPJID *to = [XMPPJID jidWithString:aGroupJid];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    [iq addChild:query];
    [self.aXMPPStream sendElement:iq];
}





/**
 add
 创建群组
 **/
-(void)sendRequestCreateGroupWithGroupID:(NSString *)aGroupID
                                  domain:(NSString *)aDomain
                                resource:(NSString *)aResource
                               completed:(LTXMPPManager_group_createGroupBlock)aBlock
{
    self.group_createGroupBlock = aBlock;
    
    XMPPJID *jid = [XMPPJID jidWithUser:aGroupID domain:aDomain resource:aResource];
    XMPPPresence *presence = [XMPPPresence presenceWithType:nil to:jid];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc"];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    
    [presence addChild:x];
    [presence addChild:show];
    [self.aXMPPStream sendElement:presence];
}




/**
 delete
 删除群组
 **/
-(void)sendRequestDeleteGroupWithGroupID:(NSString *)aGroupID
                               completed:(LTXMPPManager_group_deleteGroupBlock)aBlock
{
    self.group_deleteGroupBlock = aBlock;
    
    NSString *elementID = kStringXMPPElementIDDeleteGroup;
    XMPPJID *to = [XMPPJID jidWithString:aGroupID];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:to elementID:elementID];
    [iq addAttributeWithName:@"passkey" stringValue:@"1"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#owner"];
    NSXMLElement *destroy = [NSXMLElement elementWithName:@"destroy"];
    [query addChild:destroy];
    
    [iq addChild:query];
    [self.aXMPPStream sendElement:iq];
}


































@end
