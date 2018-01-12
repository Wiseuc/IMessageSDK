//
//  ChatVibrateCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatVibrateCell.h"


#import "JHLabel.h"
#import "UIConfig.h"

@interface ChatVibrateCell ()

@property (nonatomic, strong) UIImageView *iconIMGV;  /**头像**/

@property (nonatomic, strong) UIImageView *messageIconIMGV;  /**消息icon**/
@property (nonatomic, strong) JHLabel *messageLAB;  /**消息**/

//@property (nonatomic, strong) UIImageView *backgroundIMGV;  /**背景**/
@property (nonatomic, strong) UILabel *timeLAB;  /**时间**/
@end












@implementation ChatVibrateCell
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
        self.messageLAB.text = @"窗口抖动";
        self.messageLAB.font = [UIFont systemFontOfSize:15.0];
        self.messageLAB.numberOfLines = 0;
        self.messageLAB.backgroundColor = [kTintColor colorWithAlphaComponent:0.5];
        self.messageLAB.layer.cornerRadius = 4.0;
        self.messageLAB.layer.masksToBounds = YES;
        self.messageLAB.textInsets = UIEdgeInsetsMake(5,5,5,5); // 设置左内边距
        //self.messageLAB.textColor = [UIColor lightTextColor];
        self.messageLAB.textAlignment = NSTextAlignmentRight;
        
        
        
        self.messageIconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.messageIconIMGV];
        self.messageIconIMGV.image = [UIImage imageNamed:@"char_vibrate"];
        
        
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    //self.timeLAB.frame = CGRectMake((KWIDTH-140)/2, 0, 140, 10);
    //self.messageLAB.frame = CGRectMake(60, 20, KWIDTH-120, KHEIGHT-30);
    //    self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
}



-(void)setModel:(Message *)model {
    _model = model;
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    /**时间**/
    self.timeLAB.text = model.stamp;
    CGSize timeSize = [self.timeLAB sizeThatFits:(CGSizeMake(MAXFLOAT, 10))];
    self.timeLAB.frame = CGRectMake((KWIDTH-timeSize.width-20)/2, 0, timeSize.width+10, 10);
    
    
    

    /**我是否为发送方**/
    if ([model.from containsString:model.currentMyJID])
    {
        /**头像**/
        self.iconIMGV.frame = CGRectMake(KWIDTH-10-40, 20, 40, 40);
        /**消息**/
        self.messageLAB.backgroundColor = [kTintColor colorWithAlphaComponent:0.5];
         self.messageLAB.frame = CGRectMake(KWIDTH-100-60, 20, 100, 40);
        self.messageIconIMGV.frame = CGRectMake(KWIDTH-60-100+5, 30, 20, 20);
    }
    else
    {
        /**头像**/
        self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
        /**消息**/
        self.messageLAB.backgroundColor = [UIColor whiteColor];
        self.messageLAB.frame = CGRectMake(60, 20, 100, 40);
        self.messageIconIMGV.frame = CGRectMake(60+5, 30, 20, 20);

    }
    
    
    
    
    
}

@end
