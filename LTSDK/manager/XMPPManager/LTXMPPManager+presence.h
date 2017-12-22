//
//  LTXMPPManager+presence.h
//  LTSDK
//
//  Created by JH on 2017/12/14.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
void runCategoryForFramework36();
typedef enum {
    PresenceType_Offline,       /**<下线*/
    PresenceType_Online,        /**<在线*/
    PresenceType_Busy,          /**<忙碌*/
    PresenceType_Outline,       /**<离开*/
} LTPresenceType;

#define PresenceType_OfflineDescription     @"下线"
#define PresenceType_OnlineDescription      @"在线"
#define PresenceType_BusyDescription        @"离开"

#define kJID        @"JID"
#define kStatu     @"statu"

#define kPlatform_WinduoIM @"WinduoIM"
#define kPlatform_AndroidIM @"AndroidIM"
#define kPlatform_IphoneIM @"IphoneIM"
/*
 available -- 发送available：申请上线(默认)； 接收到available：某好友上线了
 unavailable -- 发送unavailable：申请下线； 接收到unavailable： 某好友下线了
 subscribe -- 发送subscribe：请求加对方为好友； 接收到subscribe：别人加我好友
 subscribed -- 发送subscribed：同意对方的加好友请求； 接收到subscribed：对方已经同意我的加好友请求
 unsubscribe -- 发送unsubscribe：删除好友； 接收到unsubscribe：对方已将我删除
 unsubscribed -- 发送unsubscribed：拒绝对方的加好友请求； 接收到unsubscribed：对方拒绝我的加好友请求
 error -- 当前状态packet有错误
 */




@interface LTXMPPManager (presence)

//通过在线类型获取在线状态显示图片名
+ (NSString *)presenceTypeImageName:(LTPresenceType)presenceType;
//通过JID获取在线类型
+ (LTPresenceType)presenceStatuForJID:(NSString *)chatterJID;
//更新JID的在线类型
- (void)changePresenceStatuWithJID:(NSString *)aJID To:(LTPresenceType)aPresence;
//创建群主之间发送的消息
+ (void)sendPresenceToRoomID:(NSString *)roomID domain:(NSString *)domain resource:(NSString *)resource;



/**发送在线**/
-(void)sendPresenceAvailable;
/**发送离线**/
-(void)sendPresenceUNAvailable;
/**发送忙碌**/
- (void)sendPresenceBusy;
/**发送后台**/
- (void)sendPresenceReside;
/**清理**/
- (void)clear;







@end