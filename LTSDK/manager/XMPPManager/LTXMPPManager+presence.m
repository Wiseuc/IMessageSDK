//
//  LTXMPPManager+presence.m
//  LTSDK
//
//  Created by JH on 2017/12/14.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager+presence.h"
void runCategoryForFramework36(){}
@implementation LTXMPPManager (presence)


-(void)sendPresenceAvailable {
    XMPPPresence *presence = [XMPPPresence presenceWithType:kStringXMPPPresenceAvailable];
    [presence addAttributeWithName:kStringXMPPFrom stringValue:[[self.aXMPPStream myJID] full]];
    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceShow stringValue:@""]];
    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceStatus stringValue:@"在线"]];
    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresencePriority stringValue:@"0"]];
    [_xmppStream sendElement:presence];
}

-(void)sendPresenceUNAvailable {
    XMPPPresence *presence = [XMPPPresence presenceWithType:kStringXMPPPresenceUnavailable];
    [presence addAttributeWithName:kStringXMPPPresenceShow stringValue:kStringXMPPPresenceShowAwayForALongTime];
    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceStatus stringValue:@"离线"]];
    [_xmppStream sendElement:presence];
}

@end
