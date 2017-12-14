//
//  XMPPManager.m
//  XMPP即时通讯
//
//  Created by 吴林峰 on 15/5/15.
//  Copyright (c) 2015年 ___LinFeng___. All rights reserved.
//

#import "XMPPManager.h"
//#import "Macros.h"
//#import "NSObject+Additions.h"
//#import "XMLReader.h"
//#import "pinyin.h"
//#import "POAPinyin.h"
//#import "NSMutableString+ReplacingOccurencesOfString.h"
//#import "MessageXMLManager.h"
//#import "List.h"
//#import "HttpTool.h"
//#import "XMPPManager+Presence.h"
//#import "XMPPManager+IQ.h"
//#import "DownloadOrganizationsController.h"
#import "XMPPStream+secure.h"
#import "AppManager.h"
#import "Encrypt_Decipher.h"
//#import "UserManager.h"
//#import "AppDelegate+Background.h"
//#import "LoginManager.h"
//#import "RoamingMsgManager.h"
//#import "SVProgressHUD+Custom.h"

@interface XMPPManager () <XMPPStreamDelegate>
{
    XMPPRoster *xmppRoster;
    XMPPReconnect *xmppReconnet;
    XMPPAutoPing *_xmppAutoPing;
//    CompleteBlock _completeBlock;
//    BOOL _isRegister;
    BOOL _enableLDAP;   // 是否需要LDAP校验
    NSString *_ip;
    NSString *_port;
    NSString *_username;
    NSString *_password;
}
//本地时间超前服务器时间的时间（毫秒）
@property (nonatomic, assign) long long timeOffset_localLeadToServer;
@end





@implementation XMPPManager

#pragma mark - 单例
+ (instancetype)share {
    static XMPPManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMPPManager alloc] init];
    });
    return instance;
}




////- (void)setupStream
////{
////    // BOOL values for security settings
////    customCertEvaluation = NO;
////    allowSelfSignedCertificates = YES;
////    allowSSLHostNameMismatch = NO;
////}
//
- (instancetype)init {
    self = [super init];
    if (self) {
        // 1.初始化XMPP流
        _xmppStream = [[XMPPStream alloc] init];
        _xmppStream.enableBackgroundingOnSocket = YES;    //后台非活跃状态下可运行，在销毁状态下
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

        // 2.初始化XMPP花名册
        _xmppRosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc] init];
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterCoreDataStorage];
        [xmppRoster activate:_xmppStream];
//
//        // 3.断线自动重连
        xmppReconnet = [[XMPPReconnect alloc] init];
        [xmppReconnet activate:_xmppStream]; // 激活重连机制

        //(1)心跳监听类
        _xmppAutoPing = [[XMPPAutoPing alloc] init];
        _xmppAutoPing.pingInterval = 20.f; // 心跳包间隔
        [_xmppAutoPing activate:_xmppStream];
        [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];

        [_xmppStream setKeepAliveInterval:45];  //心跳包时间
        [_xmppStream registerCustomElementNames:[NSSet setWithObject:@"extmsg"]];  // 注册自定义消息
        _xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicyAllowed;  //SSL \ TLS 安全登录5223
        [DDLog addLogger:[DDTTYLogger sharedInstance]];


        /**
         非常重要：使得静态库中的Category可用，。
         详见：http://blog.csdn.net/wiseuc_jianghai/article/details/78795440
         
         //.h :
         void runCategoryForFramework();
         //.m :
         void runCategoryForFramework(){}
         **/
        
        
        runCategoryForFramework1();
        runCategoryForFramework2();
        runCategoryForFramework3();
        runCategoryForFramework4();
        runCategoryForFramework5();
        runCategoryForFramework6();
        runCategoryForFramework7();
        runCategoryForFramework8();
        runCategoryForFramework9();
        runCategoryForFramework10();
        
        
        
        
        runCategoryForFramework11();
        runCategoryForFramework12();
        runCategoryForFramework13();
        runCategoryForFramework14();
        runCategoryForFramework15();
        runCategoryForFramework16();
        runCategoryForFramework17();
        runCategoryForFramework18();
        runCategoryForFramework19();
        runCategoryForFramework20();
        
        
        
        
        runCategoryForFramework21();
        runCategoryForFramework22();
        runCategoryForFramework23();
        runCategoryForFramework24();
        runCategoryForFramework25();
        runCategoryForFramework26();
        runCategoryForFramework27();
        runCategoryForFramework28();
        runCategoryForFramework29();
        runCategoryForFramework30();
        
        
        
        runCategoryForFramework31();
        runCategoryForFramework32();
        
        // 初始化用户 userModel
