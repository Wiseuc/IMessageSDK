//
//  ApnsManager.h
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApnsManager : NSObject

/*!
 @method
 @abstract 初始化
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 获取apnaToken
 @discussion <#备注#>
 @result  <#描述4#>
 */
-(NSString *)queryApnsToken;



-(void)settingApns;




@end
