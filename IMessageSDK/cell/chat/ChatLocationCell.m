//
//  ChatLocationCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatLocationCell.h"
#import "UIConfig.h"
#import "JHLabel.h"




@interface ChatLocationCell ()

@property (nonatomic, strong) UIImageView *iconIMGV;  /**头像**/
@property (nonatomic, strong) JHLabel *messageLAB;  /**消息**/

@property (nonatomic, strong) UILabel *titleLAB;
@property (nonatomic, strong) UILabel *subtitleLAB;


@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIImageView *locationIMGV;  /**文件图片**/


//@property (nonatomic, strong) UILabel *timeLAB;  /**时间**/
@end









@implementation ChatLocationCell




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
        self.messageLAB.backgroundColor = [UIColor whiteColor];
        self.messageLAB.layer.cornerRadius = 4.0;
        self.messageLAB.layer.masksToBounds = YES;
        self.messageLAB.textInsets = UIEdgeInsetsMake(5,5,5,5); // 设置左内边距,撑大控件10
        
        
        
        //
        self.titleLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLAB];
        self.titleLAB.numberOfLines = 0;
        self.titleLAB.text = @"清华信息港、";
        self.titleLAB.font = [UIFont boldSystemFontOfSize:16.0];
        
        
        
        
        //
        self.subtitleLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.subtitleLAB];
        self.subtitleLAB.text = @"广东省深圳市南山区清华信息港综合楼706";
        self.subtitleLAB.font = [UIFont systemFontOfSize:10];
        self.subtitleLAB.textColor = [UIColor grayColor];
        
        
        
        
        //分割线line
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        
        
        
        //map
        self.locationIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.locationIMGV];
        self.locationIMGV.image = [UIImage imageNamed:@"chatLocation_location"];
        self.locationIMGV.layer.cornerRadius = 4;
        self.locationIMGV.layer.masksToBounds = YES;
        
        
        
        
        
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
    if (self.aChatLocationCellTapBlock) {
        self.aChatLocationCellTapBlock(_model);
    }
}










-(void)setAChatLocationCellTapBlock:(ChatLocationCellTapBlock)aChatLocationCellTapBlock {
    _aChatLocationCellTapBlock = aChatLocationCellTapBlock;
}



-(void)setModel:(Message *)model {
    _model = model;
    
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    
    self.titleLAB.text = model.body;
    self.subtitleLAB.text = model.address;
    
    
    
    /**我是否为发送方**/
    if ([model.from containsString:model.currentMyJID])
    {
        self.iconIMGV.frame = CGRectMake(KWIDTH-10-40, 20, 40, 40);
        self.messageLAB.frame = CGRectMake(KWIDTH-60-200, 20, 200, 100);
        
        self.titleLAB.frame = CGRectMake(KWIDTH-60-200+10, 20+10, 180, 20);
        self.subtitleLAB.frame = CGRectMake(KWIDTH-60-200+10, 20+10+20, 180, 20);
        
        self.line.frame = CGRectMake(KWIDTH-60-200, 20+10+20+20, 200, 1);
        self.locationIMGV.frame = CGRectMake(KWIDTH-60-200, 71, 200, 100-51);
    }
    else
    {
        self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
        self.messageLAB.frame = CGRectMake(60, 20, 200, 100);
        
        self.titleLAB.frame = CGRectMake(60+10, 20+10, 180, 20);
        self.subtitleLAB.frame = CGRectMake(60+10, 20+10+20, 180, 20);
        
        self.line.frame = CGRectMake(60, 20+10+20+20, 200, 1);
        self.locationIMGV.frame = CGRectMake(60, 71, 200, 100-51);
    }
    
}

@end
