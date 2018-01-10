//
//  ChatVoiceCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatVoiceCell.h"
#import "UIConfig.h"
#import "JHLabel.h"

@interface ChatVoiceCell ()


@property (nonatomic, strong) ChatVoiceCellTapBlock aChatVoiceCellTapBlock;

@property (nonatomic, strong) UIImageView *iconIMGV;  /**头像**/
@property (nonatomic, strong) JHLabel *messageLAB;  /**消息**/
@property (nonatomic, strong) UIImageView *playStateIMGV;  /**播放状态**/
//@property (nonatomic, strong) UIImageView *backgroundIMGV;  /**背景**/
@property (nonatomic, strong) UILabel *timeLAB;  /**时间**/
@property (nonatomic, strong) UILabel *durationLAB;  /**时长**/


@property (assign, nonatomic) BOOL isVoicePlaying; /**是否正在播放中**/
@end





@implementation ChatVoiceCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = kBackgroundColor;
        //        self.timeLAB = [[UILabel alloc] init];
        //        [self.contentView addSubview:self.timeLAB];
        //        self.timeLAB.text = @"2017-33-30 12:23:25";
        //        self.timeLAB.textAlignment = NSTextAlignmentCenter;
        //        self.timeLAB.font = [UIFont systemFontOfSize:10.0];
        //        self.timeLAB.textColor = [UIColor whiteColor];
        //        self.timeLAB.backgroundColor = [UIColor lightGrayColor];
        //        self.timeLAB.layer.cornerRadius = 4.0;
        //        self.timeLAB.layer.masksToBounds = YES;
        //self.timeLAB.textInsets = UIEdgeInsetsMake(0,5,0,5); // 设置左内边距
        
        
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
        self.iconIMGV.layer.cornerRadius = 4;
        self.iconIMGV.layer.masksToBounds = YES;
        
        
        
        self.messageLAB = [[JHLabel alloc] init];
        [self.contentView addSubview:self.messageLAB];
        //self.messageLAB.text = @"语音";
        self.messageLAB.font = [UIFont systemFontOfSize:15.0];
        self.messageLAB.numberOfLines = 0;
        self.messageLAB.backgroundColor = [kTintColor colorWithAlphaComponent:0.5];
        self.messageLAB.layer.cornerRadius = 4.0;
        self.messageLAB.layer.masksToBounds = YES;
        self.messageLAB.textInsets = UIEdgeInsetsMake(5,5,5,5); // 设置左内边距,撑大控件10
        
        
        
        //🔊
        self.playStateIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.playStateIMGV];
        self.playStateIMGV.image = [UIImage imageNamed:@"message_voice_receiver_playing_3"];
        
        
        
        
        
        //点击手势
        self.messageLAB.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGClick:)];
        [self.messageLAB addGestureRecognizer:tapG];
        
        //长按手势
//        UILongPressGestureRecognizer *longPress =
//        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGClick:)];
//        longPress.minimumPressDuration = 0.2;
//        //[longPress requireGestureRecognizerToFail:tap];
//        [self.messageLAB addGestureRecognizer:longPress];
        
        
        
        self.durationLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.durationLAB];
        self.durationLAB.text = @"60”";
        self.durationLAB.textAlignment = NSTextAlignmentCenter;
        self.durationLAB.font = [UIFont systemFontOfSize:11.0];
        self.durationLAB.textColor = [UIColor lightGrayColor];
        self.durationLAB.layer.cornerRadius = 4.0;
        self.durationLAB.layer.masksToBounds = YES;
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
//    self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
//    self.messageLAB.frame = CGRectMake(60, 20, KWIDTH-120, KHEIGHT-30);
//    self.timeLAB.frame = CGRectMake((KWIDTH-140)/2, 0, 140, 10);
}



-(void)tapGClick:(UITapGestureRecognizer *)gesture {
    [self playAnimation];
    if (self.aChatVoiceCellTapBlock) {
        self.aChatVoiceCellTapBlock(_model);
    }
}
-(void)settingChatVoiceCellTapBlock:(ChatVoiceCellTapBlock)aBlock {
    self.aChatVoiceCellTapBlock = aBlock;
}


