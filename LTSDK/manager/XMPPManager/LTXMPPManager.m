//
//  LTXMPPManager.m
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
#import "LTXMPPManager+iq.h"

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
//    // 申请上线
//    [self online];
//
//    // 获取服务器时间
//    [self getServerTime];

    NSLog(@"登录授权成功");
    _aXMPPManagerLoginBlock(nil);
}
//获取授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    //  登陆失败
    NSError *myError = [NSError errorWithDomain:error.description code:-1 userInfo:nil];
    
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
//        runCategoryForFramework32();
//        runCategoryForFramework33();
//        runCategoryForFramework34();
//        runCategoryForFramework35();
        
        
        
        /**DDLog**/
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        //江海大师：集成这里时遇到bug，解决：在客户端侧，将我的集成文档好好看看，配置完整
    }
    return self;
}


@end
