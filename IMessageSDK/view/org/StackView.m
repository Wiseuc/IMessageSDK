//
//  StackView.m
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "StackView.h"
@interface StackView ()
@property (nonatomic, strong) UIButton *backBTN;  /**上一层**/
@property (nonatomic, strong) UILabel *contentLAB;

@property (nonatomic, strong) StackViewBackBlock aStackViewBackBlock;
@end




@implementation StackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.backBTN];
        [self.backBTN setImage:[[UIImage imageNamed:@"org_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        [self.backBTN addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        self.contentLAB = [[UILabel alloc] init];
        [self addSubview:self.contentLAB];
        self.contentLAB.text = @"组织";
        self.contentLAB.backgroundColor = [UIColor lightGrayColor];
        self.contentLAB.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.backBTN.frame =CGRectMake(20, (KHEIGHT-20)/2, 20, 20);
    self.contentLAB.frame = CGRectMake(50, (KHEIGHT-20)/2, KWIDTH-100, 20);
    
}


-(void)showContent:(NSString *)content {
    self.contentLAB.text = content;
}



-(void)setBackAction:(StackViewBackBlock)aStackViewBackBlock {
    _aStackViewBackBlock = aStackViewBackBlock;
}



-(void)buttonClick:(UIButton *)sender {
    self.aStackViewBackBlock();
}



@end