//        _userModel = [[UserModel alloc] init];
//
//        // 好友在线状态
//        _rosterPresence = [NSMutableDictionary dictionary];
//        _rosterHeadPicture = [NSMutableDictionary dictionary];
    }
    return self;
}





#pragma mark
#pragma mark ======================SSL安全设置======================
/*
 第一步：
 1.使用5223端口的SSL连接服务器
 2.设置公钥
 */
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    //GCD异步套接字手动评估信任
    settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
}
/*
  *注意：如果您的开发服务器正在使用自签名证书，
  *您可能需要在设置中添加GCDAsyncSocketManuallyEvaluateTrust = YES。
  *然后实现xmppStream：didReceiveTrust：completionHandler：delegate方法来执行自定义验证。
 */
- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    completionHandler(YES);
}
- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    //NSLog(@"通过了 SSL/TLS 的安全验证");
}









#pragma mark - 代理 connect
////将要连接
- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    [_xmppStream performSelector:@selector(setIsSecure:) withObject:@(YES)];
    
    //[_xmppStream setIsSecure:YES];
}
//已经连接
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    if ( [sender.myJID.domain isEqualToString:@"auth-server"] ) {
        [self sendAuthIqWithUserName:_username
                            password:_password
                            serverIP:sender.hostName  /**带有resource**/
                          enableLDAP:_enableLDAP];
    }else {
        //[_xmppStream authenticateWithPassword:_userModel.password error:nil];
    }
}

//- (void)authenticateWith:(BOOL)isHaveDigset
//{
   // [_xmppStream authenticateWithPassword:_userModel.password error:nil];
//}








