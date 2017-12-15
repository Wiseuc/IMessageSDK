//
//  XMPPManager.m
//  XMPP即时通讯
//
//  Created by 吴林峰 on 15/5/15.
//  Copyright (c) 2015年 ___LinFeng___. All rights reserved.
//

#import "XMPPManager.h"
//#import "Macros.h"
//#import "NSObject+Additions.h"
//#import "XMLReader.h"
//#import "pinyin.h"
//#import "POAPinyin.h"
//#import "NSMutableString+ReplacingOccurencesOfString.h"
//#import "MessageXMLManager.h"
//#import "List.h"
//#import "HttpTool.h"
//#import "XMPPManager+Presence.h"
//#import "XMPPManager+IQ.h"
//#import "DownloadOrganizationsController.h"
#import "XMPPStream+secure.h"
#import "AppManager.h"
#import "Encrypt_Decipher.h"
//#import "UserManager.h"
//#import "AppDelegate+Background.h"
//#import "LoginManager.h"
//#import "RoamingMsgManager.h"
//#import "SVProgressHUD+Custom.h"

@interface XMPPManager () <XMPPStreamDelegate>
{
    XMPPRoster *xmppRoster;
    XMPPReconnect *xmppReconnet;
    XMPPAutoPing *_xmppAutoPing;
//    CompleteBlock _completeBlock;
//    BOOL _isRegister;
    BOOL _enableLDAP;   // 是否需要LDAP校验
    NSString *_ip;
    NSString *_port;
    NSString *_username;
    NSString *_password;
}
//本地时间超前服务器时间的时间（毫秒）
@property (nonatomic, assign) long long timeOffset_localLeadToServer;
@end





@implementation XMPPManager


#pragma mark -- XMPPMessage 消息发送
////发送风格消息成功
//- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
//    NSString *msgUID = [[message attributeForName:@"UID"] stringValue];
//    [self didSendMessage:msgUID success:YES];
//}
////发送消息失败
//- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
//    NSString *msgUID = [[message attributeForName:@"UID"] stringValue];
//    [self didSendMessage:msgUID success:NO];
//}
//
//- (void)didSendMessage:(NSString *)messageId success:(BOOL)success
//{
//    if ( messageId == nil ) {
//        return;
//    }
//
//    MessageDeliveryState msgDeliveryState = success ? eMessageDeliveryState_Delivered : eMessageDeliveryState_Failure;
//    Message *msg = [Message findMessageWithMessageId:messageId];
//    if ( msg == nil )
//    {
//        return;
//    }
//    msg.deliveryState = msgDeliveryState;
//    [msg update];
//
//    // 已优化 // isSendRead == 1,对方已阅，肯定是发送成功了,这时已发送成功消息不刷新对应消息, 收到对方已阅的时候，这个发送状态直接置为已发送，并且已经刷新过界面一次了
//    if ( msg.isSendRead == YES ) {
//        return;
//    }
//    if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didSendMessage:)] ) {
//        [_msgReceiverdelegate XMPPServer:self didSendMessage:msg];
//    }
//}
//






