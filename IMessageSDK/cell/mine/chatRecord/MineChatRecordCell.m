//
//  MineChatRecordCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "MineChatRecordCell.h"
@interface MineChatRecordCell ()
@property (nonatomic, strong) UILabel *nameLAB;       /**名字**/
@end






@implementation MineChatRecordCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
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
    
    self.nameLAB.frame = CGRectMake(10, (KHEIGHT-20)/2, KWIDTH, 20);
}







-(void)setTitle:(NSString *)title {
    
    self.nameLAB.text = title;
}
@end
