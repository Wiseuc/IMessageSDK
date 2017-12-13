//
//  XMPPManager+Presence.h
//  WiseUC
//
//  Created by 吴林峰 on 15/11/20.
//  Copyright © 2015年 WiseUC. All rights reserved.
//

#import "XMPPManager.h"

/*
 available -- 发送available：申请上线(默认)； 接收到available：某好友上线了
 unavailable -- 发送unavailable：申请下线； 接收到unavailable： 某好友下线了
 subscribe -- 发送subscribe：请求加对方为好友； 接收到subscribe：别人加我好友
 subscribed -- 发送subscribed：同意对方的加好友请求； 接收到subscribed：对方已经同意我的加好友请求
 unsubscribe -- 发送unsubscribe：删除好友； 接收到unsubscribe：对方已将我删除
 unsubscribed -- 发送unsubscribed：拒绝对方的加好友请求； 接收到unsubscribed：对方拒绝我的加好友请求
 error -- 当前状态packet有错误
 */

typedef enum {
    PresenceType_Offline,       /**<下线*/
    PresenceType_Online,        /**<在线*/
    PresenceType_Busy,          /**<忙碌*/
    PresenceType_Outline,       /**<离开*/
} PresenceType;

#define PresenceType_OfflineDescription     @"下线"
#define PresenceType_OnlineDescription      @"在线"
#define PresenceType_BusyDescription        @"离开"

#define kJID        @"JID"
#define kStatu     @"statu"

#define kPlatform_WinduoIM @"WinduoIM"
#define kPlatform_AndroidIM @"AndroidIM"
#define kPlatform_IphoneIM @"IphoneIM"

/**
 *  好友在线状态
 */
@interface XMPPManager (Presence)

/**
 *  在线状态描述
 *
 *  @param presenceType 在线状态
 *
 *  @return  在线状态描述
 */
+ (NSString *)presenceTypeDescription:(PresenceType)presenceType;

/**
 *  通过在线类型获取在线状态显示图片名
 *
 *  @param presenceType 在线类型
 *
 *  @return 在线状态显示图片名
 */
+ (NSString *)presenceTypeImageName:(PresenceType)presenceType;

/**
 *  通过JID获取在线类型
 *
 *  @param chatterJID jid
 *
 *  @return 在线类型
 */
+ (PresenceType)presenceStatuForJID:(NSString *)chatterJID;

/**
 *  当前登录用户在线类型
 *
 *  @param IPhonePlatform_JID  当前登录用户jid (例：test001@duowin-server)
 *
 *  @return 在线类型
 */
+ (PresenceType)presenceStatuForIPhonePlatform_JID:(NSString *)IPhonePlatform_JID;

/**
 *  更新JID的在线类型
 *
 *  @param jid      目标jid
 *  @param presence 在线类型
 */
+ (void)jid:(NSString *)jid changePresenceStatuTo:(PresenceType)presence;

/**
 *  创建群主之间发送的消息
 *
 *  @param roomID   群UUID
 *  @param domain   后缀
 *  @param resource 创建人标记
 */
+ (void)sendPresenceToRoomID:(NSString *)roomID domain:(NSString *)domain resource:(NSString *)resource;

@end
