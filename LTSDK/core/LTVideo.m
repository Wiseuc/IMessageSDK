//
//  LTVideo.m
//  LTSDK
//
//  Created by JH on 2017/12/29.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTVideo.h"
#import "LinphoneManager.h"
@implementation LTVideo

+ (instancetype)share {
    static LTVideo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTVideo alloc] init];
    });
    return instance;
}





-(void)settingPushKitManagerWithAPNsToken:(NSString *)apns
                                VoIPToken:(NSString *)voip
                                 platform:(NSNumber *)platform
                                 serverip:(NSString *)serverip
                               serverPort:(NSString *)serverPort
                                 voipPort:(NSString *)voipport
                                accountID:(NSString *)accountID

                                 username:(NSString *)username
                                 password:(NSString *)password
                       registerIdentifies:(NSString *)registerIdentifies
                    registerJIDIdentifies:(NSString *)jid
                                transport:(NSString *)transport
                                chatterVC:(UIViewController *)chatterController
                                   mainVC:(UIViewController *)mainController
                                completed:(LTVideo_SettingPushKitBlock)block
{
    [LinphoneManager.share settingPushKitManagerWithAPNsToken:apns
                                                    VoIPToken:voip
                                                     platform:platform
                                                     serverip:serverip
                                                   serverPort:serverPort
     
                                                     voipPort:voipport
                                                    accountID:accountID
                                                     username:username
                                                     password:password
                                           registerIdentifies:registerIdentifies
     
                                        registerJIDIdentifies:jid
                                                    transport:transport
                                                    chatterVC:chatterController
                                                       mainVC:mainController
                                                    completed:^(NSDictionary *dict, LTError *error) {
                                                        if (block) {
                                                            block(dict,error);
                                                        }
                                                    }];
}



@end
