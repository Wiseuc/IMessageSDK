//
//  OrgCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "OrgCell.h"
@interface OrgCell ()
@property (nonatomic, strong) UIImageView *iconIMGV;
@property (nonatomic, strong) UILabel *nameLAB;
@property (nonatomic, strong) UIImageView *moreIMGV;
@end




@implementation OrgCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"wode_xuanzhong"];
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"name";
        
        self.moreIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.moreIMGV];
        self.moreIMGV.image = [UIImage imageNamed:@"org_more"];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    self.iconIMGV.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.nameLAB.frame = CGRectMake(50, (KHEIGHT-20)/2, 200, 20);
    self.moreIMGV.frame = CGRectMake(KWIDTH - 30, (KHEIGHT-20)/2, 20, 20);
}


-(void)setModel:(OrgModel *)model {
    _model = model;
    
    self.nameLAB.text = model.NAME;
    
    if ([model.ITEMTYPE isEqualToString:@"1"])
    {
        self.moreIMGV.hidden = NO;
    }else if ([model.ITEMTYPE isEqualToString:@"2"]){
        self.moreIMGV.hidden = YES;
    }
}

@end
