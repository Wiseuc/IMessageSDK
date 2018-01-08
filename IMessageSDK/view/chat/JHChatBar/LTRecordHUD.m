//
//  LTRecordHUD.m
//  IMessageSDK
//
//  Created by JH on 2018/1/4.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "LTRecordHUD.h"
#define WIDTH  UIScreen.mainScreen.bounds.size.width
#define HEIGHT UIScreen.mainScreen.bounds.size.height
//设置颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




@interface LTRecordHUD ()
{
    UIView *_voiceRecordBackView;  /**背景视图**/
    UIView *_volumeViewBackGround;
    
    UIImageView *_macrophoneView;       /**麦克风图像**/
    UIImageView *_recordAnimationView;  /**音量图像**/
    UIImageView *_canleImageView;  /**取消发送图像**/
    
    NSTimer *_timer;  /**定时器**/
    UILabel *_textLabel;  /** 提示文字**/
}
@property (nonatomic, strong) UIView *backView;
@end










@implementation LTRecordHUD

#pragma mark - UI

- (void)settingUI {
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49)];
    [self addSubview:view];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [view addGestureRecognizer:tapG];
    
    
    
    //背景视图
    _voiceRecordBackView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_voiceRecordBackView];
    
    
    //小块容器
    _backView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH-160)/2,(HEIGHT-160)/2,160,160)];
    _backView.layer.cornerRadius = 4.0f;
    _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_voiceRecordBackView addSubview:_backView];
    
    
    _volumeViewBackGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 80)];
    _volumeViewBackGround.center = (CGPoint){_backView.bounds.size.width/2, _backView.bounds.size.height/2 - 20};
    [_backView addSubview:_volumeViewBackGround];
    
    
    
    //麦克风图像🎤
    _macrophoneView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 80)];
    _macrophoneView.image = [UIImage imageNamed:@"chatBar_microphone"];
    [_volumeViewBackGround addSubview:_macrophoneView];
    
    //音量
    _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 35, 80)];
    _recordAnimationView.image = [UIImage imageNamed:@"chatBar_volume1"];
    [_volumeViewBackGround addSubview:_recordAnimationView];
    
    
    //取消发送图像
    _canleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
    _canleImageView.center = (CGPoint){_backView.bounds.size.width/2, _backView.bounds.size.height/2 - 20};
    _canleImageView.image = [UIImage imageNamed:@"chatBar_prepareToCancel"];
    _canleImageView.hidden = YES;
    [_backView addSubview:_canleImageView];
    
    
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 140, 25)];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"按住 说话";
    _textLabel.font = [UIFont boldSystemFontOfSize:14];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.layer.cornerRadius = 5;
    _textLabel.layer.masksToBounds = YES;
    [_backView addSubview:_textLabel];
}
/**隐藏backView**/
-(void)hiddenBackView:(BOOL)isHidden {
    _backView.hidden = isHidden;
}
/**
 音量
 **/
-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:@"chatBar_volume1"];
    double voiceSound = 0;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    if (0 < voiceSound <= 0.1) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume1"]];
    }else if (0.1<voiceSound<=0.2) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume2"]];
    }else if (0.2<voiceSound<=0.3) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume3"]];
    }else if (0.3<voiceSound<=0.4) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume4"]];
    }else if (0.4<voiceSound<=0.5) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume5"]];
    }else if (0.5<voiceSound<=0.6) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume6"]];
    }else if (0.6<voiceSound<=0.7) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume7"]];
    }else if (0.7<voiceSound<=0.8) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume8"]];
    }else if (0.8<voiceSound<=1.0) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"chatBar_volume9"]];
    }
    
    //NSLog(@"chatBar_volume7b变化");
}













#pragma mark - Private

// 录音按钮按下
-(void)recordButtonTouchDown
{
    // 需要根据声音大小切换recordView动画
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
    _backView.hidden = NO;
    
    _textLabel.text = @"手指上滑，取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
    _recordAnimationView.hidden = NO;
    _macrophoneView.hidden = NO;
    _canleImageView.hidden = YES;
    
}



// 手指在按钮内部时离开
-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
    _timer = nil;
    
    _backView.hidden = YES;
}

// 手指在按钮外部时离开
-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
    _timer = nil;
    
    _backView.hidden = YES;
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    _textLabel.text = @"手指上滑，取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
    _recordAnimationView.hidden = NO;
    _macrophoneView.hidden = NO;
    _canleImageView.hidden = YES;
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    _textLabel.text = @"松开手指，取消发送";
    _textLabel.backgroundColor = HEXCOLOR(0xa52a2a);
    _macrophoneView.hidden = YES;
    _recordAnimationView.hidden = YES;
    _canleImageView.hidden = NO;
}
// 录音错误提示
- (void)recordError:(NSString *)error
{
    [_timer invalidate];
    _timer = nil;
    
    _textLabel.text = error;
    _textLabel.backgroundColor = HEXCOLOR(0xa52a2a);
    _macrophoneView.hidden = YES;
    _recordAnimationView.hidden = YES;
    _canleImageView.hidden = NO;
    _canleImageView.image = [UIImage imageNamed:@"chatBar_warning"];
    
    self.hidden = NO;
    _backView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _macrophoneView.hidden = NO;
        _recordAnimationView.hidden = NO;
        _canleImageView.hidden = YES;
        _canleImageView.image = [UIImage imageNamed:@"chatBar_prepareToCancel"];
        
        _backView.hidden = YES;
    });
}













#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.layer.cornerRadius = 5;
        [self settingUI];
    }
    return self;
}
-(void)back {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)destory{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self destoryTimer];
        
        [self removeFromSuperview];
    }];
}
/**销毁timer**/
-(void)destoryTimer {
    [_timer invalidate];
    _timer = nil;
}

@end
