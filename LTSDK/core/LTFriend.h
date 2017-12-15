//
//  LTFriend.h
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTError.h"
typedef void(^LTFriend_queryRostersBlock)(NSMutableArray *rosters, LTError *error);




@interface LTFriend : NSObject
@property (nonatomic, strong) LTFriend_queryRostersBlock queryRostersBlock;


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 请求好友列表
 @discussion null
 @result  回调返回好友列表
 */
- (void)queryRostersCompleted:(LTFriend_queryRostersBlock)queryRostersBlock;


@end
