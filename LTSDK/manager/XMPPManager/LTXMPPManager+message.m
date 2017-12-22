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
 
 <message
 xmlns="jabber:client"
 UID="b20b1a2a994b4cfb9447da57edec33db"
 id="ObASN-12"
 to="江海@duowin-server/IphoneIM"
 from="萧凡宇@duowin-server/AndroidIM"
 type="chat">
 
 <body>啊啊啊啊</body>
 <thread>2284edcd-dd18-489c-992f-54f2daf328e9</thread>
 </message>
 
 <message 794AAA4AF2B94F5CA54CAB4D19736C68="id" 51DD674A6D044A6E855F7E16B5FBE945="UID" 江海@duowin-server/IphoneIM="from" 萧凡宇@duowin-server="to" chat="type"><body>拉萨菩萨</body></message>
 **/
-(NSDictionary *)sendMessageWithMyJID:(NSString *)aMyJID
                             otherJID:(NSString *)aOtherJID
                                 body:(NSString *)aBody
                             chatType:(NSString *)aChatType {
    
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [msg addChild:body];
    
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"from" stringValue: [aMyJID stringByAppendingString:@"/IphoneIM"]];
    [msg addAttributeWithName:@"to"  stringValue:aOtherJID];
    [msg addAttributeWithName:@"type"  stringValue:aChatType];
    
    [body setStringValue:aBody];
    [self.aXMPPStream sendElement:msg];
    
    //通过jid组织架构获取信息
    NSDictionary *dict02 = [LT_OrgManager queryInformationByJid:aOtherJID];
    return @{
             @"currentMyJID":aMyJID,
             @"currentOtherJID":aOtherJID,
             @"conversationName":dict02[@"NAME"],
             @"stamp":[self getTimestamp],
             @"body":aBody,
             
             @"bodyType":@"bodyType_Text",
             @"from":[aMyJID stringByAppendingString:@"/IphoneIM"],
             @"to":aOtherJID,
             @"type":aChatType,
             @"UID":[self get_32Bytes_UUID],
             };
}


/**
 群组消息：
 
 <message
 xmlns="jabber:client"
 SenderJID="萧凡宇@duowin-server/AndroidIM"
 UID="8282f8ad82bb4254864e082ae5d489f1"
 id="ObASN-19"
 to="江海@duowin-server/IphoneIM"
 type="groupchat"
 from="fd3f752ffdfe4c5cbb26e818c6ca6f4c@conference.duowin-server/萧凡宇"
 name="萧凡宇,江海">
 
 <body>摸摸弄</body>
 <x xmlns="jabber:x:delay" from="fd3f752ffdfe4c5cbb26e818c6ca6f4c@conference.duowin-server" stamp="20171220T11:53:20"></x>
 </message>
 **/













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
