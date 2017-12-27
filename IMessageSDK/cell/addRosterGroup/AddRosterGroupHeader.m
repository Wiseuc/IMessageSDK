//
//  AddRosterGroupHeader.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "AddRosterGroupHeader.h"
@interface AddRosterGroupHeader ()

@property (nonatomic, strong) UITextField *searchTF;
@end





@implementation AddRosterGroupHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor orangeColor];
        
        self.searchTF = [[UITextField alloc] init];
        [self addSubview:self.searchTF];
        self.searchTF.placeholder = @"搜索联系人：张三／zhangsan";
        self.searchTF.backgroundColor = [UIColor whiteColor];
        self.searchTF.leftViewMode = UITextFieldViewModeAlways;
        self.searchTF.enabled = NO;
        
        
        UIImageView *imagev = [[UIImageView alloc] init];
        imagev.image = [UIImage imageNamed:@"searchBarIcon"];
        imagev.frame = CGRectMake(0, 0, 30, 30);
        self.searchTF.leftView = imagev;
        
        
    }
    return self;
}



-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.searchTF.frame = CGRectMake(0, 20, KWIDTH, 50);
    

    
}



@end
