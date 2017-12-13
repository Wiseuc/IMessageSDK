//
//  LTXMPPManager.m
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
#import "XMPPLib.h"

@interface LTXMPPManager ()
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
        [self.aXMPPStream setKeepAliveInterval:45-2];  /**系统定时激活**/

//        /**XMPPRosterCoreDataStorage**/
//        self.aXMPPRosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc] init];
//        self.aXMPPRoster = [[XMPPRoster alloc] initWithRosterStorage:self.aXMPPRosterCoreDataStorage];
//        [self.aXMPPRoster activate:self.aXMPPStream];
//
//        /**XMPPReconnect**/
//        self.aXMPPReconnect = [[XMPPReconnect alloc] init];
//        [self.aXMPPReconnect activate:self.aXMPPStream];
//
//        /**XMPPAutoPing**/
//        self.aXMPPAutoPing = [[XMPPAutoPing alloc] init];
//        self.aXMPPAutoPing.pingInterval = 20.f;
//        [self.aXMPPAutoPing activate:self.aXMPPStream];
//        [self.aXMPPAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
//
//        /**DDLog**/
//        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
    return self;
}


@end
