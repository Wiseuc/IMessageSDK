//
//  XMPPManager+Group.m
//  WiseUC
//
//  Created by wj on 16/3/18.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager+Group.h"
#import "DownloadOrganizationsController.h"
#import "NSMutableString+ReplacingOccurencesOfString.h"

#import "UserManager.h"

@implementation XMPPManager (Group)

//获取群列表
+ (void)getGroups
{
    if (![UserManager shareInstance].currentUser.jid) {
        return;
    }
    
    if ( ![XMPPManager shareXMPPManager].xmppStream.myJID.full ) {
        return;
    }
    
    NSMutableString *host = [[NSMutableString alloc] initWithString:[XMPPManager shareXMPPManager].xmppStream.myJID.full];
    [host remainAfterString:@"@"];
    //  NSString *hostName = @"duowin-server/IphoneIM";
    XMPPJID *to = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@.%@", @"conference", host]];
    XMPPIQ *iq = [XMPPIQ iqWithType: @"get" to:to elementID:@"groups"];
    [iq addAttributeWithName:@"var" stringValue:@"self"];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns: @"jabber:iq:browse"];
    [query addAttributeWithName:@"ver" stringValue:0];
    
    [iq addChild:query];
    
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:iq];
}
//获取群消息
+ (void)getGroupJid:(NSString *)groupJid
{
    //  NSString *to = groupJid;
    NSString *elementID = kStringXMPPElementIDRoster4One;
    XMPPJID *to = [XMPPJID jidWithString:groupJid];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    [iq addChild:query];
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:iq];
}

//退出群
+ (void)getOutOfGroupJid:(NSString *)groupJid
{
    NSXMLElement *msg = [NSXMLElement elementWithName:kStringXMPPMessage];
    [msg addAttributeWithName:kStringXMPPTo stringValue:groupJid];
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc#apply"];
    NSXMLElement *applyout = [NSXMLElement elementWithName:@"applyout"];
    [x addChild:applyout];
    [msg addChild:x];
    NSLog(@"%@",msg);
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:msg];
}

//删除群 销毁群
+(void)deleteGroupJid:(NSString *)groupJid
{
    NSString *elementID = kStringXMPPElementIDDeleteGroup;
    XMPPJID *to = [XMPPJID jidWithString:groupJid];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:to elementID:elementID];
    [iq addAttributeWithName:@"passkey" stringValue:@"1"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#owner"];
    NSXMLElement *destroy = [NSXMLElement elementWithName:@"destroy"];
    [query addChild:destroy];
    
    [iq addChild:query];
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:iq];
    
}
//请出群 群主和管理员删除群成员
+ (void)pleaseGetOutOfTheGroupJid:(NSString *)groupJid withPersonJid:(NSString *)personJid
{
    //  NSString *elementID = kStringXMPPElementIDDeleteGroupMember;
    NSString *elementID = [AppManager get_32Bytes_UUID];
    XMPPJID *to = [XMPPJID jidWithString:groupJid];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#admin"];
    NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
    [item addAttributeWithName:@"affiliation" stringValue:@"none"];
    [item addAttributeWithName:@"jid" stringValue:personJid];
    [item addAttributeWithName:@"role" stringValue:@"none"];
    NSXMLElement *reason = [NSXMLElement elementWithName:@"reason"];
    [item addChild:reason];
    [query addChild:item];
    [iq addChild:query];
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:iq];
}

//搜索所有群
+ (void)searchAllGroups:(NSString *)searchText withStartNo:(NSInteger)startNo withEndNo:(NSInteger)endNo withRealmName:(NSString *)realmName
{
    NSString *elementID = kStringXMPPElementIDSearchAllGroups;
    XMPPJID *to = [XMPPJID jidWithString:[NSString stringWithFormat:@"conference.%@",realmName]];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:browse"];
    [query addAttributeWithName:@"endno" integerValue:endNo];
    [query addAttributeWithName:@"roomname" stringValue:searchText];
    [query addAttributeWithName:@"startno" integerValue:startNo];
    [iq addChild:query];
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:iq];
}

