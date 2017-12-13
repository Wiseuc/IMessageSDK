//
//  LTXMPPManager.h
//  LTSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
typedef void(^XMPPManagerLoginBlock) (id response, LTError *error);



@interface LTXMPPManager : NSObject
@property (nonatomic, strong) XMPPManagerLoginBlock aXMPPManagerLoginBlock;



/*!
 @method
 @abstract 初始化
 @discussion null
 @result  ..
 */
+ (instancetype)share;


/*!
 @method
 @abstract 登录操作
 @discussion null
 @param aIP ip
 @param aPort 端口
 @param aUsername 用户名
 @param aPassword 密码
 */
- (void)loginWithaIP:(NSString *)aIP
                port:(NSString *)aPort
            username:(NSString *)aUsername
            password:(NSString *)aPassword
          enableLDAP:(BOOL)aEnableLDAP
           completed:(XMPPManagerLoginBlock)aXMPPManagerLoginBlock;
@end
