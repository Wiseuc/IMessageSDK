//
//  RosterCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "RosterCell.h"

@interface RosterCell ()
@property (nonatomic, strong) UIImageView *IMGV;
@property (nonatomic, strong) UILabel *nameLAB;


@end






@implementation RosterCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.IMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.IMGV];
        self.IMGV.image = [UIImage imageNamed:@"icon_40pt"];
        
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"name";
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.IMGV.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.nameLAB.frame = CGRectMake(50, (KHEIGHT-20)/2, 100, 20);
    
}


-(void)setModel:(RosterModel *)model {
    _model = model;
    self.nameLAB.text = model.FN;
    
}


@end
