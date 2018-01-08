//
//  LXChatBox.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

/**
 键盘使用方法
 
 
 1.VC 遵守LXChatBoxDelegate代理
 2.VC 添加LXChatBox
 3.LXChatBox代理方法
     键盘状态改变，调整键盘高度： -(void)changeStatusChat:(CGFloat)chatBoxY;
     发送出来的信息（表情和文本）：-(void)chatBoxSendTextMessage:(NSString *)message;
 4.LXChatBoxMoreView代理方法
     点击更多中的按钮（照片、视频、文件）：
     - (void)chatBoxMoreView:(LXChatBoxMoreView *)chatBoxMoreView didSelectItem:(LXChatBoxItem)itemType;
 **/


#import <UIKit/UIKit.h>
#import "LXEmotionManager.h"
#import "LXChatBoxFaceView.h"
#import "LXChatBoxMoreView.h"
@class LXChatBox;
@protocol LTChatBoxDelegate;



typedef NS_ENUM(NSInteger, LTChatBoxStatus) {
    LTChatBoxStatusNothing,     // 默认状态
    LTChatBoxStatusShowVoLXe,   // 录音状态
    LTChatBoxStatusShowFace,    // 输入表情状态
    LTChatBoxStatusShowMore,    // 显示“更多”页面状态
    LTChatBoxStatusShowKeyboard,// 正常键盘
    LTChatBoxStatusShowVideo    // 录制视频
};








@interface LXChatBox : UIView

@property(nonatomic,assign)LTChatBoxStatus status;
@property(nonatomic,assign)BOOL isDisappear;
@property(nonatomic,assign)NSInteger maxVisibleLine;
@property(nonatomic,weak)id<LTChatBoxDelegate>delegate;

@end









@protocol LTChatBoxDelegate <NSObject>


/*!
 @method
 @abstract  代理：键盘高度变化
 @discussion <#备注#>
 @param chatBoxY 返回推荐的键盘高度
 */
-(void)changeStatusChat:(CGFloat)chatBoxY;


/*!
 @method
 @abstract 选择more第几个item
 @discussion 如照片、文件、位置等
 @param itemType 返回点击的item（enum）
 */
- (void)chatBox:(LXChatBox *)chatBox
  didSelectItem:(LXChatBoxItem)itemType;


/*!
 @method
 @abstract 发送文本信息
 @discussion <#备注#>
 @param message 信息
 */
//-(void)chatBoxSendTextMessage:(NSString *)message;
- (void)chatBox:(LXChatBox *)chatBox
      sendText:(NSString *)text;


/*!
 @method
 @abstract 发送语音信息
 @discussion <#备注#>
 @param chatBox chatBox
 @param voiceLocalPath 音频本地路径
 @param duration 时长
 */
- (void)chatBox:(LXChatBox *)chatBox
      sendVoice:(NSString *)voiceLocalPath
        seconds:(NSInteger)duration;



@end
