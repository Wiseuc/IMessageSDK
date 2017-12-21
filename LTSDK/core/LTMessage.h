//
//  LTMessage.h
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTError.h"
typedef void(^LTMessage_queryMessageBlock)(NSDictionary *dict);


@interface LTMessage : NSObject
/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 请求消息
 @discussion 回调返回消息
 */
- (void)queryMesageCompleted:(LTMessage_queryMessageBlock)aBlock;
@end
