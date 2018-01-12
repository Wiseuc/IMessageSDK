//
//  LTXMPPManager+message.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager+message.h"
#import "LTHttpTool.h"

void runCategoryForFramework42(){}




@implementation LTXMPPManager (message)

-(void)sendRequestMessageCompleted:(LTXMPPManager_message_queryMessageBlock)message_queryMessageBlock {
    self.message_queryMessageBlock = message_queryMessageBlock;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    /*
     异地登录消息
     
     <message
     xmlns="jabber:client"
     from="duowin-server"
     to="test001@duowin-server/IphoneIM"
     notify="sessionreplace">
     <body>您的帐号在其他地方登入,您被迫下线,如果不是您自己的操作,请及时更改密码!</body>
     </message>
     */
    NSString *notify = [[message attributeForName:@"notify"] stringValue];
    if ( notify && [notify isEqualToString:@"sessionreplace"] ) {
        NSString *body = [message elementsForName:@"body"].firstObject.stringValue;
        if (self.message_queryMessageBlock) {
            LTError *error = [LTError errorWithDescription:body code:(LTErrorLogin_SessionReplace)];
            self.message_queryMessageBlock(nil, error);
        }
    }
    
    
    
    //信息dict
    NSDictionary *dict = [LT_MessageAnalysis analysisXMPPMessage:message];
    if (self.message_queryMessageBlock && dict != nil){
        self.message_queryMessageBlock(dict,nil);
    }
    
}






#pragma mark - public





