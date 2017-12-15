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


@end
