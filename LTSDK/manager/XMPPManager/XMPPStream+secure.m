//
//  XMPPStream+secure.m
//  WiseUC
//
//  Created by JH on 2017/7/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "XMPPStream+secure.h"

@implementation XMPPStream (secure)

#pragma mark
#pragma mark ======================SSL安全设置======================

///*
// 第一步：
// 1.使用5223端口的SSL连接服务器
// 2.设置公钥
// */
//- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
//{
//    //GCD异步套接字手动评估信任
//    settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
//}
///*
//  *注意：如果您的开发服务器正在使用自签名证书，
//  *您可能需要在设置中添加GCDAsyncSocketManuallyEvaluateTrust = YES。
//  *然后实现xmppStream：didReceiveTrust：completionHandler：delegate方法来执行自定义验证。
// */
//- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
//{
//    completionHandler(YES);
//}
//- (void)xmppStreamDidSecure:(XMPPStream *)sender
//{
//    NSLog(@"通过了 SSL/TLS 的安全验证");
//}









@end
