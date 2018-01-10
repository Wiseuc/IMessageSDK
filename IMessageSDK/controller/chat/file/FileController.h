//
//  FileController.h
//  IMessageSDK
//
//  Created by JH on 2018/1/10.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

typedef void(^FileControllerSelectBlock)(Message *model);

@interface FileController : UIViewController

-(void)settingFileControllerSelect:(FileControllerSelectBlock)aBlock;

@end
