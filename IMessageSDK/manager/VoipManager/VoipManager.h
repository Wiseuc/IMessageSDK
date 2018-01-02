//
//  VoipManager.h
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^VoipManager_settingVoipBlock)(NSError *error);


@interface VoipManager : NSObject


/*!
 @method
 @abstract 初始化
 @result  登陆管理类
 */
+ (instancetype)share;


-(void)updateVoip:(NSString *)ret;
- (NSString *)queryVoip;
- (void)deleteVoip;
    
    
-(void)updatePID:(NSString *)ret;
- (NSString *)queryPID;
- (void)deletePID;
    






/*!
 @method
 @abstract 向sip服务器传递相关参数
 @discussion <#备注#>
 */
-(void)settingParametersToServer;








@end
