//
//  GroupButton.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "GroupButton.h"

@implementation GroupButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"name" forState:(UIControlStateNormal)];
        [self setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self setImage:[[UIImage imageNamed:@"wode_xuanzhong"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.imageView.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.titleLabel.frame = CGRectMake(50, (KHEIGHT-20)/2, 200, 20);
}
@end
