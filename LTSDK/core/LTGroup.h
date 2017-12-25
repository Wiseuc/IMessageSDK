//
//  LTGroup.h
//  LTSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTError.h"
typedef void(^LTGroup_queryGroupsBlock)(NSMutableArray *groups, LTError *error);
typedef void(^LTGroup_queryGroupVCardBlock)(NSDictionary *dict);

@interface LTGroup : NSObject
@property (nonatomic, strong) LTGroup_queryGroupsBlock queryGroupsBlock;


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 请求群组列表
 @discussion 回调返回群组列表
 */
- (void)queryGroupsCompleted:(LTGroup_queryGroupsBlock)queryGroupsBlock;



/*!
 @method
 @abstract 获取群组VCard
 @discussion 回调返回群组列表
 @param aGroupJID 群组jid
 */
-(void)queryGroupVCardByGroupJID:(NSString *)aGroupJID  completed:(LTGroup_queryGroupVCardBlock)queryGroupVCardBlock;

@end
