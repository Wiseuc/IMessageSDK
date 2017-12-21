//
//  GroupCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "GroupCell.h"
#import "GroupButton.h"
@interface GroupCell ()
@property (nonatomic, strong) GroupButton *groupButton;

@property (nonatomic, strong) UIImageView *iconIMGV;
@property (nonatomic, strong) UILabel *nameLAB;
@end



@implementation GroupCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"wode_xuanzhong"];
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"name";
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.iconIMGV.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.nameLAB.frame = CGRectMake(50, (KHEIGHT-20)/2, 200, 20);
}



-(void)setModel:(GroupModel *)model {
    _model = model;
    
    self.nameLAB.text = model.name;
}

@end
