//
//  XMPPManager+Message.m
//  WiseUC
//
//  Created by mxc235 on 16/6/24.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager+Message.h"

@implementation XMPPManager (Message)

+ (void)sendInputStatusToJid:(NSString *)jid
{
    XMPPJID *to = [XMPPJID jidWithString:jid];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:to];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:event"];
    NSXMLElement *composing = [NSXMLElement elementWithName:@"composing"];
    [x addChild:composing];
    [message addChild:body];
    [message addChild:x];
    
    [[XMPPManager shareXMPPManager].xmppStream sendElement:message];
}

+ (void)inviteGroupMembers:(NSArray *)groupMembers toRoomID:(NSString *)roomID domain:(NSString *)domain roomSubject:(NSString *)roomSubject roomCreaterJID:(NSString *)roomCreaterJID createGroup:(BOOL)isCreateGroup
{
    XMPPJID *jid = [XMPPJID jidWithUser:roomID domain:domain resource:nil];
    XMPPMessage *message = [XMPPMessage messageWithType:nil to:jid];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    for (NSInteger i = 0; i < groupMembers.count; i ++) {
        NSXMLElement *invite = [NSXMLElement elementWithName:@"invite"];
        [invite addAttributeWithName:@"to" stringValue:groupMembers[i]];
        NSXMLElement *reason = [NSXMLElement elementWithName:@"reason"];
        NSXMLElement *enforce = [NSXMLElement elementWithName:@"enforce" stringValue:@"1"];
        [invite addChild:reason];
        [invite addChild:enforce];
        [x addChild:invite];
    }
    
    NSXMLElement *roomCreater = [NSXMLElement elementWithName:@"RoomCreater" stringValue:[[roomCreaterJID componentsSeparatedByString:@"@"] firstObject]];
    NSXMLElement *roomerCreaterJID = [NSXMLElement elementWithName:@"RoomCreaterJID" stringValue:roomCreaterJID];
    NSXMLElement *roomerSubject = [NSXMLElement elementWithName:@"RoomSubject" stringValue:roomSubject];
    NSXMLElement *persisdent = [NSXMLElement elementWithName:@"Persisdent" stringValue:isCreateGroup  ? @"1" : @"0"];
    
    [message addChild:x];
    [message addChild:roomCreater];
    [message addChild:roomerCreaterJID];
    [message addChild:roomerSubject];
    [message addChild:persisdent];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:message];
}

+ (void)sendHasReadMessage:(NSString *)messageId ToJid:(NSString *)jid
{
    XMPPJID *to = [XMPPJID jidWithString:jid];
    XMPPMessage *message = [XMPPMessage messageWithType:@"ack" to:to];
    [message addAttributeWithName:@"UID" stringValue:[AppManager get_32Bytes_UUID]];
    [message addAttributeWithName:@"mid" stringValue:messageId];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:message];
}

@end
