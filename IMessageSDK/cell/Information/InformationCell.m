//
//  InformationCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "InformationCell.h"
@interface InformationCell ()
@property (nonatomic, strong) UILabel *nameLAB;
@property (nonatomic, strong) UILabel *valueLAB;
@end




@implementation InformationCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameLAB = [[UILabel alloc] init];
        self.nameLAB.text = @"name";
        [self.contentView addSubview:self.nameLAB];
        
        
        self.valueLAB = [[UILabel alloc] init];
        self.valueLAB.text = @"value";
        self.valueLAB.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.valueLAB];
        //self.valueLAB.adjustsFontSizeToFitWidth = YES;
        self.valueLAB.numberOfLines = 0;
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    self.nameLAB.frame = CGRectMake(20, (KHEIGHT-20)/2, 100, 20);
    self.valueLAB.frame = CGRectMake(KWIDTH-210, (KHEIGHT-20)/2, 200, 20);
}


-(void)setDataWithName:(NSString *)aName value:(NSString *)aValue {

    self.nameLAB.text = aName;
    self.valueLAB.text = aValue;
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    CGSize size = [self.valueLAB sizeThatFits:CGSizeMake(200, MAXFLOAT)];
    self.valueLAB.frame = CGRectMake(KWIDTH-210, (KHEIGHT-20)/2, 200, size.height);
}





@end
