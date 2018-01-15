//
//  ChatFilePreviewController.h
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface ChatFilePreviewController : UIViewController


@property (nonatomic, strong) Message *message;

- (instancetype)initWithMessage:(Message *)message;



@end
