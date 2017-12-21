//
//  MineCell01.m
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "MineCell01.h"
@interface MineCell01 ()

@property (nonatomic, strong) UIImageView *iconIMGV;  /**大头像**/
@property (nonatomic, strong) UILabel *nameLAB;       /**名字**/
@end




@implementation MineCell01

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"wode_xuanzhong"];
        
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"name";
        self.nameLAB.font = [UIFont italicSystemFontOfSize:24.0];
        
        
    }
    return self;
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    self.iconIMGV.frame = CGRectMake(20, (KHEIGHT-40)/2, 40, 40);
    self.nameLAB.frame = CGRectMake(70, (KHEIGHT-30)/2, 200, 30);
}


-(void)setTitle:(NSString *)title {
    self.nameLAB.text = title;
}
@end
