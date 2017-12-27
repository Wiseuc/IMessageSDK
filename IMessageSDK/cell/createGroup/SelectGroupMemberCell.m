//
//  SelectGroupMemberCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "SelectGroupMemberCell.h"
#import "UIImage+Color2Image.h"

@interface SelectGroupMemberCell ()

@property (nonatomic, strong) UIButton *selectBTN;
@property (nonatomic, strong) UILabel *nameLAB;


@property (nonatomic, strong) SelectGroupMemberCellBlock aSelectGroupMemberCellBlock;
@end



@implementation SelectGroupMemberCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectBTN = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.contentView addSubview:self.selectBTN];
        self.selectBTN.layer.borderWidth = 1;
        self.selectBTN.layer.borderColor = [UIColor grayColor].CGColor;
        [self.selectBTN setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        [self.selectBTN setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forState:(UIControlStateSelected)];
        self.selectBTN.selected = NO;
        [self.selectBTN addTarget:self action:@selector(choose) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        

    }
    return self;
}



-(void)setModel:(OrgModel *)model completed:(SelectGroupMemberCellBlock)aBlock {
    _model = model;
    _aSelectGroupMemberCellBlock = aBlock;
    
    //CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    self.nameLAB.text = model.NAME;
    CGFloat dis_left = 20 * model.lever + 20;
    
    
    self.selectBTN.frame = CGRectMake(dis_left, (KHEIGHT-20)/2, 20, 20);
    self.nameLAB.frame = CGRectMake(dis_left+20+10, (KHEIGHT - 20)/2, 100, 20);
    
    
    self.selectBTN.selected = model.isSelect;
}



-(void)choose {
    if (self.aSelectGroupMemberCellBlock) {
        self.aSelectGroupMemberCellBlock(_model);
    }
}

@end
