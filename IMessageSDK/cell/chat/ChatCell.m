//
//  ChatCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "ChatCell.h"
#import "JHLabel.h"
#import "UIConfig.h"
#import "XMFaceManager.h"

@interface ChatCell ()

@property (nonatomic, strong) UIImageView *iconIMGV;  /**头像**/
@property (nonatomic, strong) JHLabel *messageLAB;  /**消息**/
//@property (nonatomic, strong) UIImageView *backgroundIMGV;  /**背景**/
@property (nonatomic, strong) UILabel *timeLAB;  /**时间**/
@end







@implementation ChatCell



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
        self.messageLAB.text = @"打算低价啊是个好睇噶的嘎嘎大大撒的发 i 阿哥好嗲规划 i 老师的红啊还是风度好 i 速滑奋斗啊还是";
        self.messageLAB.font = [UIFont systemFontOfSize:16.0];
        self.messageLAB.numberOfLines = 0;
        self.messageLAB.backgroundColor = [kTintColor colorWithAlphaComponent:0.5];
        self.messageLAB.layer.cornerRadius = 4.0;
        self.messageLAB.layer.masksToBounds = YES;
        self.messageLAB.textInsets = UIEdgeInsetsMake(5,5,5,5); // 设置左内边距
        //self.messageLAB.textColor = [UIColor lightTextColor];
        
        
        
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

    
    
    NSString *bodyStr = model.body;
    
    
    /**
     xxxx<i@12.gif>ccccccc<i@12.gif>dddddd<i@12.gif>xxxxxx
     变
     xxxxxx_START_11_END_xxxxx_START_11_END_xxxxx
     **/
    bodyStr = [bodyStr stringByReplacingOccurrencesOfString:@"<i@" withString:@"_START_"];
    bodyStr = [bodyStr stringByReplacingOccurrencesOfString:@".gif>" withString:@"_END_"];
    
    /**
     xxxxxx_START_11
     xxxxx_START_11
     xxxxx
     **/
    NSArray *arr01 = [bodyStr componentsSeparatedByString:@"_END_"];

    NSMutableArray *contentM = [NSMutableArray array];
    NSMutableArray *idM = [NSMutableArray array];

    for (NSString *temp01 in arr01)
    {
        //NSLog(@"temp == %@",temp01);
        
        if ([temp01 containsString:@"_START_"])
        {
            NSArray *arr03 = [temp01 componentsSeparatedByString:@"_START_"];
            
            [contentM addObject:arr03.firstObject];
            
            [idM addObject:arr03.lastObject];
        }
        else
        {
            [contentM addObject:temp01];
        }
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    
    
    for (int i = 0; i < contentM.count; i ++)
    {
        NSString *contentStr = contentM[i];
        NSAttributedString *contentAttrStr = [[NSAttributedString alloc] initWithString:contentStr];
        [attrString appendAttributedString:contentAttrStr];
        
        if (i < contentM.count - 1)
        {
            NSString *idStr = idM[i];
            NSString *faceName = [NSString stringWithFormat:@"f%@.gif",idStr];
            
            //附件
            NSTextAttachment *attach1 = [[NSTextAttachment alloc] init];
            //设置图片
            attach1.image = [UIImage imageNamed:faceName];
            //调整图片位置
            attach1.bounds = CGRectMake(5, -5, 30, 30);
            [attrString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach1]];
        }
    }

    
    
    
    
    
    
    self.messageLAB.attributedText = attrString;
//    self.messageLAB.text = model.body;
    
    /**我是否为发送方**/
    if ([model.from containsString:model.currentMyJID])
    {
        /**头像**/
        self.iconIMGV.frame = CGRectMake(KWIDTH-10-40, 20, 40, 40);
        
        /**消息**/
        //self.messageLAB.text = model.body;
        CGSize messageSize = [self.messageLAB sizeThatFits:(CGSizeMake(MAXFLOAT, 40))];
        if (KHEIGHT < 71){
            self.messageLAB.frame = CGRectMake(KWIDTH-10-messageSize.width-10 - 40 - 10, 20, messageSize.width+10, KHEIGHT-30);
        }else{
            self.messageLAB.frame = CGRectMake(60, 20, KWIDTH-120, KHEIGHT-30);
        }
        
        self.messageLAB.backgroundColor = [kTintColor colorWithAlphaComponent:0.5];
    }else{
        /**头像**/
        self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
        
        /**消息**/
        //self.messageLAB.text = model.body;
        if (KHEIGHT < 71){
            CGSize messageSize = [self.messageLAB sizeThatFits:(CGSizeMake(MAXFLOAT, 40))];
            self.messageLAB.frame = CGRectMake(60, 20, messageSize.width + 10, KHEIGHT-30);
        }else{
            self.messageLAB.frame = CGRectMake(60, 20, KWIDTH-120, KHEIGHT-30);
        }
        
        self.messageLAB.backgroundColor = [UIColor whiteColor];
    }
    
    
    

    
}










@end
