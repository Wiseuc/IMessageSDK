//
//  XMPPManager+Presence.m
//  WiseUC
//
//  Created by 吴林峰 on 15/11/20.
//  Copyright © 2015年 WiseUC. All rights reserved.
//

#import "XMPPManager+Presence.h"
#import "GDataXMLNode.h"
#import "NSObject+Additions.h"
#import "XMLReader.h"
#import "List.h"

@implementation XMPPManager (Presence)

#pragma  mark - 获取订阅信息
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSString *fromAttribute = [[presence attributeForName:kStringXMPPFrom] stringValue];
    
    //创建群组确认消息
    NSArray *xArr = [presence elementsForName:kStringXMPPX];
    if (xArr.count == 2) {
        if ([[xArr[0] xmlns] isEqualToString:@"http://jabber.org/protocol/muc"] && [[xArr[1] xmlns] isEqualToString:kStringXMPPXmlnsGroupMembers]) {
            NSArray *status = [xArr[1] elementsForName:@"status"];
            if (status.count > 0) {
                if (self.msgReceiverdelegate && [self.msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveCreateGroupPresence:from:)]) {
                    [self.msgReceiverdelegate XMPPServer:self didReceiveCreateGroupPresence:[status[0] attributeForName:@"code"].stringValue from:[presence attributeForName:@"from"].stringValue];
                }
            }
        }
    }
    
    
    void(^presenceSetBlock)(NSDictionary *presenceDict) = ^(NSDictionary *presenceDict) {
        if ( presenceDict ) {
            PresenceType presenceType = (PresenceType)[presenceDict[kStatu] integerValue];
            [XMPPManager jid:presenceDict[kJID] changePresenceStatuTo:presenceType];
        }
    };
    
    // 单人状态
    BOOL isNeedRefreshPresence = NO;
    if ( fromAttribute ) {
        NSDictionary *dict = [self praseElementForStatu:presence];
        if ( dict ) {
            isNeedRefreshPresence = YES;
            presenceSetBlock(dict);
        }
    }
    else {
        NSArray *listArr = [presence elementsForName:@"list"];
        if ( listArr ) {
            NSXMLElement *listElement = listArr[0];
            NSArray *items = [listElement elementsForName:@"item"];
            if ( items.count > 0 ) {
                isNeedRefreshPresence = YES;
                for (NSXMLElement *item in items) {
                    NSDictionary *dict = [self praseElementForStatu:item];
                    presenceSetBlock(dict);
                }
            }
        }
    }
    
    
    if ( isNeedRefreshPresence ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_PresenceChange object:nil];
    }
    
    NSError *error = nil;
    NSDictionary *result = [XMLReader dictionaryForXMLString:[presence XMLString] error:&error];
    
    NSDictionary *info = [NSObject objectForKey:kStringXMPPPresence inDictionary:result espectedType:[NSDictionary class]];
    
    NSString *presenceType = [NSObject objectForKey:kStringXMPPPresenceType inDictionary:info];
    if ( [presenceType isEqualToString:kStringXMPPPresenceTypeState] ) {
        return;
    }
    
    if ([kStringXMPPPresenceTypeSubscribe isEqualToString:presenceType]) {
        
         NSString *from = [[presence from] full];
        [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_DealwithFriendRequest object:from];
    }else if ([kStringXMPPPresenceTypeUnsubscribed isEqualToString:presenceType])
    {
        NSString *from = [[presence from] full];
        [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_RefuseAddYouToBeFriend object:from];
    }else if ([kStringXMPPPresenceUnavailable isEqualToString:presenceType])
    {
       //接收到销毁群消息后删除聊天面板的数据
        NSArray *xArr = [presence elementsForName:kStringXMPPX];
        if ( xArr.count > 0 ) {
            NSXMLElement *x = xArr[0];
            if ( [x elementsForName:@"destroy"].count > 0 ) {
                NSString *from = [NSObject objectForKey:@"from" inDictionary:info];
                [List removeConversationWithchatterJID:from];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_DeleteFromGroupOrRoomRefresh object:nil];
                return;
            }
        }
    }
    
}

#pragma mark - public
+ (NSString *)presenceTypeDescription:(PresenceType)presenceType
{
    NSString *presenceTypeDescription = nil;
    switch ( presenceType ) {
        case PresenceType_Offline:
            presenceTypeDescription = PresenceType_OfflineDescription;
            break;
        case PresenceType_Online:
            presenceTypeDescription = PresenceType_OnlineDescription;
            break;
        case PresenceType_Busy:
            presenceTypeDescription = PresenceType_BusyDescription;
            break;
            
        default:
            break;
    }
    return presenceTypeDescription;
}

