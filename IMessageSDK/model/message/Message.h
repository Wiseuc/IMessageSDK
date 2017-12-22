//
//  Message.h
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

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
 **/


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


#import <Foundation/Foundation.h>
#import "BGFMDB.h"
typedef void(^MessageDBChangeBlock)(void);
@interface Message : NSObject


@property (nonatomic, strong) NSString  *currentMyJID;       /**当前登录我的JID:用于区分不同登录用户**/
@property (nonatomic, strong) NSString  *currentOtherJID;    /**当前对方的JID:搜索和同一用户的所有聊天信息**/
@property (nonatomic, strong) NSString  *conversationName;   /**会话室name,唯一标识  单聊：对方名  群聊：群名 **/

@property (nonatomic, strong) NSString  *stamp;               /**时间**/
@property (nonatomic, strong) NSString  *body;               /**文本**/
@property (nonatomic, strong) NSString  *bodyType;           /**bodyType_Text:文本   bodyType_Voice:声音**/



#pragma mark - text

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *type;        /**chat:单聊  groupchat:群聊  chatRoom:讨论组   attributeGroupChat:xxx群聊 **/
@property (nonatomic, strong) NSString *UID;         /**message的唯一标识**/
@property (nonatomic, strong) NSString *SenderJID;   /**群组：发送者JID**/

















#pragma mark - add
/**存储**/
-(void)jh_saveOrUpdate;


#pragma mark - delete
/**通过UID删除信息**/
//-(void)jh_deleteByUID:(NSString *)aUID;
/**通过对方JID删除信息**/
+(void)jh_deleteByCurrentOtherJID:(NSString *)aJID;
/**删除数据表所有信息**/
+(void)jh_clear;
/**删除数据库信息表**/
+(void)jh_drop;




#pragma mark - query
/**查询所有信息**/
+(NSArray *)jh_queryAll;
/**通过UID查询**/
+(NSArray *)jh_queryByUID:(NSString *)aUID;
/**通过UID查询**/
+(NSArray *)jh_queryByCurentOtherJID:(NSString *)aOtherJID;

/**
 通过我的jid查询所有会话
 **/
+(NSArray *)jh_queryCurrentOtherJIDByMyJID:(NSString *)aMyJID;


/**通过conversationName查找信息，并用timestamp时间戳排序**/
//+(NSArray *)jh_queryByConversationName:(NSString *)aConversationName;


/**通过conversationName查找信息，并用timestamp时间戳排序**/
+(NSArray *)jh_queryByConversationName:(NSString *)aConversationName currentMyJID:(NSString *)aCurrentMyJID;


/**通过jid获取回话name，没有则返回nil**/
//+(NSString *)jh_queryConversationNameByJID:(NSString *)aJID;
+(NSString *)jh_queryConversationNameByJID:(NSString *)aJID myJID:(NSString *)aMyJID;

#pragma mark - 监听DB

+(void)settingDBOberser:(MessageDBChangeBlock)aBlock;
+(void)unsettingDBOberser;



@end
