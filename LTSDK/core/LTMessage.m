//
//  LTMessage.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTMessage.h"
#import "LTXMPPManager+message.h"
@interface LTMessage ()
@property (nonatomic, strong) LTMessage_queryMessageBlock queryMessageBlock;
@end




@implementation LTMessage

+ (instancetype)share {
    static LTMessage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTMessage alloc] init];
    });
    return instance;
}



-(void)queryMesageCompleted:(LTMessage_queryMessageBlock)aBlock {
    _queryMessageBlock = aBlock;
    
    __weak typeof(self) weakself = self;
    [LTXMPPManager.share sendRequestMessageCompleted:^(NSDictionary *dict) {
        if (weakself.queryMessageBlock) {
            weakself.queryMessageBlock(dict);
        }
    }];
    
    
}




-(NSDictionary *)sendMessageWithSenderJID:(NSString *)aSenderJID
                                 otherJID:(NSString *)aOtherJID
                                     body:(NSString *)aBody
{
    return [LTXMPPManager.share sendMessageWithSenderJID:aSenderJID
                                                otherJID:aOtherJID
                                                    body:aBody];
    
}
-(NSDictionary *)sendConferenceMessageWithSenderJID:(NSString *)aSenderJID
                                      conferenceJID:(NSString *)aConferenceJID
                                     conferenceName:(NSString *)aConferenceName
                                               body:(NSString *)aBody
{
    return [LTXMPPManager.share sendConferenceMessageWithSenderJID:aSenderJID
                                                     conferenceJID:aConferenceJID
                                                    conferenceName:aConferenceName
                                                              body:aBody];
}





@end