//
////断开连接错误
//- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
//    // 服务器地址错误
//    BOOL isServerIPError = [error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"Connection refused"];
//    //[SVProgressHUD showErrorWithStatus:@"登录失败0046" withDelay:1];
//    if ( _completeBlock && isServerIPError ) {
//        _completeBlock(nil,error);
//    }
//}
//
//#pragma  mark -- 登陆
////已经获得授权
//- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
//
//    // 申请上线
//    [self online];
//
//    // 获取服务器时间
//    [self getServerTime];
//
//    //  登陆成功
//    if ( _completeBlock ) {
//        _completeBlock(_userModel,nil);
//    }
//}
////获取授权失败
//- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
//    //  登陆失败
////    NSError *myError = [NSError errorWithDomain:error.description code:-1 userInfo:nil];
//}
//
//
//
//
//#pragma mark -- XMPPMessage 消息发送
////发送风格消息成功
//- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
//    NSString *msgUID = [[message attributeForName:@"UID"] stringValue];
//    [self didSendMessage:msgUID success:YES];
//}
////发送消息失败
//- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
//    NSString *msgUID = [[message attributeForName:@"UID"] stringValue];
//    [self didSendMessage:msgUID success:NO];
//}
//
//- (void)didSendMessage:(NSString *)messageId success:(BOOL)success
//{
//    if ( messageId == nil ) {
//        return;
//    }
//
//    MessageDeliveryState msgDeliveryState = success ? eMessageDeliveryState_Delivered : eMessageDeliveryState_Failure;
//    Message *msg = [Message findMessageWithMessageId:messageId];
//    if ( msg == nil )
//    {
//        return;
//    }
//    msg.deliveryState = msgDeliveryState;
//    [msg update];
//
//    // 已优化 // isSendRead == 1,对方已阅，肯定是发送成功了,这时已发送成功消息不刷新对应消息, 收到对方已阅的时候，这个发送状态直接置为已发送，并且已经刷新过界面一次了
//    if ( msg.isSendRead == YES ) {
//        return;
//    }
//    if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didSendMessage:)] ) {
//        [_msgReceiverdelegate XMPPServer:self didSendMessage:msg];
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//#pragma mark
//#pragma mark ===代理：XMPPMessage
//
///**
// 接收到新消息
//
// @param sender <#sender description#>
// @param message <#message description#>
// */
//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
//
//    if (AppDelegateInstance.isEnterBackground && message.body != nil && ![message.body isEqualToString:@""]) {
//        if ([UserManager shareInstance].isNotificationShowMessageDetail) {
//            [AppDelegateInstance localNotification:[NSString stringWithFormat:@"%@: %@",message.from.user,message.body]];
//        }else {
//            [AppDelegateInstance localNotification:@"您收到了一条新消息"];
//        }
//    }
//
//
//    //如果消息是已阅未阅消息 “type：ack”
//    if ([[message attributeForName:@"type"].stringValue isEqualToString:@"ack"]) {
//        NSString *messageId = [message attributeForName:@"mid"].stringValue;
//        Message *dbMessage = [Message findMessageWithMessageId:messageId];// 消息即焚收到已阅自动删除
//
//        if ( dbMessage.isBurn == YES )
//        {
//            NSString *jid = [UserManager shareInstance].currentUser.jid;
//            NSString *password = [UserManager shareInstance].currentUser.password;
//            [[RoamingMsgManager new] deleteMessageWithWithJID:jid password:password messageId:dbMessage.messageId completeHandler:^(BOOL success, id response) {
//                NSLog(@"%@",response);
//            }];
//            [dbMessage remove];
//        }else{
//            // 非阅读即焚置为 对方“已读”
//            if ( dbMessage.isSendRead == NO ) {
//                // 对方已阅，肯定是发送成功了
//                dbMessage.deliveryState = eMessageDeliveryState_Delivered;
//                dbMessage.isSendRead = YES;
//            }
//            [dbMessage update];
//        }
//
//        if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveHasReadJid:messageId:)] ) {
//            NSString *jid = [[[message attributeForName:@"from"].stringValue componentsSeparatedByString:@"/"] firstObject];
//            [_msgReceiverdelegate XMPPServer:self didReceiveHasReadJid:jid messageId:messageId];
//        }
//        return;
//    }
//
//
//    //新消息不是已阅未阅消息
//    NSArray *xArr = [message elementsForName:kStringXMPPX];
//    if ( xArr.count > 0 ) {
//        NSXMLElement *x = xArr[0];
//        if ( [x elementsForName:@"composing"].count > 0 ) {
//            NSString *xmlns = [x xmlns];
//            if ([xmlns isEqualToString:@"jabber:x:event"]) {
//                NSString *from = [[message attributeForName:kStringXMPPFrom] stringValue];
//                NSString *fromJid = [[from componentsSeparatedByString:@"/"] firstObject];
//                if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveInputingJid:)] ) {
//                    [_msgReceiverdelegate XMPPServer:self didReceiveInputingJid:fromJid];
//                }
//            }
//        }
//    }
//
//
//
//    /**如果是信息**/
//    /**chat_0002:解决由服务器地址映射导致的群文件发送失败问题**/
//    Message *msg = [MessageXMLManager formatXMLMessage:message];
//    if ( msg ) {
//
//
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_NewMessage object:msg];
//
//        if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceive:)] ) {
//            [_msgReceiverdelegate XMPPServer:self didReceive:msg];
//        }
//    }
//    /**如果不是信息**/
//    else
//    {
//        XMMessage *successMsg = [MessageXMLManager checkSuccessAndNotifationToChatController:message];
//
//#warning 这样写有隐患
//        NSString *sql = [NSString stringWithFormat:@" WHERE localPath = '%@' ", successMsg.localPath];
//        Message *_successMsg = [Message findFirstByCriteria:sql];
//        if ( successMsg && (_successMsg.bodyType == eMessageBodyType_Image || _successMsg.bodyType == eMessageBodyType_Voice) ) {
//            if ( _successMsg && _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveSuccessMessage:)] ) {
//                [_msgReceiverdelegate XMPPServer:self didReceiveSuccessMessage:_successMsg];
//            }
//        }
//
//        if (successMsg && !_successMsg) {
//            Message *textImageMsg = [[Message alloc] init];
//
//            NSString *from = [[message attributeForName:kStringXMPPFrom] stringValue];
//            from = [[from componentsSeparatedByString:@"/"] objectAtIndex:0];
//            NSString *to = [[message attributeForName:kStringXMPPTo] stringValue];
//            to = [[to componentsSeparatedByString:@"/"] objectAtIndex:0];
//
//            BOOL isFromSelf = [from isEqualToString:[UserManager shareInstance].currentUser.jid];
//
//            // 会话对象
//            textImageMsg.conversationChatter = isFromSelf ? to : from;
//            textImageMsg.bodyType = eMessageBodyType_Image;
//            textImageMsg.localPath = successMsg.localPath;
//
//            if ( _msgReceiverdelegate && [_msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveSuccessMessage:)] ) {
//                [_msgReceiverdelegate XMPPServer:self didReceiveSuccessMessage:textImageMsg];
//            }
//        }
//    }//end else
//
//
//}
////接收消息失败
//- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
//{
//    NSLog(@"%@",error);
//}
//
//
//
//
//
//
//- (NSMutableDictionary *)copiedMutableDictionaryFrom:(NSDictionary *)source
//{
//    NSMutableDictionary *target = [[NSMutableDictionary alloc] initWithCapacity:10];
//    for(NSString *key in [source allKeys])
//    {
//        [target setObject:[self valueForKey:key inDictionary:source] forKey:key];
//    }
//    return target;
//}
//
//- (NSMutableDictionary *)copiedSomeone:(NSDictionary *)from
//{
//    //先存下来组别信息
//    NSString *group = [self valueForKey: @"group" inDictionary:from];
//
//    //复制一份在线状态，并去掉原有的组别信息字典
//    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:from copyItems:YES];
//
//    NSString *fullName = [NSObject objectForKey:@"name" inDictionary:from];
//    if([NSObject isEmpty:fullName]) //如果名字为空，那么从组织架构里取，如果组织架构里没有，再截jabberId的@之前的部分，即为名字
//    {
//        if(_delegate!=nil && [_delegate respondsToSelector:@selector(XMPPServer:valueFromCachesByProperty:jabberId:withRequestId:)])
//        {
//            fullName = [_delegate XMPPServer:self
//                    valueFromCachesByProperty:@"name"
//                                     jabberId:[NSObject objectForKey:@"jid" inDictionary:from]
//                                withRequestId: @"rosters"];
//        }
//    }
//    [item setObject:fullName forKey:@"FN" ];
//    [item setObject:[self transferToPinYin:fullName] forKey:@"pinYin"];
//    [item removeObjectForKey:kXMLReaderTextNodeKey];
//    //再把级别字符串添加进去
//    [item setObject:group forKey:@"group"];
//    return item;
//}
//- (NSString *)transferToPinYin:(NSString *)name
//{
//    NSMutableString *_pinYin = [NSMutableString stringWithCapacity:1];
//
//    for(int j=0; j<name.length; j++)
//    {
//        int character = [name characterAtIndex:j];
//        if(character==32)
//            continue;
//
//        if(character>=65 && character<=128)
//        {
//            if(j>0) //取首字母
//            {
//                int lastCharacter = [name characterAtIndex:j-1];
//                if(lastCharacter==32)
//                    [_pinYin appendString:[[name substringWithRange:NSMakeRange(j, 1)] uppercaseString]];
//            }
//            else
//                [_pinYin appendString:[[NSString stringWithFormat:@"%c", character] uppercaseString]];
//        }
//        else
//        {
//            [_pinYin appendString:[[NSString stringWithFormat:@"%c", pinyinFirstLetter(character)] uppercaseString]];
//        }
//    }
//    return _pinYin;
//}
//
//- (NSString *)valueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary
//{
//    id value = [NSObject objectForKey:key inDictionary:dictionary];
//    if([value isKindOfClass:[NSDictionary class]])
//    {
//        NSDictionary *dValue = [NSObject objectForKey:key inDictionary:dictionary];
//        value = [NSObject objectForKey:kXMLReaderTextNodeKey inDictionary:dValue];
//    }
//    else if(![value isKindOfClass:[NSString class]])
//    {
//        value = [value description];
//    }
//    return value;
//}
//
////获取个人消息
//- (void)getPersonJid:(NSString *)personJid
//{
//    NSString *elementID = @"rstrone";
//    XMPPJID *to = [XMPPJID jidWithString:personJid];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
//    NSXMLElement *query = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
//    [query addAttributeWithName:kStringXMPPVersion stringValue:@"0"];
//    [iq addChild:query];
//    [_xmppStream sendElement:iq];
//}
//
////获取个人消息
//- (void)getGroupMemberJid:(NSString *)groupMemberJid
//{
//    NSString *elementID = kStringXMPPElementIDMembers;
//    XMPPJID *to = [XMPPJID jidWithString:groupMemberJid];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
//    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#user"];
//
//    NSXMLElement *member = [NSXMLElement elementWithName:kStringXMPPIQItem];
//    [member addAttributeWithName:kStringXMPPIQItemAffiliation
//                     stringValue:kStringXMPPIQItemAffiliationMember];
//    [query addChild:member];
//
//    NSXMLElement *administrator = [NSXMLElement elementWithName:kStringXMPPIQItem];
//    [administrator addAttributeWithName:kStringXMPPIQItemAffiliation stringValue:kStringXMPPIQItemAffiliationAdministrator];
//    [query addChild:administrator];
//
//    NSXMLElement *owner = [NSXMLElement elementWithName:kStringXMPPIQItem];
//    [owner addAttributeWithName:kStringXMPPIQItemAffiliation stringValue:kStringXMPPIQItemAffiliationOwner];
//    [query addChild:owner];
//
//    [iq addChild:query];
//    [_xmppStream sendElement:iq];
//}
//
//







