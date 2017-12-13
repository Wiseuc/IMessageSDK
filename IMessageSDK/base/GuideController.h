//
//  GuideController.h
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GuideControllerEnterBlock)(BOOL ret);





@interface GuideController : UIViewController
@property (nonatomic, strong) GuideControllerEnterBlock enterBlock;
-(void)setEnterBlock:(GuideControllerEnterBlock)enterBlock;
@end
