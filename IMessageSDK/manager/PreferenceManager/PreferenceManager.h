//
//  PreferenceManager.h
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferenceManager : NSObject


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 更新声音状态
 @discussion 备注
 @param ret 布尔值
 */
- (void)updatePreference_voice:(BOOL)ret ;
- (BOOL)queryPreference_voice;



/*!
 @method
 @abstract 更新震动状态
 @discussion <#备注#>
 @param ret 布尔值
 */
- (void)updatePreference_virate:(BOOL)ret;
- (BOOL)queryPreference_virate;
    
    
@end