#pragma mark - Public

-(void)loginWithaIP:(NSString *)aIP
               port:(NSString *)aPort
           username:(NSString *)aUsername
           password:(NSString *)aPassword
         enableLDAP:(BOOL)aEnableLDAP
          completed:(XMPPManagerLoginBlock)aXMPPManagerLoginBlock {

    _ip = aIP;
    _port = aPort;
    _username = aUsername;
    _password = aPassword;
    _aXMPPManagerLoginBlock = aXMPPManagerLoginBlock;
    XMPPJID *jid = [XMPPJID jidWithUser:aUsername domain:aIP resource:@"IphoneIM"];

    //江海@auth-server/IphoneIM
    [_xmppStream setMyJID:jid];
    _xmppStream.hostName = aIP;
    _xmppStream.hostPort = [aPort integerValue];
    if ( [_xmppStream isConnected] || [_xmppStream isConnecting]) {
        [_xmppStream disconnect];
    }

    NSError *error = nil;
    BOOL ret = [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if ( !ret ) {
        if ( _aXMPPManagerLoginBlock ) {
            LTError *error = [LTError errorWithDescription:@"连接错误" code:(LTErrorLogin_connectFailure)];
            _aXMPPManagerLoginBlock(nil, error);
        }
    }
}




////  发送在线状态
//- (void)online {
//    XMPPPresence *presence = [XMPPPresence presenceWithType:kStringXMPPPresenceAvailable];
//    [presence addAttributeWithName:kStringXMPPFrom stringValue:[[_xmppStream myJID] full]];
//    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceShow stringValue:@""]];
//    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceStatus stringValue:@"在线"]];
//    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresencePriority stringValue:@"0"]];
//    [_xmppStream sendElement:presence];
//}
////  发送忙碌状态
////- (void)busy {
////    XMPPPresence *presence = [XMPPPresence presenceWithType:kStringXMPPPresenceAvailable];
////    [presence addAttributeWithName:kStringXMPPFrom stringValue:[[_xmppStream myJID] full]];
////    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceStatus stringValue:@"马上回来，请稍等！"]];
////    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceShow stringValue:kStringXMPPPresenceShowAway]];
////    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresencePriority stringValue:@"0"]];
////    [_xmppStream sendElement:presence];
////}
//// 驻留，进入后台
//- (void)reside {
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"reside"];
//    [presence addAttributeWithName:kStringXMPPPresenceShow stringValue:kStringXMPPPresenceShowAwayForALongTime];
//    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceStatus stringValue:@"进入后台"]];
//    [_xmppStream sendElement:presence];
//}
//// 清理
//- (void)clear {
//     XMPPManager.shareXMPPManager.xmppStream.myJID = nil;
//     XMPPManager.shareXMPPManager.xmppManagerReconnetDelegate = nil;
//     XMPPManager.shareXMPPManager.msgReceiverdelegate = nil;
//     XMPPManager.shareXMPPManager.delegate = nil;
//    [XMPPManager.shareXMPPManager.xmppStream disconnect];
//    [XMPPManager.shareXMPPManager.rosterPresence removeAllObjects];
//    [XMPPManager.shareXMPPManager.rosterHeadPicture removeAllObjects];
//    [XMPPManager.shareXMPPManager.photoHashtimer invalidate];
//     XMPPManager.shareXMPPManager.photoHashtimer = nil;
//}
//// 申请下线
//- (void)offline {
//    XMPPPresence *presence = [XMPPPresence presenceWithType:kStringXMPPPresenceUnavailable];
//    [presence addAttributeWithName:kStringXMPPPresenceShow stringValue:kStringXMPPPresenceShowAwayForALongTime];
//    [presence addChild:[NSXMLElement elementWithName:kStringXMPPPresenceStatus stringValue:@"离线"]];
//    [_xmppStream sendElement:presence];
//}
//// 获取当前网络时间
//- (long long)getServerCurrentTimestamp {
//    NSTimeInterval timestap = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] - _timeOffset_localLeadToServer;
//    return (long long)(timestap * 1000 + 1);
//}
//
//


