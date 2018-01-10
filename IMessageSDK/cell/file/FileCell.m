//
//  FileCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/10.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "FileCell.h"

@interface FileCell ()
@property (nonatomic, strong) UIImageView *IMGV;
@property (nonatomic, strong) UILabel *nameLAB;
@property (nonatomic, strong) UILabel *sizeLAB;
@end










@implementation FileCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.IMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.IMGV];
        self.IMGV.image = [UIImage imageNamed:@"file_image"];
        
        
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"name";
        
        
        
        self.sizeLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.sizeLAB];
        self.sizeLAB.text = @"100.00M";
        self.sizeLAB.textAlignment = NSTextAlignmentRight;
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.IMGV.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.nameLAB.frame = CGRectMake(50, (KHEIGHT-20)/2, 250, 20);
    self.sizeLAB.frame = CGRectMake(KWIDTH -110, (KHEIGHT-20)/2, 100, 20);
    
}


-(void)setModel:(Message *)model {
    _model = model;
    self.nameLAB.text = model.body;
    self.sizeLAB.text = [NSString stringWithFormat:@"%0.2fKB",model.size.floatValue/1024];
}


@end
