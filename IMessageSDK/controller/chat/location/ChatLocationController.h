//
//  ChatLocationController.h
//  IMessageSDK
//
//  Created by JH on 2018/1/13.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatLocationModel.h"
typedef void(^ChatLocationControllerBlock)(ChatLocationModel *model);

@interface ChatLocationController : UIViewController


@property (nonatomic, strong) ChatLocationControllerBlock aChatLocationControllerBlock;

@end
