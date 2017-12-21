//
//  LTXMPPManager.m
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
#import "LTXMPPManager+iq.h"
#import "LTXMPPManager+presence.h"
#import "LTXMPPManager+friend.h"
#import "LTXMPPManager+group.h"
#import "LTXMPPManager+message.h"



@interface LTXMPPManager ()<XMPPStreamDelegate>

@end





@implementation LTXMPPManager

#pragma mark - Public
/**使用auth-server连接服务器，获取真实用户登录信息**/
-(void)loginWithaIP:(NSString *)aIP
               port:(NSString *)aPort
           username:(NSString *)aUsername
           password:(NSString *)aPassword
         enableLDAP:(BOOL)aEnableLDAP
          completed:(LTXMPPManagerLoginBlock)aXMPPManagerLoginBlock {
    
    _ip = aIP;
    _port = aPort;
    _username = aUsername;
    _password = aPassword;
    _aXMPPManagerLoginBlock = aXMPPManagerLoginBlock;
    
    //江海@auth-server/IphoneIM
    XMPPJID *jid = [XMPPJID jidWithUser:aUsername
                                 domain:@"auth-server"
                               resource:@"IphoneIM"];
    [self.aXMPPStream setMyJID:jid];
    self.aXMPPStream.hostName = aIP;
    self.aXMPPStream.hostPort = [aPort integerValue];
    [self connect];
}

/**接收到授权iq后，使用返回的真实信息重连服务器**/
- (void)loginAgainWithJID:(NSString *)aJID
                 password:(NSString *)aPassword
                 resource:(NSString *)aResource {

    //江海@duowin-server/IphoneIM
    XMPPJID *jid = [XMPPJID jidWithString:aJID resource:aResource];
    [self.aXMPPStream setMyJID:jid];
    [self connect];
}

/**验证密码**/
-(void)loginAuthWithPassword:(NSString *)aPassword {
    [self.aXMPPStream authenticateWithPassword:aPassword error:nil];
}


#pragma mark - Private

/**连接服务器**/
- (void)connect {
    //江海@duowin-server/IphoneIM
    // 如果已经连接了服务器，则先断开连接
    if ( [self.aXMPPStream isConnected] ||
        [self.aXMPPStream isConnecting])
    {
        [self.aXMPPStream disconnect];
    }
    NSError *error = nil;
    BOOL ret =
    [self.aXMPPStream
     connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (!ret) {
        if ( _aXMPPManagerLoginBlock ) {
            LTError *error =
            [LTError errorWithDescription:@"连接失败" code:(LTErrorLogin_connectFailure)];
            _aXMPPManagerLoginBlock(error);
        }
    }
}

/**获取时间戳**/
- (long long)queryServerTimeStamp {
    NSTimeInterval timestap =
    [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] - self.timeOffset_localAndServer;
    return (long long)(timestap * 1000 + 1);
}












#pragma mark - 代理 connect

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    [self.aXMPPStream setIsSecure:YES];
}
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
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"连接服务器被拒");
//    LTError *error2 = [LTError errorWithDescription:@"连接服务器被拒" code:(LTErrorLogin_connectRefused)];
//    if ( _aXMPPManagerLoginBlock) {
//        _aXMPPManagerLoginBlock(error2);
//    }
}





#pragma mark - 代理：secure

- (void)xmppStream:(XMPPStream *)sender
willSecureWithSettings:(NSMutableDictionary *)settings{
    settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
}
- (void)xmppStream:(XMPPStream *)sender
   didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler{
    completionHandler(YES);
}
- (void)xmppStreamDidSecure:(XMPPStream *)sender{
    NSLog(@"通过了 SSL/TLS 的安全验证");
}



#pragma mark - 代理：Auth

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    /**发送在线**/
    [self sendPresenceAvailable];
    
    /**请求服务器时间**/
    [self sendRequestServerTimeIq];
    
    
    
    
    if (_aXMPPManagerLoginBlock) {
        _aXMPPManagerLoginBlock(nil);
    }
}

- (void)xmppStream:(XMPPStream *)sender
didNotAuthenticate:(DDXMLElement *)error {
    
    //NSError *myError =
    [NSError errorWithDomain:error.description code:-1
                    userInfo:nil];
    if (_aXMPPManagerLoginBlock) {
        LTError *error =
        [LTError errorWithDescription:@"授权失败"
                                 code:(LTErrorLogin_loginGeneralFailure)];
        _aXMPPManagerLoginBlock(error);
    }
}









#pragma mark - Init

+(instancetype)share {
    static LTXMPPManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTXMPPManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /**XMPPStream**/
        self.aXMPPStream = [[XMPPStream alloc] init];
        self.aXMPPStream.enableBackgroundingOnSocket = YES;
        [self.aXMPPStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.aXMPPStream registerCustomElementNames:[NSSet setWithObject:@"extmsg"]];  // 注册自定义消息
        self.aXMPPStream.startTLSPolicy = XMPPStreamStartTLSPolicyAllowed;
        [self.aXMPPStream setKeepAliveInterval:45-2];  /**心跳激活**/

        /**XMPPRosterCoreDataStorage**/
        
        self.aXMPPRosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc] init];
        self.aXMPPRoster = [[XMPPRoster alloc] initWithRosterStorage:self.aXMPPRosterCoreDataStorage];
        //[self.aXMPPRoster activate:self.aXMPPStream];
        //[self.aXMPPRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];

        
        /**XMPPReconnect**/
        self.aXMPPReconnect = [[XMPPReconnect alloc] init];
        [self.aXMPPReconnect activate:self.aXMPPStream];
        [self.aXMPPReconnect setAutoReconnect:YES];
        
        /**XMPPAutoPing**/
//        self.aXMPPAutoPing = [[XMPPAutoPing alloc] init];
//        self.aXMPPAutoPing.pingInterval = 20.f;
//        [self.aXMPPAutoPing activate:self.aXMPPStream];
//        [self.aXMPPAutoPing addDelegate:self
//                          delegateQueue:dispatch_get_main_queue()];

        
        /**
         非常重要：使得静态库中的Category可用，。
         详见：http://blog.csdn.net/wiseuc_jianghai/article/details/78795440
         
         //
         void runCategoryForFramework();
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
        runCategoryForFramework33();
        runCategoryForFramework34();
        runCategoryForFramework35();
        runCategoryForFramework36();
        runCategoryForFramework37();
        runCategoryForFramework38();
        runCategoryForFramework39();
        runCategoryForFramework40();
        
        
        
        runCategoryForFramework41();
        runCategoryForFramework42();
//        runCategoryForFramework43();
//        runCategoryForFramework44();
//        runCategoryForFramework45();
//        runCategoryForFramework36();
//        runCategoryForFramework37();
//        runCategoryForFramework38();
//        runCategoryForFramework39();
//        runCategoryForFramework40();
        
        
        
        /**DDLog**/
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        //江海大师：集成这里时遇到bug，解决：在客户端侧，将我的集成文档好好看看，配置完整
    }
    return self;
}


@end
