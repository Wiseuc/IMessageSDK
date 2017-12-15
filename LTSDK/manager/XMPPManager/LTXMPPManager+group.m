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


- (void)sendRequestGroupCompleted:(LTXMPPManager_friend_queryGroupsBlock)friend_queryGroupsBlock {
    self.friend_queryGroupsBlock = friend_queryGroupsBlock;
    
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




@end
