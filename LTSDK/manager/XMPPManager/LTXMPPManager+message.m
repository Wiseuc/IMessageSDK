//
//  LTXMPPManager+message.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager+message.h"
void runCategoryForFramework42(){}




@implementation LTXMPPManager (message)

-(void)sendRequestMessageCompleted:(LTXMPPManager_message_queryMessageBlock)message_queryMessageBlock {
    self.message_queryMessageBlock = message_queryMessageBlock;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    //dict
    NSDictionary *dict = [LT_MessageAnalysis analysisXMPPMessage:message];
    if (self.message_queryMessageBlock) {
        self.message_queryMessageBlock(dict);
    }
    
}






@end