-(void)setModel:(Message *)model {
    _model = model;
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    
    self.durationLAB.text = [NSString stringWithFormat:@"%@''",model.duration];
    
    
    /**我是否为发送方**/
    if ([model.from containsString:model.currentMyJID])
    {
        /**头像**/
        self.iconIMGV.frame = CGRectMake(KWIDTH-10-40, 20, 40, 40);
        /**消息**/
        self.messageLAB.frame = CGRectMake(KWIDTH-60-100, 20, 100, 40);
        self.messageLAB.backgroundColor = [kTintColor colorWithAlphaComponent:0.5];
        self.playStateIMGV.frame = CGRectMake(KWIDTH-60-10-20, 20+10, 20, 20);
        self.playStateIMGV.image = [UIImage imageNamed:@"message_voice_sender_playing_3"];
        self.durationLAB.frame = CGRectMake(KWIDTH-60-100-30, 20, 30, 40);
        
        
    }
    else
    {
        /**头像**/
        self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
        /**消息**/
        self.messageLAB.frame = CGRectMake(60, 20, 100, 40);
        self.messageLAB.backgroundColor = [UIColor whiteColor];
        self.playStateIMGV.frame = CGRectMake(60+10, 20+10, 20, 20);
        self.playStateIMGV.image = [UIImage imageNamed:@"message_voice_receiver_playing_3"];
        self.durationLAB.frame = CGRectMake(160, 20, 30, 40);
    }
}













#pragma mark - Private

-(void)playAnimation{
    //imageView动画（类似电影原理）
    NSMutableArray *films = [NSMutableArray array];
    for (NSInteger i = 1; i <= 3; i++) {
        //cat_angry0000.jpg
        UIImage *image = nil;
        NSString *imageName = nil;
        
        if ([_model.from containsString:_model.currentMyJID]) {
            imageName = [NSString stringWithFormat:@"message_voice_sender_playing_%ld",i];
        } else{
            imageName = [NSString stringWithFormat:@"message_voice_receiver_playing_%ld",i];
        }
        image = [UIImage imageNamed:imageName];
        [films addObject:image];
    }
    
    //
    self.playStateIMGV.animationImages = films;
    self.playStateIMGV.animationDuration = 1.5;
    self.playStateIMGV.animationRepeatCount  = _model.duration.floatValue/1.5 + 1;
    [self.playStateIMGV startAnimating];
}

//- (void)startPlayingAnimation
//{
//    __weak __typeof(&*self) wself = self;
//    dispatch_queue_t queue = dispatch_get_global_queue  (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    __block NSUInteger currentFrame = 0;
//    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),.5*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(timer, ^{
//        dispatch_sync(dispatch_get_main_queue(), ^{
////            if (!wself.isVoicePlaying)
////            {
////                dispatch_source_cancel(timer);
////            }
////            else
////            {
//                if (currentFrame < 1 || currentFrame > 3) {
//                    currentFrame = 1;
//                }
//                if ([_model.from containsString:_model.currentMyJID])
//                {
//                    wself.playStateIMGV.image
//                    = [UIImage imageNamed:[NSString stringWithFormat:@"message_voice_sender_playing_%ld",currentFrame]];
//                }
//                else
//                {
//                    wself.playStateIMGV.image
//                    = [UIImage imageNamed:[NSString stringWithFormat:@"message_voice_receiver_playing_%ld",currentFrame]];
//                }
//                currentFrame++;
////            }
//
//        });
//    });
//    dispatch_resume(timer);
//}

//- (void)stopPlayingAnimation {
//    if (self.isVoicePlaying) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ( YES == self.message.isSender ) {
//                [self.voiceStateImageView setImage:[UIImage imageNamed:@"message_voice_sender_normal"]];
//            }
//            else {
//
//                [self.voiceStateImageView setImage:[UIImage imageNamed:@"message_voice_receiver_normal"]];
//            }
//        });
//    }
//}






@end
