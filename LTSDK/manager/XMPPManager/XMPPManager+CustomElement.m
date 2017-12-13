//
//  XMPPManager+CustomElement.m
//  WiseUC
//
//  Created by 吴林峰 on 15/12/18.
//  Copyright © 2015年 WiseUC. All rights reserved.
//

#import "XMPPManager+CustomElement.h"
#import "List.h"
#import "LT_Macros.h"

@implementation XMPPManager (CustomElement)

- (void)xmppStream:(XMPPStream *)sender didReceiveCustomElement:(NSXMLElement *)element {
    // 扩展消息
    //    <extmsg id="jcl_107" from="admin@115871" protocolid="broadcast" needreply="false" to="789@115871">
    //        <msg textid="107" count="1"/>
    //    </extmsg>
    NSString *protocolid = [[element attributeForName:kStringXMPPEXTMessageProtocolid] stringValue];
    if ( protocolid && [protocolid isEqualToString:kStringXMPPEXTMessageBroadcast] ) {
        [self postNewNotice];
    }
    else if( protocolid && [protocolid isEqualToString:kStringXMPPEXTMessageVoting] ) {
        [self postNewVoting];
    }
    else if( protocolid && [protocolid isEqualToString:kStringXMPPEXTMessageApprove] ) {
        [self postNewApprove];
    }
}


- (void)postNewNotice {
    [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_NewNotice object:nil];
}

- (void)postNewVoting {
    [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_NewVoting object:nil];
}

- (void)postNewApprove {
    [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_NewApprove object:nil];
}

@end
