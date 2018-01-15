//
//  AddRGContactCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AddRGContactCell.h"

@interface AddRGContactCell ()
@property (nonatomic, strong) UIImageView *IMGV;
@property (nonatomic, strong) UILabel *nameLAB;
@property (nonatomic, strong) UILabel *phonenumLAB;
@property (nonatomic, strong) UIButton *callBTN;
@end






@implementation AddRGContactCell

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
        
        
        self.phonenumLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.phonenumLAB];
        self.phonenumLAB.text = @"卡1:18845781245  卡2:16678458923";
        self.phonenumLAB.textColor = [UIColor grayColor];
        self.phonenumLAB.font = [UIFont systemFontOfSize:10];
        
        
        
        self.callBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.contentView addSubview:self.callBTN];
        [self.callBTN setTitle:@"拨打" forState:(UIControlStateNormal)];
        self.callBTN.layer.cornerRadius = 4;
        self.callBTN.layer.masksToBounds = YES;
        [self.callBTN setBackgroundColor:[UIColor greenColor]];
        [self.callBTN setTintColor:[UIColor whiteColor]];
        [self.callBTN addTarget:self action:@selector(buttopnClick:)
               forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
        CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.IMGV.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.nameLAB.frame = CGRectMake(50, (KHEIGHT-20)/2, 100, 20);
    self.phonenumLAB.frame = CGRectMake(50, KHEIGHT-20, KWIDTH-60, 20);
    self.callBTN.frame =CGRectMake(KWIDTH-60, (KHEIGHT-30)/2, 50, 30);
}




-(void)buttopnClick:(UIButton *)sender{
    if (self.aAddRGContactCellBlock) {
        self.aAddRGContactCellBlock(self.model);
    }
}

-(void)setAAddRGContactCellBlock:(AddRGContactCellBlock)aAddRGContactCellBlock {
    _aAddRGContactCellBlock = aAddRGContactCellBlock;
}

-(void)setModel:(AddRGContactModel *)model {
    _model = model;
    self.nameLAB.text = model.username;
    
    if (model.phoneNumbers.count == 0) {
        
        self.phonenumLAB.text = @"";
    }
    else
    {
        NSMutableString *strM = [NSMutableString string];
        
        for (int i = 0; i < model.phoneNumbers.count; i ++)
        {
            [strM appendFormat:@"卡%i:%@    ",i+1,model.phoneNumbers[i]];
        }
        self.phonenumLAB.text = strM;
    }
}
@end
