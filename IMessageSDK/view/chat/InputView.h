//
//  InputView.h
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    InputViewActionType_sendMessage = 100,
    InputViewActionType_voiceNormal,
    InputViewActionType_voiceSelect,
    InputViewActionType_faceNormal,
    InputViewActionType_faceSelect,
    InputViewActionType_moreNormal,
    InputViewActionType_moreSelect,
} InputViewActionType;



typedef void(^InputViewBlock)(InputViewActionType actionType,NSString *message);



@interface InputView : UIView

-(void)startInputView:(InputViewBlock)aInputViewBlock;

@end
