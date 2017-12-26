//
//  RosterCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "RosterCell.h"

@interface RosterCell ()

@property (nonatomic, strong) UILabel *nameLAB;
@end






@implementation RosterCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
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
    
    self.nameLAB.frame = CGRectMake(20, (KHEIGHT-20)/2, 100, 20);
    
}


-(void)setModel:(RosterModel *)model {
    _model = model;
    self.nameLAB.text = model.FN;
    
}


@end
