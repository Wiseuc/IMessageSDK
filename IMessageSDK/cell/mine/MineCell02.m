//
//  MineCell02.m
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "MineCell02.h"
@interface MineCell02 ()

@property (nonatomic, strong) UIImageView *iconIMGV;  /**大头像**/
@property (nonatomic, strong) UILabel *nameLAB;       /**名字**/
@end




@implementation MineCell02


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.shouldIndentWhileEditing = YES;
        
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"wode_xuanzhong"];
        
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"property";
        self.nameLAB.font = [UIFont systemFontOfSize:16.0];
        
        
    }
    return self;
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    self.iconIMGV.frame = CGRectMake(20, (KHEIGHT-30)/2, 30, 30);
    self.nameLAB.frame = CGRectMake(60, (KHEIGHT-20)/2, 200, 20);
}


-(void)setTitle:(NSString *)title {
    self.nameLAB.text = title;
}

@end