#pragma mark ===代理：XMPPMessage
//
///**
// 接收到新消息
//
// @param sender <#sender description#>
// @param message <#message description#>
// */
//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
//
//    if (AppDelegateInstance.isEnterBackground && message.body != nil && ![message.body isEqualToString:@""]) {
//        if ([UserManager shareInstance].isNotificationShowMessageDetail) {
//            [AppDelegateInstance localNotification:[NSString stringWithFormat:@"%@: %@",message.from.user,message.body]];
//        }else {
//            [AppDelegateInstance localNotification:@"您收到了一条新消息"];
//        }
//    }
//
//
//    //如果消息是已阅未阅消息 “type：ack”
//    if ([[message attributeForName:@"type"].stringValue isEqualToString:@"ack"]) {
//        NSString *messageId = [message attributeForName:@"mid"].stringValue;
//        Message *dbMessage = [Message findMessageWithMessageId:messageId];// 消息即焚收到已阅自动删除
//
//        if ( dbMessage.isBurn == YES )
//        {
//            NSString *jid = [UserManager shareInstance].currentUser.jid;
//            NSString *password = [UserManager shareInstance].currentUser.password;
//            [[RoamingMsgManager new] deleteMessageWithWithJID:jid password:password messageId:dbMessage.messageId completeHandler:^(BOOL success, id response) {
//                NSLog(@"%@",response);
//            }];
//            [dbMessage remove];
//        }else{
//            // 非阅读即焚置为 对方“已读”
//            if ( dbMessage.isSendRead == NO ) {
//                // 对方已阅，肯定是发送成功了
//                dbMessage.deliveryState = eMessageDeliveryState_Delivered;
//                dbMessage.isSendRead = YES;
//            }
//            [dbMessage update];
//        }
//
//        if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveHasReadJid:messageId:)] ) {
//            NSString *jid = [[[message attributeForName:@"from"].stringValue componentsSeparatedByString:@"/"] firstObject];
//            [_msgReceiverdelegate XMPPServer:self didReceiveHasReadJid:jid messageId:messageId];
//        }
//        return;
//    }
//
//
//    //新消息不是已阅未阅消息
//    NSArray *xArr = [message elementsForName:kStringXMPPX];
//    if ( xArr.count > 0 ) {
//        NSXMLElement *x = xArr[0];
//        if ( [x elementsForName:@"composing"].count > 0 ) {
//            NSString *xmlns = [x xmlns];
//            if ([xmlns isEqualToString:@"jabber:x:event"]) {
//                NSString *from = [[message attributeForName:kStringXMPPFrom] stringValue];
//                NSString *fromJid = [[from componentsSeparatedByString:@"/"] firstObject];
//                if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveInputingJid:)] ) {
//                    [_msgReceiverdelegate XMPPServer:self didReceiveInputingJid:fromJid];
//                }
//            }
//        }
//    }
//
//
//
//    /**如果是信息**/
//    /**chat_0002:解决由服务器地址映射导致的群文件发送失败问题**/
//    Message *msg = [MessageXMLManager formatXMLMessage:message];
//    if ( msg ) {
//
//
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_NewMessage object:msg];
//
//        if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceive:)] ) {
//            [_msgReceiverdelegate XMPPServer:self didReceive:msg];
//        }
//    }
//    /**如果不是信息**/
//    else
//    {
//        XMMessage *successMsg = [MessageXMLManager checkSuccessAndNotifationToChatController:message];
//
//#warning 这样写有隐患
//        NSString *sql = [NSString stringWithFormat:@" WHERE localPath = '%@' ", successMsg.localPath];
//        Message *_successMsg = [Message findFirstByCriteria:sql];
//        if ( successMsg && (_successMsg.bodyType == eMessageBodyType_Image || _successMsg.bodyType == eMessageBodyType_Voice) ) {
//            if ( _successMsg && _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveSuccessMessage:)] ) {
//                [_msgReceiverdelegate XMPPServer:self didReceiveSuccessMessage:_successMsg];
//            }
//        }
//
//        if (successMsg && !_successMsg) {
//            Message *textImageMsg = [[Message alloc] init];
//
//            NSString *from = [[message attributeForName:kStringXMPPFrom] stringValue];
//            from = [[from componentsSeparatedByString:@"/"] objectAtIndex:0];
//            NSString *to = [[message attributeForName:kStringXMPPTo] stringValue];
//            to = [[to componentsSeparatedByString:@"/"] objectAtIndex:0];
//
//            BOOL isFromSelf = [from isEqualToString:[UserManager shareInstance].currentUser.jid];
//
//            // 会话对象
//            textImageMsg.conversationChatter = isFromSelf ? to : from;
//            textImageMsg.bodyType = eMessageBodyType_Image;
//            textImageMsg.localPath = successMsg.localPath;
//
//            if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveSuccessMessage:)] ) {
//                [_msgReceiverdelegate XMPPServer:self didReceiveSuccessMessage:textImageMsg];
//            }
//        }
//    }//end else
//
//
//}
////接收消息失败
//- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
//{
//    NSLog(@"%@",error);
//}
//
//
//
//
//
//
//- (NSMutableDictionary *)copiedMutableDictionaryFrom:(NSDictionary *)source
//{
//    NSMutableDictionary *target = [[NSMutableDictionary alloc] initWithCapacity:10];
//    for(NSString *key in [source allKeys])
//    {
//        [target setObject:[self valueForKey:key inDictionary:source] forKey:key];
//    }
//    return target;
//}
//
//- (NSMutableDictionary *)copiedSomeone:(NSDictionary *)from
//{
//    //先存下来组别信息
//    NSString *group = [self valueForKey: @"group" inDictionary:from];
//
//    //复制一份在线状态，并去掉原有的组别信息字典
//    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:from copyItems:YES];
//
//    NSString *fullName = [NSObject objectForKey:@"name" inDictionary:from];
//    if([NSObject isEmpty:fullName]) //如果名字为空，那么从组织架构里取，如果组织架构里没有，再截jabberId的@之前的部分，即为名字
//    {
//        if(_delegate!=nil && [_delegate respondsToSelector:@selector(XMPPServer:valueFromCachesByProperty:jabberId:withRequestId:)])
//        {
//            fullName = [_delegate XMPPServer:self
//                    valueFromCachesByProperty:@"name"
//                                     jabberId:[NSObject objectForKey:@"jid" inDictionary:from]
//                                withRequestId: @"rosters"];
//        }
//    }
//    [item setObject:fullName forKey:@"FN" ];
//    [item setObject:[self transferToPinYin:fullName] forKey:@"pinYin"];
//    [item removeObjectForKey:kXMLReaderTextNodeKey];
//    //再把级别字符串添加进去
//    [item setObject:group forKey:@"group"];
//    return item;
//}
//- (NSString *)transferToPinYin:(NSString *)name
//{
//    NSMutableString *_pinYin = [NSMutableString stringWithCapacity:1];
//
//    for(int j=0; j<name.length; j++)
//    {
//        int character = [name characterAtIndex:j];
//        if(character==32)
//            continue;
//
//        if(character>=65 && character<=128)
//        {
//            if(j>0) //取首字母
//            {
//                int lastCharacter = [name characterAtIndex:j-1];
//                if(lastCharacter==32)
//                    [_pinYin appendString:[[name substringWithRange:NSMakeRange(j, 1)] uppercaseString]];
//            }
//            else
//                [_pinYin appendString:[[NSString stringWithFormat:@"%c", character] uppercaseString]];
//        }
//        else
//        {
//            [_pinYin appendString:[[NSString stringWithFormat:@"%c", pinyinFirstLetter(character)] uppercaseString]];
//        }
//    }
//    return _pinYin;
//}
//
//- (NSString *)valueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary
//{
//    id value = [NSObject objectForKey:key inDictionary:dictionary];
//    if([value isKindOfClass:[NSDictionary class]])
//    {
//        NSDictionary *dValue = [NSObject objectForKey:key inDictionary:dictionary];
//        value = [NSObject objectForKey:kXMLReaderTextNodeKey inDictionary:dValue];
//    }
//    else if(![value isKindOfClass:[NSString class]])
//    {
//        value = [value description];
//    }
//    return value;
//}
//
////获取个人消息
//- (void)getPersonJid:(NSString *)personJid
//{
//    NSString *elementID = @"rstrone";
//    XMPPJID *to = [XMPPJID jidWithString:personJid];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
//    NSXMLElement *query = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
//    [query addAttributeWithName:kStringXMPPVersion stringValue:@"0"];
//    [iq addChild:query];
//    [_xmppStream sendElement:iq];
//}
//
////获取个人消息
//- (void)getGroupMemberJid:(NSString *)groupMemberJid
//{
//    NSString *elementID = kStringXMPPElementIDMembers;
//    XMPPJID *to = [XMPPJID jidWithString:groupMemberJid];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
//    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#user"];
//
//    NSXMLElement *member = [NSXMLElement elementWithName:kStringXMPPIQItem];
//    [member addAttributeWithName:kStringXMPPIQItemAffiliation
//                     stringValue:kStringXMPPIQItemAffiliationMember];
//    [query addChild:member];
//
//    NSXMLElement *administrator = [NSXMLElement elementWithName:kStringXMPPIQItem];
//    [administrator addAttributeWithName:kStringXMPPIQItemAffiliation stringValue:kStringXMPPIQItemAffiliationAdministrator];
//    [query addChild:administrator];
//
//    NSXMLElement *owner = [NSXMLElement elementWithName:kStringXMPPIQItem];
//    [owner addAttributeWithName:kStringXMPPIQItemAffiliation stringValue:kStringXMPPIQItemAffiliationOwner];
//    [query addChild:owner];
//
//    [iq addChild:query];
//    [_xmppStream sendElement:iq];
//}
//
//












