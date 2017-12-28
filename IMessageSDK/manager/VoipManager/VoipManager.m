//
//  VoipManager.m
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "VoipManager.h"
#import <PushKit/PushKit.h>



@interface VoipManager ()
<
PKPushRegistryDelegate
>

/*!
 @property
 @abstract VoIPToken
 */
@property (nonatomic, strong) NSString  *voipToken;  //
@end



@implementation VoipManager


+ (instancetype)share {
    static VoipManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VoipManager alloc] init];
    });
    return instance;
}


-(void)settingVoip {
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
    self.voipToken = voipTokenStr;
    
    NSLog(@"注册Voip推送成功:voip = %@",voipTokenStr);
}
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type {
    // 收到推送来电
    // 呼出系统接听界面
    // 或者生成本地推送
    // 这个需要voip推送服务器配合，如同apns
    NSLog(@"收到来电推送");
}

#pragma clang diagnostic pop






-(NSString *)queryVoipToken {
    return self.voipToken;
}

@end
