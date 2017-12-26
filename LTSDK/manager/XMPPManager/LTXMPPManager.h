//
//  LTXMPPManager.h
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
#import "XMPPLib.h"
#import "XMPPManager+IQ.h"
#import "AppManager.h"
#import "XMPPStream+secure.h"
#import "Encrypt_Decipher.h"
#import "LT_Macros.h"
#import "LT_XMLReader.h"
#import "LT_NSObject+Additions.h"
#import "LT_NSMutableString+ReplacingOccurencesOfString.h"
#import "LT_POAPinyin.h"
#import "LT_MessageAnalysis.h"
#import "LT_OrgManager.h"


typedef void(^LTXMPPManagerLoginBlock)(LTError *error);
typedef void(^LTXMPPManager_friend_queryRostersBlock)(NSMutableArray *arrM, NSString *rosterVersion);
typedef void(^LTXMPPManager_friend_queryRosterVCardBlock)(NSDictionary *dict,LTError *error);
typedef void(^LTXMPPManager_friend_addFriendBlock)(NSDictionary *dict,LTError *error);


typedef void(^LTXMPPManager_group_queryGroupsBlock)(NSMutableArray *arrM, NSString *groupVersion);
typedef void(^LTXMPPManager_group_queryGroupVCardBlock)(NSDictionary *dict);



typedef void(^LTXMPPManager_message_queryMessageBlock)(NSDictionary *dict,LTError *error);
typedef void(^LTXMPPManager_presence_addFriendPresenceObserverBlock)(NSDictionary *dict);

@interface LTXMPPManager : NSObject
{
    BOOL _enableLDAP;
    NSString *_ip;
    NSString *_port;
    NSString *_username;
    NSString *_password;
}
@property (nonatomic, strong) XMPPStream    *aXMPPStream;
@property (nonatomic, strong) XMPPRoster    *aXMPPRoster;
@property (nonatomic, strong) XMPPReconnect *aXMPPReconnect;
@property (nonatomic, strong) XMPPAutoPing  *aXMPPAutoPing;
@property (nonatomic, strong) XMPPRosterCoreDataStorage  *aXMPPRosterCoreDataStorage;
@property (nonatomic, assign) long long     timeOffset_localAndServer;  /**本地时间和服务器时间差值 本地>服务器**/

//回调
@property (nonatomic, strong) LTXMPPManagerLoginBlock aXMPPManagerLoginBlock;



/**好友**/
@property (nonatomic, strong) LTXMPPManager_friend_queryRostersBlock friend_queryRostersBlock;  /**请求好友列表回调**/
@property (nonatomic, strong) LTXMPPManager_friend_queryRosterVCardBlock friend_queryRosterVCardByJidBlock;  /**请求Vcard回调**/
@property (nonatomic, strong) LTXMPPManager_friend_addFriendBlock friend_addFriendBlock;  /**请求添加好友**/


/**群组**/
@property (nonatomic, strong) LTXMPPManager_group_queryGroupsBlock group_queryGroupsBlock;  /**请求群组列表回调**/
@property (nonatomic, strong) LTXMPPManager_group_queryGroupVCardBlock group_queryGroupVCardBlock;  /**请求群组资料VCard回调**/


/**一般IQ**/



/**消息**/
@property (nonatomic, strong) LTXMPPManager_message_queryMessageBlock message_queryMessageBlock;  /**请求Message回调**/

/**Presence**/
@property (nonatomic, strong) LTXMPPManager_presence_addFriendPresenceObserverBlock presence_addFriendPresenceObserverBlock;  /**好友出席状态回调**/


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  ..
 */
+ (instancetype)share;

+(void)xmppmanagerDealloc;
    
    
    
    
/*!
 @method
 @abstract 登录操作
 @discussion 使用auth-server连接服务器，获取真实用户登录信息
 @param aIP ip
 @param aPort 端口
 @param aUsername 用户名
 @param aPassword 密码
 */
- (void)loginWithaIP:(NSString *)aIP
                port:(NSString *)aPort
            username:(NSString *)aUsername
            password:(NSString *)aPassword
          enableLDAP:(BOOL)aEnableLDAP
           completed:(LTXMPPManagerLoginBlock)aXMPPManagerLoginBlock;



/*!
 @method
 @abstract 再次连接服务器
 @discussion 接收到授权iq后，使用返回的真实信息重连服务器
 @param aJID jid
 @param aPassword 密码
 @param aResource 资源
 */
- (void)loginAgainWithJID:(NSString *)aJID
                 password:(NSString *)aPassword
                 resource:(NSString *)aResource;


/*!
 @method
 @abstract 验证密码
 @discussion null
 */
-(void)loginAuthWithPassword:(NSString *)aPassword;



/*!
 @method
 @abstract 获取当前时间戳
 @discussion 服务器时间 = 系统时间 - 差值
 @result  时间戳
 */
- (long long)queryServerTimeStamp;







@end
