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
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    self.iconIMGV.frame = CGRectMake(0, 0,KWIDTH, KHEIGHT);
}


-(void)setImage:(NSString *)image {
    
    self.iconIMGV.image = [UIImage imageNamed:image];
    
}

@end
