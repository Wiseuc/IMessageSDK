//
//  LTXMPPManager.m
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
#import "XMPPLib.h"
#import "XMPPManager+IQ.h"
#import "AppManager.h"
#import "XMPPStream+secure.h"
#import "Encrypt_Decipher.h"

@interface LTXMPPManager ()<XMPPStreamDelegate>
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

@end





@implementation LTXMPPManager

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
    
    
    
    //江海@auth-server/IphoneIM
    XMPPJID *jid = [XMPPJID jidWithUser:aUsername
                                 domain:aIP
                               resource:@"IphoneIM"];
    [self.aXMPPStream setMyJID:jid];
    self.aXMPPStream.hostName = aIP;
    self.aXMPPStream.hostPort = [aPort integerValue];
    if ( [self.aXMPPStream isConnected] ||
        [self.aXMPPStream isConnecting])
    {
        [self.aXMPPStream disconnect];
    }
    
    NSError *error = nil;
    BOOL ret =
    [self.aXMPPStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if ( !ret ) {
        if ( _aXMPPManagerLoginBlock ) {
            LTError *error =
            [LTError errorWithDescription:@"连接错误" code:(LTErrorLogin_connectFailure)];
            _aXMPPManagerLoginBlock(nil, error);
        }
    }
}







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
            sid = [[self.aXMPPStream.rootElement attributeForName:@"id"] stringValue];
            stringDigest = [[NSString stringWithFormat:@"%@%@%@",loginNameUTF8,sid,encodeString] md5];
            NSXMLElement *ticketmode = [NSXMLElement elementWithName:@"ticketmode" stringValue:@"1"];
            [query addChild:ticketmode];
        }else{
            stringDigest = [[NSString stringWithFormat:@"%@%@",password,encodeString] md5];
        }
        NSXMLElement *digest = [NSXMLElement elementWithName:@"digest" stringValue:stringDigest];
        if (sid){
            [digest addAttributeWithName:@"sid" stringValue:sid];
        }
        [query addChild:digest];
    }
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addChild:query];
    
    NSLog(@"%@",self.aXMPPStream.myJID);
    [self.aXMPPStream sendElement:iq];
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

//- (void)authenticateWith:(BOOL)isHaveDigset
//{
    // [_xmppStream authenticateWithPassword:_userModel.password error:nil];
//}










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
        [self.aXMPPStream setKeepAliveInterval:45-2];  /**系统定时激活**/

        /**XMPPRosterCoreDataStorage**/
        self.aXMPPRosterCoreDataStorage =
        [[XMPPRosterCoreDataStorage alloc] init];
        self.aXMPPRoster =
        [[XMPPRoster alloc] initWithRosterStorage:self.aXMPPRosterCoreDataStorage];
        [self.aXMPPRoster activate:self.aXMPPStream];
        //[self.aXMPPRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];

        /**XMPPReconnect**/
        self.aXMPPReconnect = [[XMPPReconnect alloc] init];
        [self.aXMPPReconnect activate:self.aXMPPStream];
        [self.aXMPPReconnect setAutoReconnect:YES];
        
        /**XMPPAutoPing**/
        self.aXMPPAutoPing = [[XMPPAutoPing alloc] init];
        self.aXMPPAutoPing.pingInterval = 20.f;
        [self.aXMPPAutoPing activate:self.aXMPPStream];
        [self.aXMPPAutoPing addDelegate:self
                          delegateQueue:dispatch_get_main_queue()];

        
        
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
        
        
        
        /**DDLog**/
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        //江海大师：集成这里时遇到bug，解决：在客户端侧，将我的集成文档好好看看，配置完整
    }
    return self;
}


@end
