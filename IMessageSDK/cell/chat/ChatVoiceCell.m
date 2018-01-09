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
//@property (nonatomic, strong) UIImageView *backgroundIMGV;  /**背景**/
@property (nonatomic, strong) UILabel *timeLAB;  /**时间**/
@property (nonatomic, strong) UILabel *durationLAB;  /**时长**/
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
        self.messageLAB.text = @"语音";
        self.messageLAB.font = [UIFont systemFontOfSize:15.0];
        self.messageLAB.numberOfLines = 0;
        self.messageLAB.backgroundColor = [kTintColor colorWithAlphaComponent:0.5];
        self.messageLAB.layer.cornerRadius = 4.0;
        self.messageLAB.layer.masksToBounds = YES;
        self.messageLAB.textInsets = UIEdgeInsetsMake(5,5,5,5); // 设置左内边距,撑大控件10
        
        
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
        self.durationLAB.frame = CGRectMake(KWIDTH-60-100-30, 20, 30, 40);
    }
    else
    {
        /**头像**/
        self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
        /**消息**/
        self.messageLAB.frame = CGRectMake(60, 20, 100, 40);
        self.messageLAB.backgroundColor = [UIColor whiteColor];
        self.durationLAB.frame = CGRectMake(160, 20, 30, 40);
    }
    
    
    
}

@end
