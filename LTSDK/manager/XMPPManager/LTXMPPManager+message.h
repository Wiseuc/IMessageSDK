//
//  LTXMPPManager+message.h
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
void runCategoryForFramework42();
@interface LTXMPPManager (message)


/**请求好友列表**/
- (void)sendRequestMessageCompleted:(LTXMPPManager_message_queryMessageBlock)message_queryMessageBlock;

@end
