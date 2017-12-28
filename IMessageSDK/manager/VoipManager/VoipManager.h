//
//  VoipManager.h
//  IMessageSDK
//
//  Created by JH on 2017/12/28.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoipManager : NSObject


@property (nonatomic, strong) NSString *myPID;

@property (nonatomic, strong) NSString *otherPID;


/*!
 @method
 @abstract 初始化
 @result  登陆管理类
 */
+ (instancetype)share;



-(void)settingVoip;


-(NSString *)queryVoipToken;



@end
