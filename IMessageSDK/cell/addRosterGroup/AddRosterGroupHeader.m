//
//  AddRosterGroupHeader.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "AddRosterGroupHeader.h"
@interface AddRosterGroupHeader ()
@property (nonatomic, strong) UIButton *inputBTN;
@end





@implementation AddRosterGroupHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.inputBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.inputBTN];
        [self.inputBTN setTitle:@"搜索联系人：张三／zhangsan / zs"
                       forState:(UIControlStateNormal)];
        [self.inputBTN setImage:[UIImage imageNamed:@"searchBarIcon"]
                       forState:(UIControlStateNormal)];
        [self.inputBTN addTarget:self action:@selector(buttonClick:)
                forControlEvents:(UIControlEventTouchUpInside)];
        [self.inputBTN setBackgroundColor:[UIColor whiteColor]];
        [self.inputBTN setTintColor:[UIColor lightGrayColor]];
        
    }
    return self;
}



-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    self.inputBTN.frame = CGRectMake(0, 20, KWIDTH, 50);
}

-(void)setAAddRosterGroupHeaderBlock:(AddRosterGroupHeaderBlock)aAddRosterGroupHeaderBlock{
    _aAddRosterGroupHeaderBlock = aAddRosterGroupHeaderBlock;
}
-(void)buttonClick:(UIButton *)sender{
    if (self.aAddRosterGroupHeaderBlock) {
        self.aAddRosterGroupHeaderBlock();
    }
}
@end
