//
//  XMPPManager+receipt.h
//  WiseUC
//
//  Created by 吴林峰 on 16/5/25.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager.h"

// 消息回执
@interface XMPPManager (Receipt)

/**
 *  消息回执
 *
 *  @param message 待回执的消息对象
 *
 *  @return 是否回执
 */
+ (BOOL)messageReceipt:(XMPPMessage *)message;


@end