+ (NSString *)presenceTypeImageName:(PresenceType)presenceType
{
    NSString *presenceTypeImageName = @"offline";
    switch ( presenceType ) {
        case PresenceType_Offline:
            presenceTypeImageName = @"offline";
            break;
        case PresenceType_Online:
            presenceTypeImageName = @"online";
            break;
        case PresenceType_Busy:
            presenceTypeImageName = @"busy";
            break;
            
        default:
            break;
    }
    return presenceTypeImageName;
}

+ (PresenceType)presenceStatuForJID:(NSString *)chatterJID
{
    NSArray *jidPlaformArray = @[[NSString stringWithFormat:@"%@/%@",chatterJID,kPlatform_WinduoIM],
                              [NSString stringWithFormat:@"%@/%@",chatterJID,kPlatform_AndroidIM],
                              [NSString stringWithFormat:@"%@/%@",chatterJID,kPlatform_IphoneIM]];
    NSDictionary *rosterPresenceDict = [NSDictionary dictionaryWithDictionary:[XMPPManager shareXMPPManager].rosterPresence];
    for (NSInteger i = 0; i < jidPlaformArray.count; i++) {
        NSNumber *statu = [[rosterPresenceDict objectForKey:jidPlaformArray[i]] objectForKey:kStatu];
        PresenceType presenceType = (PresenceType)[statu integerValue];
        if ( presenceType != PresenceType_Offline ) {
            return presenceType;
        }
    }
    return PresenceType_Offline;
}

+ (PresenceType)presenceStatuForIPhonePlatform_JID:(NSString *)IPhonePlatform_JID
{
    if ( IPhonePlatform_JID == nil ) {
        return PresenceType_Online;
    }
    
    NSString *jid = [NSString stringWithFormat:@"%@/%@",IPhonePlatform_JID,kPlatform_IphoneIM];
    NSDictionary *rosterPresenceDict = [NSDictionary dictionaryWithDictionary:[XMPPManager shareXMPPManager].rosterPresence];
    if ( [[rosterPresenceDict allKeys] containsObject:jid] ) {
        NSNumber *statu = [[rosterPresenceDict objectForKey:jid] objectForKey:kStatu];
        return (PresenceType)[statu integerValue];
    }
    return PresenceType_Offline;
}

#pragma mark - private
// 解析presence
- (NSDictionary *)praseElementForStatu:(NSXMLElement *)element
{
    NSString *fromAttribute = [[element attributeForName:kStringXMPPFrom] stringValue];
    NSString *type = [[element attributeForName:kStringXMPPPresenceType] stringValue];
    if ( [type isEqualToString:kStringXMPPPresenceUnavailable] ) {
        return @{kJID:fromAttribute,
                 kStatu:@(PresenceType_Offline)};
    }
    
    NSArray *showElementArr = [element elementsForName:kStringXMPPPresenceShow];
    if ( showElementArr.count > 0 ) {
        NSString *show = [showElementArr[0] stringValue];
        if ( [show isEqualToString:kStringXMPPPresenceShowAway] ) {
            return @{kJID:fromAttribute,
                     kStatu:@(PresenceType_Busy)};
        }
    }
    
    NSArray *statusElementArr = [element elementsForName:kStringXMPPPresenceStatus];
    if ( statusElementArr.count > 0 ) {
        NSString *statu = [statusElementArr[0] stringValue];
        if ( [statu isEqualToString:PresenceType_OnlineDescription] ) {
            return @{kJID:fromAttribute,
                     kStatu:@(PresenceType_Online)};
        }
        else if ( [statu isEqualToString:PresenceType_OfflineDescription] ) {
            return @{kJID:fromAttribute,
                     kStatu:@(PresenceType_Offline)};
        }
    }
    return nil;
}

+ (void)jid:(NSString *)jid changePresenceStatuTo:(PresenceType)presence {
    if ( jid == nil ) { return; }
    
    NSDictionary *dict = @{kJID:jid,
                           kStatu:@(presence)};
    [[XMPPManager shareXMPPManager].rosterPresence setObject:dict forKey:jid];
}

+ (void)sendPresenceToRoomID:(NSString *)roomID domain:(NSString *)domain resource:(NSString *)resource
{
    XMPPJID *jid = [XMPPJID jidWithUser:roomID domain:domain resource:resource];
    XMPPPresence *presence = [XMPPPresence presenceWithType:nil to:jid];
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc"];
    NSXMLElement *show = [NSXMLElement elementWithName:@"show"];
    
    [presence addChild:x];
    [presence addChild:show];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:presence];
}

@end