/*!
 @method
 @abstract 发送Text信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（Text）
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendTextWithSenderJID:(NSString *)aSenderJID
                              otherJID:(NSString *)aOtherJID
                      conversationName:(NSString *)aConversationName
                      conversationType:(LTConversationType)aConversationType
                           messageType:(LTMessageType)aMessageType
                                  body:(NSString *)aBody {
    
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [msg addChild:body];
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"to"  stringValue:aOtherJID];
    
    if (aConversationType == LTConversationTypeChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"chat"];
        [msg addAttributeWithName:@"from" stringValue: [aSenderJID stringByAppendingString:@"/IphoneIM"]];
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"groupchat"];
        [msg addAttributeWithName:@"SenderJID"  stringValue:aSenderJID];
    }
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [body setStringValue:aBody];
    [self sendTextMessageXML:msg];
    
    
    
    NSString *conversationType = nil;
    if (aConversationType == LTConversationTypeChat)
    {
        conversationType = @"chat";
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        conversationType = @"groupchat";
    }
    return @{
             @"currentMyJID":aSenderJID,
             @"currentOtherJID":aOtherJID,
             @"stamp":[self getTimestamp],
             @"bodyType":@"text",
             @"body":aBody,
             
             
             //1
             @"UID":[self get_32Bytes_UUID],
             //2
             @"to":aOtherJID,
             //3
             @"conversationName":aConversationName,
             //4
             @"from":[aSenderJID stringByAppendingString:@"/IphoneIM"],
             @"type":conversationType,
             };
}






/*!
 @method
 @abstract 发送Vibrate信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（Vibrate）
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendVibrateWithSenderJID:(NSString *)aSenderJID
                                 otherJID:(NSString *)aOtherJID
                         conversationName:(NSString *)aConversationName
                         conversationType:(LTConversationType)aConversationType
                              messageType:(LTMessageType)aMessageType
                                     body:(NSString *)aBody {
    
    
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [msg addChild:body];
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"to"  stringValue:aOtherJID];
    
    if (aConversationType == LTConversationTypeChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"chat"];
        [msg addAttributeWithName:@"from" stringValue: [aSenderJID stringByAppendingString:@"/IphoneIM"]];
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"groupchat"];
        [msg addAttributeWithName:@"SenderJID"  stringValue:aSenderJID];
    }
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [body setStringValue:aBody];
    [self sendTextMessageXML:msg];
    
    
    
    NSString *conversationType = nil;
    if (aConversationType == LTConversationTypeChat)
    {
        conversationType = @"chat";
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        conversationType = @"groupchat";
    }
    return @{
             @"currentMyJID":aSenderJID,
             @"currentOtherJID":aOtherJID,
             @"stamp":[self getTimestamp],
             @"bodyType":@"vibrate",
             @"body":aBody,
             
             
             //1
             @"UID":[self get_32Bytes_UUID],
             //2
             @"to":aOtherJID,
             //3
             @"conversationName":aConversationName,
             //4
             @"from":[aSenderJID stringByAppendingString:@"/IphoneIM"],
             @"type":conversationType,
             };
    
    
    
}




/*!
 @method
 @abstract 发送Voice信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID:江海@duowin-server
 @param aOtherJID 接收者JID:萧凡宇@duowin-server
 @param aConversationType 会话类型:LTConversationTypeChat
 @param aMessageType 信息类型（voice）:LTMessageType_Voice
 @param aLocalPath 本地地址：/var/mobile/Containers/Data/Application/988725BA-E624-40A3-AAB5-05A34AB8C7CD/Documents/wiseuc/Voice/151539279008308.mp3
 @param aRemotePath 远程地址：http://im.lituosoft.cn:14131/upvoice.php
 @param aDuration voice时长
 @param aBody 信息：151539279008308.mp3
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendVoiceWithSenderJID:(NSString *)aSenderJID
                              otherJID:(NSString *)aOtherJID
                      conversationName:(NSString *)aConversationName
                      conversationType:(LTConversationType)aConversationType
                            messageType:(LTMessageType)aMessageType
                              localPath:(NSString *)aLocalPath
                             remotePath:(NSString *)aRemotePath
                               duration:(NSString *)aDuration
                                  body:(NSString *)aBody {
    
    
    
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *voice = [NSXMLElement elementWithName:@"voice"];
    NSXMLElement *duration = [NSXMLElement elementWithName:@"duration"];
    
    [msg addChild:body];
    [msg addChild:voice];
    [msg addChild:duration];
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"to"  stringValue:aOtherJID];
    
    if (aConversationType == LTConversationTypeChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"chat"];
        [msg addAttributeWithName:@"from" stringValue: [aSenderJID stringByAppendingString:@"/IphoneIM"]];
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"groupchat"];
        [msg addAttributeWithName:@"SenderJID"  stringValue:aSenderJID];
    }
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [body setStringValue:aBody];
    [voice setStringValue:aBody];
    [duration setStringValue:aDuration];
    [self sendVoiceMessageXML:msg
                    localPath:aLocalPath
                   remotePath:aRemotePath];
    
    
    
    
    NSString *conversationType = nil;
    if (aConversationType == LTConversationTypeChat)
    {
        conversationType = @"chat";
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        conversationType = @"groupchat";
    }
    return @{
             @"currentMyJID":aSenderJID,
             @"currentOtherJID":aOtherJID,
             @"stamp":[self getTimestamp],
             @"bodyType":@"voice",
             @"body":aBody,
             
             //1
             @"UID":[self get_32Bytes_UUID],
             //2
             @"to":aOtherJID,
             //3
             @"conversationName":aConversationName,
             //4
             @"from":[aSenderJID stringByAppendingString:@"/IphoneIM"],
             @"type":conversationType,
             
             //voice
             @"duration":aDuration,
             @"localPath":aLocalPath,
             @"remotePath":aRemotePath,
             
             };
}

/*!
 @method
 @abstract 发送image信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（voice）
 @param aBody 信息
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendImageWithSenderJID:(NSString *)aSenderJID
                               otherJID:(NSString *)aOtherJID
                       conversationName:(NSString *)aConversationName
                       conversationType:(LTConversationType)aConversationType
                            messageType:(LTMessageType)aMessageType
                              localPath:(NSString *)aLocalPath
                             remotePath:(NSString *)aRemotePath
                                   body:(NSString *)aBody {
    
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *picture = [NSXMLElement elementWithName:@"picture"];

    [msg addChild:body];
    [msg addChild:picture];
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"to"  stringValue:aOtherJID];

    if (aConversationType == LTConversationTypeChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"chat"];
        [msg addAttributeWithName:@"from" stringValue: [aSenderJID stringByAppendingString:@"/IphoneIM"]];
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"groupchat"];
        [msg addAttributeWithName:@"SenderJID"  stringValue:aSenderJID];
    }
    //[msg addAttributeWithName:@"successed"  stringValue:@"success"];
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [body setStringValue:[NSString stringWithFormat:@"<i@%@>",aBody]];
    [picture setStringValue:[NSString stringWithFormat:@"<i@%@>",aBody]];
    [self sendImageMessageXML:msg
                    localPath:aLocalPath
                   remotePath:aRemotePath];



    NSString *conversationType = nil;
    if (aConversationType == LTConversationTypeChat)
    {
        conversationType = @"chat";
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        conversationType = @"groupchat";
    }
    return @{
             @"currentMyJID":aSenderJID,
             @"currentOtherJID":aOtherJID,
             @"stamp":[self getTimestamp],
             @"bodyType":@"image",
             @"body":aBody,

             //1
             @"UID":[self get_32Bytes_UUID],
             //2
             @"to":aOtherJID,
             //3
             @"conversationName":aConversationName,
             //4
             @"from":[aSenderJID stringByAppendingString:@"/IphoneIM"],
             @"type":conversationType,

             //image
             @"localPath":aLocalPath,
             @"remotePath":aRemotePath,

             };
}

/*!
 @method
 @abstract 发送file信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（file）
 @param aBody file信息名字：例如45485454456456456.rar
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendFileWithSenderJID:(NSString *)aSenderJID
                              otherJID:(NSString *)aOtherJID
                      conversationName:(NSString *)aConversationName
                      conversationType:(LTConversationType)aConversationType
                           messageType:(LTMessageType)aMessageType
                             localPath:(NSString *)aLocalPath
                            remotePath:(NSString *)aRemotePath
                                  size:(NSString *)aSize
                                  body:(NSString *)aBody {
    
    NSXMLElement *msg = [NSXMLElement elementWithName:@"message"];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *wiseucoffline = [NSXMLElement elementWithName:@"wiseucoffline"];
    NSXMLElement *offlinedir = [NSXMLElement elementWithName:@"offlinedir"];
    NSXMLElement *offlinefilename = [NSXMLElement elementWithName:@"offlinefilename"];
    NSXMLElement *offlinefilesize = [NSXMLElement elementWithName:@"offlinefilesize"];
    NSXMLElement *offlinefullurl = [NSXMLElement elementWithName:@"offlinefullurl"];
    
    
    
    [body setStringValue:aBody];
    //[wiseucoffline setStringValue:aBody];
    [offlinedir setStringValue:aRemotePath];
    [offlinefilename setStringValue:aBody];
    [offlinefilesize setStringValue:aSize];
    [offlinefullurl setStringValue:aRemotePath];
    
    
    
    
    [msg addChild:body];
//    [msg addChild:wiseucoffline];
    [msg addChild:offlinedir];
    [msg addChild:offlinefilename];
    [msg addChild:offlinefilesize];
    
    
    
//    [wiseucoffline addAttributeWithName:@"type" stringValue:@"http"];
//    [wiseucoffline addChild:offlinedir];
//    [wiseucoffline addChild:offlinefilename];
//    [wiseucoffline addChild:offlinefilesize];
//    [wiseucoffline addChild:offlinefullurl];
    
    
    
    
    [msg addAttributeWithName:@"id"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    [msg addAttributeWithName:@"to"  stringValue:aOtherJID];
    
    if (aConversationType == LTConversationTypeChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"chat"];
        [msg addAttributeWithName:@"from" stringValue: [aSenderJID stringByAppendingString:@"/IphoneIM"]];
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        [msg addAttributeWithName:@"type"  stringValue:@"groupchat"];
        [msg addAttributeWithName:@"SenderJID"  stringValue:aSenderJID];
    }
    [msg addAttributeWithName:@"successed"  stringValue:@"success"];
    [msg addAttributeWithName:@"UID"  stringValue:[LTXMPPManager.share get_32Bytes_UUID]];
    
    
    [self sendImageMessageXML:msg
                    localPath:aLocalPath
                   remotePath:aRemotePath];
    
    
    
    NSString *conversationType = nil;
    if (aConversationType == LTConversationTypeChat)
    {
        conversationType = @"chat";
    }
    else if (aConversationType == LTConversationTypeGroupChat)
    {
        conversationType = @"groupchat";
    }
    
    NSString *aResource = @"iphone";
    if ([aSenderJID.lowercaseString containsString:@"android"])
    {
        aResource = @"android";
    }
    else if ([aSenderJID.lowercaseString containsString:@"window"])
    {
         aResource = @"window";
    }
    
    
    
    return @{
             @"currentMyJID":aSenderJID,
             @"currentOtherJID":aOtherJID,
             @"stamp":[self getTimestamp],
             @"bodyType":@"file",
             @"body":aBody,
             
             //1
             @"UID":[self get_32Bytes_UUID],
             //2
             @"to":aOtherJID,
             //3
             @"conversationName":aConversationName,
             //4
             @"from":[aSenderJID stringByAppendingString:@"/IphoneIM"],
             @"type":conversationType,
             
             //image
             @"localPath":aLocalPath,
             @"remotePath":aRemotePath,
             @"size":aSize,
             @"resource":aResource,
             };
}




























#pragma mark - 执行发送信息

-(void)sendTextMessageXML:(NSXMLElement * )xml {
    [self.aXMPPStream sendElement:xml];
}
-(void)sendVoiceMessageXML:(NSXMLElement * )xml
                 localPath:(NSString *)aLocalPath
                remotePath:(NSString *)aRemotePath {
    
    HttpTool * tool = [[HttpTool alloc] init];
    [tool FORM_UploadFile:aLocalPath
          targetServerURL:aRemotePath
        requireEncryption:NO
            progressBlock:nil
               completion:^(id data, NSError *error) {
                   [self.aXMPPStream sendElement:xml];
               }];
}
-(void)sendImageMessageXML:(NSXMLElement * )xml
                 localPath:(NSString *)aLocalPath
                remotePath:(NSString *)aRemotePath {
    
    HttpTool * tool = [[HttpTool alloc] init];
    [tool FORM_UploadFile:aLocalPath
          targetServerURL:aRemotePath
        requireEncryption:YES
            progressBlock:nil
               completion:^(id data, NSError *error) {
                   
                   [self.aXMPPStream sendElement:xml];
               }];
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
