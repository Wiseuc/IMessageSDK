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
 
 <presence to="10C755CEDC2540089ECFBB6AE6A5D8C3@conference.duowin-server/江海">
 <x xmlns="http://jabber.org/protocol/muc"></x>
 <show></show>
 </presence>
 **/
-(void)sendRequestCreateGroupWithGroupID:(NSString *)aGroupID
                                  domain:(NSString *)aDomain
                                resource:(NSString *)aResource
                               completed:(LTXMPPManager_group_didReceiveCreateGroupResponseBlock)aBlock
{
    self.group_didReceiveCreateGroupResponseBlock = aBlock;
    
    XMPPJID *jid = [XMPPJID jidWithUser:aGroupID domain:aDomain resource:aResource];
    XMPPPresence *presence = [XMPPPresence presenceWithType:nil to:jid];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc"];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    
    [presence addChild:x];
    [presence addChild:show];
    [self.aXMPPStream sendElement:presence];
}

-(void)createGroupWithRoomID:(NSString *)aRoomID
                      domain:(NSString *)aDomain

               isCreateGroup:(BOOL)isCreateGroup
                   groupName:(NSString *)groupName
                  groupTheme:(NSString *)groupTheme
           groupIntroduction:(NSString *)groupIntroduction
                 groupNotice:(NSString *)groupNotice

                   completed:(LTXMPPManager_group_createGroupBlock)aBlock
{
    self.group_createGroupBlock = aBlock;
    XMPPJID *jid = [XMPPJID jidWithUser:aRoomID domain:aDomain resource:nil];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:jid elementID:nil];

    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#owner"];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];

    NSArray *vars = @[@"leave",@"join",@"rename",
                      @"muc#roomconfig_roomname",@"muc#roomconfig_cgsubject",
                      @"muc#roomconfig_maxusers",@"muc#roomconfig_roomdesc",
                      @"muc#roomconfig_roomintro",@"muc#roomconfig_membersonly",
                      @"muc#roomconfig_moderatedroom",@"muc#roomconfig_persistentroom"];

    groupNotice = groupNotice.length > 0 ? groupNotice:@"暂无公告";
    groupIntroduction = groupIntroduction.length > 0 ? groupIntroduction:@"暂无简介";
    NSArray *values = @[
                        @"离开了这个群组",
                        @"加入了这个群组",
                        @"1",
                        groupName,
                        groupTheme,
                        @"500",
                        groupNotice,
                        groupIntroduction,
                        @"1",
                        @"1",
                        isCreateGroup?@"1" : @"0"
                        ];

    for (NSInteger i = 0; i < vars.count; i ++) {
        NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
        [field addAttributeWithName:@"var" stringValue:vars[i]];
        NSXMLElement *value = [NSXMLElement elementWithName:@"value" stringValue:values[i]];
        [field addChild:value];
        [x addChild:field];
    }
    [query addChild:x];
    [iq addChild:query];
    [self.aXMPPStream sendElement:iq];
}
/**插入群组成员**/
- (void)inviteGroupMembers:(NSArray *)groupMembers
                  toRoomID:(NSString *)roomID
                    domain:(NSString *)domain
               roomSubject:(NSString *)roomSubject
            roomCreaterJID:(NSString *)roomCreaterJID
               createGroup:(BOOL)isCreateGroup
                 completed:(LTXMPPManager_group_inviteGroupMembersBlock)aBlock
{
    self.group_inviteGroupMembersBlock = aBlock;
    
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
    [self.aXMPPStream sendElement:message];
}




/**
SEND: <message to="31454da291884a9197fa69eebe6fd64a@conference.duowin-server"><x xmlns="http://jabber.org/protocol/muc#user"><invite to="江海@duowin-server"><reason/><enforce>1</enforce></invite><invite to="测试2@duowin-server"><reason/><enforce>1</enforce></invite><invite to="测试3@duowin-server"><reason/><enforce>1</enforce></invite><invite to="test010@duowin-server"><reason/><enforce>1</enforce></invite><invite to="demo@duowin-server"><reason/><enforce>1</enforce></invite></x><RoomCreater>江海</RoomCreater><RoomCreaterJID>江海@duowin-server</RoomCreaterJID><RoomSubject>ll</RoomSubject><Persisdent>1</Persisdent></message>
 
RECV: <message xmlns="jabber:client" type="normal" to="江海@duowin-server/IphoneIM" from="31454da291884a9197fa69eebe6fd64a@conference.duowin-server"><subject>Invitation</subject><body/><x xmlns="http://jabber.org/protocol/muc#user" name="hjl"><invite to="江海@duowin-server"><reason/><enforce>1</enforce></invite></x><RoomCreater>江海</RoomCreater><RoomCreaterJID>江海@duowin-server</RoomCreaterJID><RoomSubject>ll</RoomSubject><Persisdent>1</Persisdent></message>

 **/
-(void)inviteGroupMembersWithRoomID:(NSString *)aRoomID
                             domain:(NSString *)aDomain
                               jids:(NSMutableArray *)jids

                      isCreateGroup:(BOOL)isCreateGroup
                  groupIntroduction:(NSString *)groupIntroduction
                         createrJID:(NSString *)aCreaterJID
                          completed:(LTXMPPManager_group_inviteGroupMembersBlock)aBlock
{
    self.group_inviteGroupMembersBlock = aBlock;
    
    XMPPJID *jid = [XMPPJID jidWithUser:aRoomID domain:aDomain resource:nil];
    XMPPMessage *message = [XMPPMessage messageWithType:nil to:jid];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    for (NSInteger i = 0; i < jids.count; i ++) {
        NSXMLElement *invite = [NSXMLElement elementWithName:@"invite"];
        [invite addAttributeWithName:@"to" stringValue:jids[i]];
        NSXMLElement *reason = [NSXMLElement elementWithName:@"reason"];
        NSXMLElement *enforce = [NSXMLElement elementWithName:@"enforce" stringValue:@"1"];
        [invite addChild:reason];
        [invite addChild:enforce];
        [x addChild:invite];
    }
    
    NSXMLElement *roomCreater = [NSXMLElement elementWithName:@"RoomCreater" stringValue:[[aCreaterJID componentsSeparatedByString:@"@"] firstObject]];
    NSXMLElement *roomerCreaterJID = [NSXMLElement elementWithName:@"RoomCreaterJID" stringValue:aCreaterJID];
    NSXMLElement *roomerSubject = [NSXMLElement elementWithName:@"RoomSubject" stringValue:groupIntroduction];
    NSXMLElement *persisdent = [NSXMLElement elementWithName:@"Persisdent" stringValue:isCreateGroup  ? @"1" : @"0"];
    
    [message addChild:x];
    [message addChild:roomCreater];
    [message addChild:roomerCreaterJID];
    [message addChild:roomerSubject];
    [message addChild:persisdent];
    [self.aXMPPStream sendElement:message];
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
