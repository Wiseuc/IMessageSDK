//
//  ChatImageCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatImageCell.h"
#import "UIConfig.h"
#import "HttpTool.h"

@interface ChatImageCell ()
@property (nonatomic, strong) UIImageView *iconIMGV;  /**头像**/
@property (nonatomic, strong) UIImageView *backgroundIMGV;  /**背景**/
//@property (nonatomic, strong) UIImageView *contentIMGV;  /**背景**/
@property (nonatomic, strong) UILabel *timeLAB;  /**时间**/

@property (nonatomic, strong) ChatImageCellTapBlock aChatImageCellTapBlock;
@end



@implementation ChatImageCell


-(void)settingChatImageCellTapBlock:(ChatImageCellTapBlock)aBlock{
    self.aChatImageCellTapBlock = aBlock;
}

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
        
        
        
        
        self.backgroundIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.backgroundIMGV];
        self.backgroundIMGV.layer.cornerRadius = 4;
        self.backgroundIMGV.layer.masksToBounds = YES;
//        self.backgroundIMGV.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundIMGV.backgroundColor = [UIColor blackColor];
        
        
        self.contentIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.contentIMGV];
        self.contentIMGV.layer.cornerRadius = 4;
        self.contentIMGV.layer.masksToBounds = YES;
        self.contentIMGV.image = [UIImage imageNamed:@"color_D"];
        self.contentIMGV.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        //点击手势
        self.contentIMGV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGClick:)];
        [self.contentIMGV addGestureRecognizer:tapG];
        
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
    if (self.aChatImageCellTapBlock) {
        self.aChatImageCellTapBlock(_model);
    }
}
-(void)setModel:(Message *)model {
    _model = model;
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    /**我是否为发送方**/
    if ([model.from containsString:model.currentMyJID])
    {
        self.iconIMGV.frame = CGRectMake(KWIDTH-10-40, 20, 40, 40);
        self.backgroundIMGV.frame = CGRectMake(KWIDTH-10-40-10-80, 20, 80, 142.3); //1334 * 750
        self.contentIMGV.frame = CGRectMake(KWIDTH-10-40-10-80, 20, 80, 142.3);
    }
    else
    {
        self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
        self.backgroundIMGV.frame = CGRectMake(60, 20, 80, 142.3);
        self.contentIMGV.frame = CGRectMake(60, 20, 80, 142.3);
    }
    
    UIImage *img = [UIImage imageWithContentsOfFile:model.localPath];
    self.contentIMGV.image = img;
    
}


@end