//
////上传头像
//- (void)uploadHeadImageByJid:(NSString *)myJid withPhotoHash:(NSString *)photoHash
//{
//    NSRange rangeName = [photoHash rangeOfString:@".jpg"];
//    NSString *rangePhotoHash = [photoHash substringToIndex:rangeName.location];
//    XMPPJID *to = [XMPPJID jidWithString:myJid];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:to elementID:kStringXMPPElementIDGetPhotoHash];
//    NSXMLElement *vCard = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
//    //[vCard addAttributeWithName:@"ver" intValue:0];
//    NSXMLElement *PHOTOHASH = [NSXMLElement elementWithName:@"PHOTOHASH" stringValue:rangePhotoHash];
//
//    [vCard addChild:PHOTOHASH];
//    NSXMLElement *PHOTO = [NSXMLElement elementWithName:@"PHOTO"];
//    NSXMLElement *TYPE = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
//    NSXMLElement *BINVAL = [NSXMLElement elementWithName:@"BINVAL"];
//    [PHOTO addChild:TYPE];
//    [PHOTO addChild:BINVAL];
//    [vCard addChild:PHOTO];
//    [iq addChild:vCard];
//
//    [[XMPPManager shareXMPPManager].xmppStream sendElement:iq];
//}
//
//
//
//#pragma mark - 发送消息
//- (Message *)asyncSendMessage:(Message *)message progress:(id)progress {
//    NSLog(@"发送消息: %s",__func__);
//    return [MessageXMLManager sendMessage:message progress:progress];
//}
//- (void)setUserFriends:(NSArray *)items {
//    [UserManager shareInstance].currentUser.friends = items;
//}
//
//
//
//
//
//





@end
