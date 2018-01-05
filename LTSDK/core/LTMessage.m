//
//  LTMessage.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTMessage.h"
#import "LTXMPPManager+message.h"
@interface LTMessage ()
@property (nonatomic, strong) LTMessage_queryMessageBlock queryMessageBlock;
@end




@implementation LTMessage

+ (instancetype)share {
    static LTMessage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTMessage alloc] init];
    });
    return instance;
}



-(void)queryMesageCompleted:(LTMessage_queryMessageBlock)aBlock {
    _queryMessageBlock = aBlock;
    
    __weak typeof(self) weakself = self;
    [LTXMPPManager.share sendRequestMessageCompleted:^(NSDictionary *dict, LTError *error) {
        if (weakself.queryMessageBlock) {
            weakself.queryMessageBlock(dict, error);
        }
    }];
}



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
    return [LTXMPPManager.share sendMessageWithSenderJID:aSenderJID
                                                otherJID:aOtherJID
                                                    body:aBody];
    
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
    return [LTXMPPManager.share sendConferenceMessageWithSenderJID:aSenderJID
                                                     conferenceJID:aConferenceJID
                                                    conferenceName:aConferenceName
                                                              body:aBody];
}


-(NSDictionary *)sendTextWithSenderJID:(NSString *)aSenderJID
                              otherJID:(NSString *)aOtherJID
                      conversationType:(LTConversationType)aConversationType
                           messageType:(LTMessageType)aMessageType
                                  body:(NSString *)aBody {
    return [LTXMPPManager.share sendTextWithSenderJID:aSenderJID
                                             otherJID:aOtherJID
                                     conversationType:aConversationType
                                          messageType:aMessageType
                                                 body:aBody];
}













@end
