//
//  CreateGroupCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "CreateGroupCell.h"
@interface CreateGroupCell ()
@property (nonatomic, strong) UIImageView *iconIMGV;

@property (nonatomic, strong) UILabel *nameLAB;
@end




@implementation CreateGroupCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
        self.iconIMGV.layer.cornerRadius = 4;
        self.iconIMGV.layer.masksToBounds = YES;
        
        
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"xxxx";
        self.nameLAB.textAlignment = NSTextAlignmentCenter;
        self.nameLAB.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    self.iconIMGV.frame = CGRectMake(0, 0,KWIDTH, KHEIGHT);
    
    self.nameLAB.frame = CGRectMake(0, KHEIGHT-20, KWIDTH, 20);
}


-(void)setModel:(OrgModel *)model {
    _model = model;
    
    self.nameLAB.text = model.NAME;
    
    if (model.isAdd) {
        self.iconIMGV.image = [UIImage imageNamed:@"AddGroupMemberBtnHL_58x58_"];
        self.nameLAB.hidden = YES;
    }else{
        self.iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
        self.nameLAB.hidden = NO;
    }
}





@end
