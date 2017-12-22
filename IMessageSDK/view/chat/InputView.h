//
//  InputView.h
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^InputViewBlock)(NSString *message);


@interface InputView : UIView

-(void)startInputView:(InputViewBlock)aInputViewBlock;

@end
