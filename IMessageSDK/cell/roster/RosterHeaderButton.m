//
//  RosterHeaderButton.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "RosterHeaderButton.h"

@implementation RosterHeaderButton

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.imageView.frame = CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.titleLabel.frame = CGRectMake(50, (KHEIGHT-20)/2, 100, 20);
}
@end
