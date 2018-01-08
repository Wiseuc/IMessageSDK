/*!
 @header
 @abstract 信息管理类
 @author 江海（JiangHai）
 @version v5.2.0
 */

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
#import "LTMessageDef.h"
typedef void(^LTMessage_queryMessageBlock)(NSDictionary *dict,LTError *error);





/*!
 @class
 @abstract 信息管理类
 */
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
 @abstract 请求服务器消息
 @discussion 监听服务器消息，回调返回消息
 */
- (void)queryMesageCompleted:(LTMessage_queryMessageBlock)aBlock;




/*!
 @method
 @abstract 发送Text信息
 @discussion 备注
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
 @param aBody voice信息名字：例如45485454456456456.mp3
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendVoiceWithSenderJID:(NSString *)aSenderJID
                               otherJID:(NSString *)aOtherJID
                       conversationName:(NSString *)aConversationName
                       conversationType:(LTConversationType)aConversationType
                            messageType:(LTMessageType)aMessageType
                              localPath:(NSString *)aLocalPath
                               duration:(NSString *)aDuration
                                   body:(NSString *)aBody;






@end
