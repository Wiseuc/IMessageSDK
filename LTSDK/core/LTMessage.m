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


-(NSDictionary *)asyncSendMessageWithMyJID:(NSString *)aMyJID
                                  otherJID:(NSString *)aOtherJID
                                      body:(NSString *)aBody
                                  chatType:(NSString *)aChatType {
    
    return [LTXMPPManager.share sendMessageWithMyJID:aMyJID
                                            otherJID:aOtherJID
                                                body:aBody
                                            chatType:aChatType];
}
@end
