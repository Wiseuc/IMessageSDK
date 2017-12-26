//
//  NewFriendMessage.h
//  IMessageSDK
//
//  Created by JH on 2017/12/26.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFriendMessage : NSObject
@property (nonatomic, strong) NSString  *currentMyJID;       /**当前登录我的JID:用于区分不同登录用户**/
@property (nonatomic, strong) NSString  *currentOtherJID;    /**当前对方的JID:搜索和同一用户的所有聊天信息**/

@property (nonatomic, strong) NSString *body;        /**文本**/
@property (nonatomic, strong) NSString *from;        /**对方名字**/
@property (nonatomic, strong) NSString *type;        /**subscribe:好友请求 **/









#pragma mark - add

-(void)jh_saveOrUpdate;





#pragma mark - query

/*!
 @method
 @abstract 查询数据库中所有记录的jid（去重）
 @param aCurrentMyJID 我的jid
 @result  jid数组
 */
+(NSArray *)jh_queryAllCurrentOtherJIDByCurrentMyJID:(NSString *)aCurrentMyJID;


/*!
 @method
 @abstract 查找所有记录
 @discussion <#备注#>
 @param aCurrentOtherJID 对方jid
 @param aCurrentMyJID 我的jid
 @result  jid数组
 */
+(NSArray *)jh_queryByCurrentOtherJID:(NSString *)aCurrentOtherJID currentMyJID:(NSString *)aCurrentMyJID;
















    
@end
