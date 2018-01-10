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
                                  body:(NSString *)aBody;


/*!
 @method
 @abstract 发送Voice信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（voice）
 @param aDuration voice时长
 @param aBody 信息
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
                                   body:(NSString *)aBody;


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
                                   body:(NSString *)aBody;




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
                                  body:(NSString *)aBody;










@end
