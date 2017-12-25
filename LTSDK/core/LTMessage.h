//
//  LTMessage.h
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTError.h"
typedef void(^LTMessage_queryMessageBlock)(NSDictionary *dict);


@interface LTMessage : NSObject
/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 请求消息
 @discussion 回调返回消息
 */
- (void)queryMesageCompleted:(LTMessage_queryMessageBlock)aBlock;


/*!
 @method
 @abstract 发送消息
 @discussion null
 @param aMyJID 我的jid
 @param aOtherJID 对方jid
 @param aBody 信息
 @param aChatType chat:单聊   groupchat：群聊
 @result  返回信息字典用于保存在本地，显示
 */
//-(NSDictionary *)asyncSendMessageWithMyJID:(NSString *)aMyJID
//                                  otherJID:(NSString *)aOtherJID
//                                      body:(NSString *)aBody;



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
