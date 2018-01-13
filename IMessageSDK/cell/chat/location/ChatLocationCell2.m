//
//  ChatLocationCell2.m
//  IMessageSDK
//
//  Created by JH on 2018/1/13.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatLocationCell2.h"





@interface ChatLocationCell2 ()
@property (nonatomic, strong) UILabel *titleLAB;
@property (nonatomic, strong) UILabel *subTitleLAB;
@property (nonatomic, strong) UIImageView *selectIMGV;
@end






@implementation ChatLocationCell2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.titleLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLAB];
        self.titleLAB.text = @"i 啊过去我遇到过香港代购";
        self.titleLAB.font = [UIFont systemFontOfSize:16];
        
        
        
        self.subTitleLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.subTitleLAB];
        self.subTitleLAB.text = @"i 啊过dasdasdasfqewtfrv ";
        self.subTitleLAB.font = [UIFont systemFontOfSize:12];
        self.subTitleLAB.textColor = [UIColor grayColor];
        
        
        self.selectIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.selectIMGV];
        self.selectIMGV.image = [UIImage imageNamed:@"chatLocation_selected"];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.titleLAB.frame = CGRectMake(10, 5, 300, 20);
    self.subTitleLAB.frame = CGRectMake(10, 25, 300, 20);
    self.selectIMGV.frame = CGRectMake(KWIDTH-30, (KHEIGHT-20)/2, 20, 20);
}



-(void)setModel:(ChatLocationModel *)model {
    _model = model;
    
    self.titleLAB.text = model.title;
    self.subTitleLAB.text = model.subtitle;
    
    if (model.isSelected) {
        self.titleLAB.textColor = [UIColor greenColor];
        self.subTitleLAB.textColor = [UIColor greenColor];
        self.selectIMGV.hidden = NO;
    }else{
        self.titleLAB.textColor = [UIColor blackColor];
        self.subTitleLAB.textColor = [UIColor grayColor];
        self.selectIMGV.hidden = YES;

    }
}

@end
