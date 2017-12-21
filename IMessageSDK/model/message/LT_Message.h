//
//  LT_Message.h
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//


/**
 文本类型
 
 bodyType_Text,
 bodyType_Image,
 bodyType_Video,
 bodyType_Location,
 bodyType_Voice,
 bodyType_File,
 bodyType_Command,
 bodyType_Vibrate
 **/



#import <Foundation/Foundation.h>

#import "BGFMDB.h"

/**
 1.本库自带的自动增长主键.
 @property(nonatomic,strong)NSNumber*_Nullable bg_id;
 
 2.为了方便开发者，特此加入以下两个字段属性供开发者做参考.(自动记录数据的存入时间和更新时间)
 @property(nonatomic,copy)NSString* _Nonnull bg_createTime;//数据创建时间(即存入数据库的时间)
 @property(nonatomic,copy)NSString* _Nonnull bg_updateTime;//数据最后那次更新的时间.
 
 3.自定义表名
 @property(nonatomic,copy)NSString* _Nonnull bg_tableName;
 **/






@interface LT_Message : NSObject

#pragma mark - common

@property (nonatomic, assign) NSString  *currentMyJID;       /**当前登录我的JID:用于区分不同登录用户**/
@property (nonatomic, assign) NSString  *currentOtherJID;    /**当前对方的JID:搜索和同一用户的所有聊天信息**/

@property (nonatomic, strong) NSString  *conversationName;   /**会话室name，只是用来显示**/
@property (nonatomic, assign) long long stamp;               /**时间**/
@property (nonatomic, strong) NSString  *body;               /**文本**/
@property (nonatomic, strong) NSString  *bodyType;           /**文本类型**/



#pragma mark - text
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


#pragma mark - update


#pragma mark - query
/**查询所有信息**/
+(NSArray *)jh_queryAll;
/**通过UID查询**/
+(NSArray *)jh_queryByUID:(NSString *)aUID;
/**通过UID查询**/
+(NSArray *)jh_queryByCurentOtherJID:(NSString *)aOtherJID;

/**
 直接写SQL语句操作.
 查询时,后面两个参数必须要传入.
 */
+(NSArray *)jh_queryByDistinctCurrentOtherJID;













@end