//申请进群/申请加群
+ (void)applyGetIntoTheGroupJid:(NSString *)groupJid withAdmin:(NSString *)admin withName:(NSString *)groupName
{
    NSXMLElement *message = [NSXMLElement elementWithName:kStringXMPPMessage];
    [message addAttributeWithName:kStringXMPPID stringValue:[self randomUUID]];
    [message addAttributeWithName:kStringXMPPTo stringValue:admin];
    [message addAttributeWithName:kStringXMPPIQType stringValue:@"reqjoin"];
    NSXMLElement *thread = [NSXMLElement elementWithName:@"thread" stringValue:[self randomUUID]];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:@""];
    NSXMLElement *rtf = [NSXMLElement elementWithName:@"rtf" stringValue:@""];
    NSXMLElement *apply = [NSXMLElement elementWithName:@"apply"];
    NSXMLElement *uid = [NSXMLElement elementWithName:@"uid" stringValue:groupJid];
    NSXMLElement *name = [NSXMLElement elementWithName:@"name" stringValue:groupName];
    [message addChild:thread];
    [message addChild:body];
    [message addChild:rtf];
    [apply addChild:uid];
    [apply addChild:name];
    [message addChild:apply];
    
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:message];
    
}

//拒绝加入群
+ (void)refuseAddGroupToPersonJid:(NSString *)personjid withGroupName:(NSString *)groupName
{
    NSXMLElement *message = [NSXMLElement elementWithName:kStringXMPPMessage];
    [message addAttributeWithName:kStringXMPPID stringValue:[self randomUUID]];
    [message addAttributeWithName:kStringXMPPTo stringValue:personjid];
    [message addAttributeWithName:kStringXMPPIQType stringValue:@"chat"];
    NSXMLElement *thread = [NSXMLElement elementWithName:@"thread" stringValue:[self randomUUID]];
    NSXMLElement *body = [NSXMLElement elementWithName:kStringXMPPBody stringValue:[NSString stringWithFormat:@"%@管理员拒绝您加入该群组！",groupName]];
    NSXMLElement *refuse = [NSXMLElement elementWithName:@"refuse"];
    [message addChild:thread];
    [message addChild:body];
    [message addChild:refuse];
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:message];
}

//同意加入群
+(void)agreeAddGroupJid:(NSString *)groupJid toPerson:(NSString *)person byPersonJid:(NSString *)byJid
{
    NSXMLElement *message = [NSXMLElement elementWithName:kStringXMPPMessage];
    [message addAttributeWithName:kStringXMPPTo stringValue:groupJid];
    NSXMLElement *x = [NSXMLElement elementWithName:kStringXMPPX xmlns:@"http://jabber.org/protocol/muc#user"];
    NSXMLElement *invite = [NSXMLElement elementWithName:@"invite"];
    [invite addAttributeWithName:kStringXMPPTo stringValue:person];
    NSXMLElement *reason = [NSXMLElement elementWithName:@"reason" stringValue:@"您好，请你阅读该群组记录。"];
    NSXMLElement *enforce = [NSXMLElement elementWithName:@"enforce" stringValue:@"1"];
    [invite addChild:reason];
    [invite addChild:enforce];
    [x addChild:invite];
    NSDictionary *dict = [DownloadOrganizationsController getPersonInformationByJid:byJid];
    NSXMLElement *roomCreater = [NSXMLElement elementWithName:@"RoomCreater" stringValue:dict[@"name"]];
    NSXMLElement *roomCreaterJID = [NSXMLElement elementWithName:@"RoomCreaterJID" stringValue:byJid];
    NSXMLElement *roomSubject = [NSXMLElement elementWithName:@"RoomSubject"];
    NSXMLElement *persisdent = [NSXMLElement elementWithName:@"Persisdent" stringValue:@"1"];
    [message addChild:x];
    [message addChild:roomCreater];
    [message addChild:roomCreaterJID];
    [message addChild:roomSubject];
    [message addChild:persisdent];
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:message];
    
    NSString *elementID = kStringXMPPElementIDDeleteGroup;
    XMPPJID *to = [XMPPJID jidWithString:groupJid];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#admin"];
    NSXMLElement *item = [NSXMLElement elementWithName:@"item"];
    [item addAttributeWithName:@"affiliation" stringValue:@"member"];
    [item addAttributeWithName:@"jid" stringValue:person];
    [query addChild:item];
    [iq addChild:query];
    [[XMPPManager shareXMPPManager].xmppStream  sendElement:iq];
}

#pragma mark - private
+ (NSString *)randomUUID
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    uuidString = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [uuidString lowercaseString];
}

@end
