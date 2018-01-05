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
 @abstract 发送文本消息:单聊
 @discussion null
 @param aSenderJID 我的jid
 @param aOtherJID 对方jid
 @param aBody 信息
 @result  返回信息字典用于保存在本地，显示
 */
-(NSDictionary *)sendMessageWithSenderJID:(NSString *)aSenderJID
                                 otherJID:(NSString *)aOtherJID
                                     body:(NSString *)aBody;

/*!
 @method
 @abstract 发送文本消息:单聊
 @param aSenderJID 我的jid
 @param aConferenceJID 对方jid
 @param aConferenceName 对方name
 @param aBody 信息
 @result  返回信息字典用于保存在本地，显示
 */
-(NSDictionary *)sendConferenceMessageWithSenderJID:(NSString *)aSenderJID
                                      conferenceJID:(NSString *)aConferenceJID
                                     conferenceName:(NSString *)aConferenceName
                                               body:(NSString *)aBody;


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
                      conversationType:(LTConversationType)aConversationType
                           messageType:(LTMessageType)aMessageType
                                  body:(NSString *)aBody;












@end
