//
//  Message.h
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "BGFMDB.h"
typedef void(^MessageDBChangeBlock)(void);
@interface Message : NSObject

@property (nonatomic, strong) NSString  *currentMyJID;       /**当前登录我的JID:用于区分不同登录用户**/
@property (nonatomic, strong) NSString  *currentOtherJID;    /**当前对方的JID（有可能是群JID）:搜索和同一用户的所有聊天信息**/

@property (nonatomic, strong) NSString  *stamp;              /**时间:只有群组消息才有，延迟发送 **/
@property (nonatomic, strong) NSString  *bodyType;           /**text:文本   voice:声音**/
/**
 text:文本
 voice:声音
 
 **/

@property (nonatomic, strong) NSString  *body;
/**文本：如果是文本则为文本
 为语音：58569565985.mp3
 为视频：687687678687.mp4
 为文件：9878967896789.txt
 为图片：5897856656875.png
 为位置：{name:  longitude:  latitude:  address:}
 为SOS：^SOS
 **/




#pragma mark - text
//第一组
//xmlns
@property (nonatomic, strong) NSString *UID;         /**message的唯一标识**/

//第二组
//id
@property (nonatomic, strong) NSString *to;

//第三组
@property (nonatomic, strong) NSString *conversationName;   /**会话室name,在聊天List有用，唯一标识  单聊：对方名  群聊：群名 **/


//第四组
/**
 真正发送者：通过from判断是谁发送的这条消息
 from="萧凡宇@duowin-server/AndroidIM"
 from="fd3f752ffdfe4c5cbb26e818c6ca6f4c@conference.duowin-server/萧凡宇"
 **/
@property (nonatomic, strong) NSString *from;
/**
 conversionType:  chat:单聊  groupchat:群聊  chatRoom:讨论组   attributeGroupChat:xxx群聊
 **/
@property (nonatomic, strong) NSString *type;




//voice语音信息
@property (nonatomic, strong) NSString  *duration;  /**语音时长**/


















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

/*!
 @method
 @abstract 删除信息
 @discussion 删除好友请求，群组请求。。。
 @param aType （好友请求／群组请求）
 @param aMyJID 我的jid
 @param aOtherJID 对方jid
 @param aOtherName 对方名字
 */
+(void)jh_deleteMessageByType:(NSString *)aType
                 currentMyJID:(NSString *)aMyJID
               curentOtherJID:(NSString *)aOtherJID
             currentOtherName:(NSString *)aOtherName;


/*!
 @method
 @abstract 删除记录
 @discussion <#备注#>
 @param aCurrentMyJID 我的jid
 @param aCurrentOtherJID 对方jid
 */
+(void)jh_deleteDataByCurrentMyJID:(NSString *)aCurrentMyJID
                   currentOtherJID:(NSString *)aCurrentOtherJID;















#pragma mark - query
/**查询所有信息**/
+(NSArray *)jh_queryAll;



/*!
 @method
 @abstract 查询会话OtherJID数组
 @discussion <#备注#>
 @param aMyJID 我的JID
 @result  会话OtherJID数组
 */
+(NSArray *)jh_queryCurrentOtherJIDByMyJID:(NSString *)aMyJID;



/*!
 @method
 @abstract 查询和对方所有聊天信息，并用timestamp时间戳排序
 @discussion null
 @param aCurrentOtherJID 对方JID
 @param aCurrentMyJID 我的JID
 @result  所有聊天信息
 */
+(NSArray *)jh_queryByCurrentOtherJID:(NSString *)aCurrentOtherJID
                         currentMyJID:(NSString *)aCurrentMyJID;









#pragma mark - 监听DB

+(void)settingDBOberser:(MessageDBChangeBlock)aBlock;
+(void)unsettingDBOberser;



@end
