//
//  AddRosterCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AddRosterCell.h"



@interface AddRosterCell ()
@property (nonatomic, strong) UIImageView *IMGV;
@property (nonatomic, strong) UILabel *nameLAB;

/**添加好友按钮**/
@property (nonatomic, strong) UIButton *addBTN;
@end






@implementation AddRosterCell


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
        
        
        
        
        self.addBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.contentView addSubview:self.addBTN];
        [self.addBTN addTarget:self action:@selector(buttonClick:)
              forControlEvents:(UIControlEventTouchUpInside)];
        [self.addBTN setTitle:@"添加" forState:(UIControlStateNormal)];
        self.addBTN.layer.cornerRadius = 4;
        self.addBTN.layer.masksToBounds = YES;
        [self.addBTN setBackgroundColor:[UIColor greenColor]];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
        CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.IMGV.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.nameLAB.frame = CGRectMake(50, (KHEIGHT-20)/2, 100, 20);
    self.addBTN.frame = CGRectMake(KWIDTH-60, (KHEIGHT-30)/2, 50, 30);
    
}







-(void)buttonClick:(UIButton *)sender {
    
    if (self.aAddRosterCellBlock) {
        self.aAddRosterCellBlock(self.model);
    }
}





-(void)setAAddRosterCellBlock:(AddRosterCellBlock)aAddRosterCellBlock {
    _aAddRosterCellBlock = aAddRosterCellBlock;
}

-(void)setModel:(OrgModel *)model {
    _model = model;
    self.nameLAB.text = model.NAME;
}


@end
