//
//  RosterReuseableHeader.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "RosterReuseableHeader.h"
#import "RosterHeaderButton.h"

@interface RosterReuseableHeader ()
@property (nonatomic, strong) RosterHeaderButton *groupBTN;
@property (nonatomic, strong) RosterHeaderButton *OrgBTN;
@property (nonatomic, strong) RosterHeaderButton *companyBTN;
@end





@implementation RosterReuseableHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.groupBTN = [RosterHeaderButton buttonWithType:(UIButtonTypeSystem)];
        [self.groupBTN setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.groupBTN];
        self.groupBTN.tag = 1001;
        [self.groupBTN addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.groupBTN setImage:[[UIImage imageNamed:@"pinglun_dianji"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        [self.groupBTN setTitle:@"群组" forState:(UIControlStateNormal)];
        [self.groupBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        
        self.OrgBTN = [RosterHeaderButton buttonWithType:(UIButtonTypeSystem)];
        [self.OrgBTN setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.OrgBTN];
        self.OrgBTN.tag = 1002;
        [self.OrgBTN addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.OrgBTN setImage:[[UIImage imageNamed:@"pinglun_dianji"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        [self.OrgBTN setTitle:@"组织架构" forState:(UIControlStateNormal)];
        [self.OrgBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        
        self.companyBTN = [RosterHeaderButton buttonWithType:(UIButtonTypeSystem)];
        [self.companyBTN setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.companyBTN];
        self.companyBTN.tag = 1003;
        [self.companyBTN addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.companyBTN setImage:[[UIImage imageNamed:@"pinglun_dianji"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        [self.companyBTN setTitle:@"企业号" forState:(UIControlStateNormal)];
        [self.companyBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return self;
}





-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat KWIDTH  = self.frame.size.width;
    //CGFloat KHEIGHT = self.frame.size.height;
    
    self.groupBTN.frame   = CGRectMake(0, 0, KWIDTH, 50);
    self.OrgBTN.frame     = CGRectMake(0, 52, KWIDTH, 50);
    self.companyBTN.frame = CGRectMake(0, 104, KWIDTH, 50);
}





#pragma mark - Private

-(void)buttonClick:(UIButton *)sender {
    self.aRosterReuseableHeaderSelectBlock(sender.tag);
}
-(void)setARosterReuseableHeaderSelectBlock:(RosterReuseableHeaderSelectBlock)aRosterReuseableHeaderSelectBlock {
    _aRosterReuseableHeaderSelectBlock = aRosterReuseableHeaderSelectBlock;
}

@end
