//
//  GroupCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "GroupCell.h"
#import "GroupButton.h"
@interface GroupCell ()
@property (nonatomic, strong) GroupButton *groupButton;
@end



@implementation GroupCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.groupButton = [GroupButton buttonWithType:(UIButtonTypeSystem)];
        [self.contentView addSubview:self.groupButton];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.groupButton.frame = self.bounds;
}



-(void)setModel:(GroupModel *)model {
    _model = model;
    [self.groupButton setTitle:model.FN forState:(UIControlStateNormal)];
}

@end
