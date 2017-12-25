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



@end
