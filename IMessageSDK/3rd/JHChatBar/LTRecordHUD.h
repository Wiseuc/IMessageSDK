//
//  LTRecordHUD.h
//  IMessageSDK
//
//  Created by JH on 2018/1/4.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCDDeviceManager.h"
#import "EMAudioRecorderUtil.h"
@interface LTRecordHUD : UIView

/**是否隐藏背景视图**/
-(void)hiddenBackView:(BOOL)isHidden;
-(void)destory;

// 录音按钮按下
-(void)recordButtonTouchDown;
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside;
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside;
// 手指移动到录音按钮内部
-(void)recordButtonDragInside;
// 手指移动到录音按钮外部
-(void)recordButtonDragOutside;

// 录音错误提示
- (void)recordError:(NSString *)error;


@end
