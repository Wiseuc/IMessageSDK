//
//  MineAboutCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "MineAboutCell.h"
@interface MineAboutCell ()
@property (nonatomic, strong) UILabel *nameLAB;       /**名字**/
@property (nonatomic, strong) UIImageView *rightIMGV;  /**右侧>**/
@end






@implementation MineAboutCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.rightIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rightIMGV];
        self.rightIMGV.image = [UIImage imageNamed:@"org_more"];
        
        
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
    
    self.nameLAB.frame = CGRectMake(10, (KHEIGHT-20)/2, 100, 20);
    self.rightIMGV.frame = CGRectMake(KWIDTH-30, (KHEIGHT-20)/2, 20, 20);
    
}


-(void)setTitle:(NSString *)title {
    self.nameLAB.text = title;
}
@end