#pragma mark - Private
//  发送授权 iq
- (void)sendAuthIqWithUserName:(NSString *)name
                      password:(NSString *)password
                      serverIP:(NSString *)serverIP
                    enableLDAP:(BOOL)enableLDAP {

    NSString *stringClientVer = [AppManager applicationVersion];
    NSString *stringSession_ID = [AppManager get_128Bytes_UUID];
    NSString *stringClient_IP = [AppManager deviceIPAdress];
    NSString *stringSystemVer = [AppManager getIOSVersion];
    NSString const* encodeString = @"testing123";

    NSXMLElement *loginname = [NSXMLElement elementWithName:@"loginname" stringValue:name];
    NSXMLElement *username = [NSXMLElement elementWithName:@"username" stringValue:name];
    NSXMLElement *ClientVer = [NSXMLElement elementWithName:@"ClientVer" stringValue:stringClientVer];
    NSXMLElement *SystemVer = [NSXMLElement elementWithName:@"SystemVer" stringValue:stringSystemVer];
    NSXMLElement *Session_ID = [NSXMLElement elementWithName:@"Session_ID" stringValue:stringSession_ID];
    NSXMLElement *Client_IP = [NSXMLElement elementWithName:@"Client_IP" stringValue:stringClient_IP];
    NSXMLElement *server = [NSXMLElement elementWithName:@"server" stringValue:serverIP];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:access:auth"];



    [query addChild:username];
    [query addChild:ClientVer];
    [query addChild:SystemVer];
    [query addChild:Session_ID];
    [query addChild:Client_IP];
    [query addChild:server];

    // FIXME:Digest
    {// LDAP
        NSString *stringDigest = nil;
        NSString *sid = nil;
        if ( YES == enableLDAP )
        {
            NSString *loginNameUTF8 = [name UTF8Encode];
            sid = [[_xmppStream.rootElement attributeForName:@"id"] stringValue];
            stringDigest = [[NSString stringWithFormat:@"%@%@%@",loginNameUTF8,sid,encodeString] md5];
            NSXMLElement *ticketmode = [NSXMLElement elementWithName:@"ticketmode" stringValue:@"1"];
            [query addChild:ticketmode];
        }
        else
        {
            stringDigest = [[NSString stringWithFormat:@"%@%@",password,encodeString] md5];
        }
        NSXMLElement *digest = [NSXMLElement elementWithName:@"digest" stringValue:stringDigest];
        if (sid)
        {
            [digest addAttributeWithName:@"sid" stringValue:sid];
        }
        [query addChild:digest];
    }

    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addChild:query];

    NSLog(@"%@",_xmppStream.myJID);
    [_xmppStream sendElement:iq];
}







