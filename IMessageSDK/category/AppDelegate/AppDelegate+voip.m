//
//  AppDelegate+voip.m
//  IMessageSDK
//
//  Created by JH on 2018/1/2.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AppDelegate+voip.h"
#import <PushKit/PushKit.h>

@interface AppDelegate ()
<
PKPushRegistryDelegate
>
@end




@implementation AppDelegate (voip)



-(void)settingVoip:(AppDelegate_voip_settingVoipBlock)aBlock
{
    self.voip_settingVoipBlock = aBlock;
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    PKPushRegistry * voipRegistry = [[PKPushRegistry alloc] initWithQueue: mainQueue];
    voipRegistry.delegate = self;
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

//获取voipToken
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *voipTokenStr = [str2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"注册Voip推送成功:voip = %@",voipTokenStr);
    if (self.voip_settingVoipBlock) {
        self.voip_settingVoipBlock(voipTokenStr, nil);
    }
}
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type {
    // 收到推送来电
    // 呼出系统接听界面
    // 或者生成本地推送
    // 这个需要voip推送服务器配合，如同apns
    NSLog(@"收到来电推送");
}

#pragma clang diagnostic pop






@end
