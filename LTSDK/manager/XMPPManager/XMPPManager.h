//
//  XMPPManager.h
//  XMPP即时通讯
//
//  Created by 吴林峰 on 15/5/15.
//  Copyright (c) 2015年 ___LinFeng___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
//#import "LT_Macros.h"
//#import "Macros.h"
#import "XMPPLib.h"

//#import "UserModel.h"
//#import "Message.h"
#define PhotoHashTimerInterval 600
typedef void(^XMPPManagerLoginBlock) (id response, LTError *error);
@protocol XMPPServerDelegate;
@protocol XMPPMessageReceiverDelegate;
@protocol XMPPManagerReconnetDelegate;





@interface XMPPManager : NSObject
@property (nonatomic, strong) XMPPManagerLoginBlock aXMPPManagerLoginBlock;

@property (nonatomic, strong) XMPPStream *xmppStream;
//@property (nonatomic, strong) UserModel *userModel;
//@property (nonatomic, strong) NSMutableDictionary *rosterPresence;
//@property (nonatomic, strong) NSMutableDictionary *rosterHeadPicture;
//@property (nonatomic, strong)XMPPvCardTempModule *vCard;//电子名片
//@property (nonatomic, strong)XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage;//花名册数据存储
//@property (nonatomic, strong)id<XMPPServerDelegate> delegate;
//@property (nonatomic, strong)id<XMPPMessageReceiverDelegate> msgReceiverdelegate;
//@property (nonatomic, strong)id<XMPPManagerReconnetDelegate> xmppManagerReconnetDelegate;
//@property (nonatomic, strong) NSTimer *photoHashtimer;  /**<头像请求定时器*/



#pragma mark - 单例
//初始化
+ (instancetype)share;



/*!
 @method
 @abstract 登录操作
 @discussion null
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
           completed:(XMPPManagerLoginBlock)aXMPPManagerLoginBlock;





//切换在线状态
- (void)online;
//切换忙碌状态
//- (void)busy;
//驻留，进入后台
- (void)reside;
//注销，退出
- (void)offline;
//清理（退出）
- (void)clear;
//获取个人消息
- (void)getPersonJid:(NSString *)personJid;
//获取个人消息
- (void)getGroupMemberJid:(NSString *)groupMemberJid;
//上传头像
- (void)uploadHeadImageByJid:(NSString *)myJid withPhotoHash:(NSString *)photoHash;
//获取服务器当前时间时间戳
- (long long)getServerCurrentTimestamp;




#pragma mark - 发送一条消息 参考环信
/*!
 @method
 @brief 异步方法, 发送一条消息
 @discussion 待发送的消息对象和发送后的消息对象是同一个对象, 在发送过程中对象属性可能会被更改.
 @param message  消息对象(包括from, to, body列表等信息)
 @param progress 发送多媒体信息时的progress回调对象
 @result 发送的消息对象
 */
//- (Message *)asyncSendMessage:(Message *)message progress:(id)progress;

@end





///**
// 服务器数据代理
// */
//@protocol XMPPServerDelegate <NSObject>
//@optional
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveGroups:(NSMutableArray *)groups; //获取到群组列表
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveGroup:(NSMutableDictionary *)groups; //获取群详细信息
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveRoster:(NSMutableArray *)items withVersion:(NSString *)version; //获取到花名册
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveInformationForSomeone:(NSMutableDictionary *)information;//获取个人信息
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveMembers:(NSMutableArray *)members forGroup:(NSString *)group;
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveAllGroupsBySearch:(NSMutableArray *)groups; //获取到所有搜索到的群组列表
//- (NSString *)XMPPServer:(XMPPManager *)xmppServer valueFromCachesByProperty:(NSString *)property jabberId:(NSString *)jabberId withRequestId:(NSString *)requestId;
//@end






///**
// 消息接收代理
// */
//@protocol XMPPMessageReceiverDelegate <NSObject>
//@optional
//// 接收消息
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceive:(Message *)message;
//// 接收success消息刷新界面
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveSuccessMessage:(Message *)successMessage;
//// 接收正在输入消息信息
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveInputingJid:(NSString *)fromJid;
//// 接收已阅消息信息
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveHasReadJid:(NSString *)fromJid messageId:(NSString *)messageId;
//// 接收创建群的确认信息
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveCreateGroupPresence:(NSString *)presence from:(NSString *)from;
//// 接收群已创建创建的确认信息
//- (void)XMPPServer:(XMPPManager *)xmppServer didReceiveSuccessCreateGroup:(BOOL)success from:(NSString *)from;
//// 消息是否发送成功
//- (void)XMPPServer:(XMPPManager *)xmppServer didSendMessage:(Message *)message;
//@end






///**
// 服务器连接代理
// */
//@protocol XMPPManagerReconnetDelegate <NSObject>
//@optional
//- (void)xmppServerWillConnect:(XMPPStream *)sender;
//- (void)xmppServerDidConnect:(XMPPStream *)sender;
//- (void)xmppServerDidDisconnect:(XMPPStream *)sender withError:(NSError *)error;
//@end