//
//
//
////  登陆，第二次连接
//- (void)loginWithJID:(NSString *)JID
//            password:(NSString *)password
//            resource:(NSString *)resource {
//
//    _isRegister = NO;
//    _userModel.password = password;
//    _userModel.JID = JID;
//    _userModel.serverIP = _xmppStream.hostName;
//    XMPPJID *jid = [XMPPJID jidWithString:JID resource:resource];
//    [_xmppStream setMyJID:jid];
//
//    //江海@duowin-server/IphoneIM
//    // 如果已经连接了服务器，则先断开连接
//    if ( [_xmppStream isConnected] || [_xmppStream isConnecting]) {
//        [_xmppStream disconnect];
//    }
//    NSError *error = nil;
//    BOOL ret = [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
//    if ( !ret ) {
//        //[SVProgressHUD showErrorWithStatus:@"登录失败0042" withDelay:1];
//        if ( _completeBlock ) {
//            _completeBlock( nil, error);
//        }
//    }
//
//}
//
//
//
//
////上传头像
//- (void)uploadHeadImageByJid:(NSString *)myJid withPhotoHash:(NSString *)photoHash
//{
//    NSRange rangeName = [photoHash rangeOfString:@".jpg"];
//    NSString *rangePhotoHash = [photoHash substringToIndex:rangeName.location];
//    XMPPJID *to = [XMPPJID jidWithString:myJid];
//    XMPPIQ *iq = [XMPPIQ iqWithType:@"set" to:to elementID:kStringXMPPElementIDGetPhotoHash];
//    NSXMLElement *vCard = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
//    //[vCard addAttributeWithName:@"ver" intValue:0];
//    NSXMLElement *PHOTOHASH = [NSXMLElement elementWithName:@"PHOTOHASH" stringValue:rangePhotoHash];
//
//    [vCard addChild:PHOTOHASH];
//    NSXMLElement *PHOTO = [NSXMLElement elementWithName:@"PHOTO"];
//    NSXMLElement *TYPE = [NSXMLElement elementWithName:@"TYPE" stringValue:@"image/jpeg"];
//    NSXMLElement *BINVAL = [NSXMLElement elementWithName:@"BINVAL"];
//    [PHOTO addChild:TYPE];
//    [PHOTO addChild:BINVAL];
//    [vCard addChild:PHOTO];
//    [iq addChild:vCard];
//
//    [[XMPPManager shareXMPPManager].xmppStream sendElement:iq];
//}
//
//
//
//#pragma mark - 发送消息
//- (Message *)asyncSendMessage:(Message *)message progress:(id)progress {
//    NSLog(@"发送消息: %s",__func__);
//    return [MessageXMLManager sendMessage:message progress:progress];
//}
//- (void)setUserFriends:(NSArray *)items {
//    [UserManager shareInstance].currentUser.friends = items;
//}
//
//
//
//
//
//





@end
