//
//  ChatFileController
//  IMessageSDK
//
//  Created by JH on 2018/1/10.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

typedef void(^ChatFileControllerSelectBlock)(Message *model);

@interface ChatFileController : UIViewController

-(void)settingChatFileControllerSelect:(ChatFileControllerSelectBlock)aBlock;

@end
