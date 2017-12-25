//
//  LTXMPPManager+message.h
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
void runCategoryForFramework42();
@interface LTXMPPManager (message)


/**请求好友列表**/
- (void)sendRequestMessageCompleted:(LTXMPPManager_message_queryMessageBlock)message_queryMessageBlock;


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
                                     body:(NSString *)aBody;



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
                                               body:(NSString *)aBody;







@end
