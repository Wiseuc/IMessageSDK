//
//  LTXMPPManager+message.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager+message.h"
void runCategoryForFramework42(){}




@implementation LTXMPPManager (message)

-(void)sendRequestMessageCompleted:(LTXMPPManager_message_queryMessageBlock)message_queryMessageBlock {
    self.message_queryMessageBlock = message_queryMessageBlock;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    //dict
    NSDictionary *dict = [LT_MessageAnalysis analysisXMPPMessage:message];
    if (self.message_queryMessageBlock && dict != nil) {
        self.message_queryMessageBlock(dict);
    }
    
}






#pragma mark - public

/**
 文本消息：
 SEND:
 <message
 id="EFF5B5BD14524B75ABB0A8ED25828F9E"
 to="萧凡宇@duowin-server"
 from="江海@duowin-server/IphoneIM"
 type="chat"
 UID="4F9E3310D1B34BE190DCD36FA8A01B0A">
     <body>得得得</body>
 </message>
 **/
-(NSDictionary *)sendMessageWithSenderJID:(NSString *)aSenderJID
                                 otherJID:(NSString *)aOtherJID
                                     body:(NSString *)aBody
{
    
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [msg addChild:body];
    
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"from" stringValue: [aSenderJID stringByAppendingString:@"/IphoneIM"]];
    [msg addAttributeWithName:@"to"  stringValue:aOtherJID];
    [msg addAttributeWithName:@"type"  stringValue:@"chat"];
    [body setStringValue:aBody];
    [self.aXMPPStream sendElement:msg];
    
    //通过jid组织架构获取信息
    NSDictionary *dict02 = [LT_OrgManager queryInformationByJid:aOtherJID];
    return @{
             @"currentMyJID":aSenderJID,
             @"currentOtherJID":aOtherJID,
             @"conversationName":dict02[@"NAME"],
             @"stamp":[self getTimestamp],
             @"body":aBody,

             @"bodyType":@"bodyType_Text",
             @"from":[aSenderJID stringByAppendingString:@"/IphoneIM"],
             @"to":aOtherJID,
             @"type":@"chat",
             @"UID":[self get_32Bytes_UUID],
             };
}


/**
 群组消息：
 
 SEND:
 <message
 id="427C3A02801A44A79A4082FF091E1E33"
 to="fd3f752ffdfe4c5cbb26e818c6ca6f4c@conference.duowin-server"
 SenderJID="江海@duowin-server"
 type="groupchat"
 UID="4197AA42F8FF4536ABA34BFB31F13426">
     <body>得到</body>
 </message>
 **/
-(NSDictionary *)sendConferenceMessageWithSenderJID:(NSString *)aSenderJID
                                      conferenceJID:(NSString *)aConferenceJID
                                     conferenceName:(NSString *)aConferenceName
                                               body:(NSString *)aBody
{
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [msg addChild:body];
    
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"to"  stringValue:aConferenceJID];
    [msg addAttributeWithName:@"SenderJID"  stringValue:aSenderJID];
    [msg addAttributeWithName:@"type"  stringValue:@"groupchat"];
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [body setStringValue:aBody];
    [self.aXMPPStream sendElement:msg];
    
    //通过jid组织架构获取信息
    //NSDictionary *dict02 = [LT_OrgManager queryInformationByJid:aOtherJID];
    return @{
             @"currentMyJID":aSenderJID,
             @"currentOtherJID":aConferenceJID,
             @"conversationName":aConferenceName,
             @"stamp":[self getTimestamp],
             @"body":aBody,
             
             @"bodyType":@"bodyType_Text",
             @"from":[aSenderJID stringByAppendingString:@"/IphoneIM"],
             @"to":aConferenceJID,
             @"type":@"groupchat",
             @"UID":[self get_32Bytes_UUID],
             };
}












#pragma mark - Private

- (NSString *)get_32Bytes_UUID {
    return  [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

-(NSString *)getTimestamp {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

@end
