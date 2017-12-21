//
//  LT_MessageAnalysis.h
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTXMPPManager.h"

@interface LT_MessageAnalysis : NSObject


/*!
 @method
 @abstract 消息分析
 @discussion 对接收到的消息进行类型分析
 @result  message
 */
+ (NSDictionary *)analysisXMPPMessage:(XMPPMessage *)xmlMessage;






@end
