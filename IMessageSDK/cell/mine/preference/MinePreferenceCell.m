//
//  MinePreferenceCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "MinePreferenceCell.h"
#import "PreferenceManager.h"

@interface MinePreferenceCell ()
@property (nonatomic, strong) UILabel *nameLAB;       /**名字**/
@property (nonatomic, strong) UISwitch *rightSWITCH;  /**右侧>**/


@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *title;
@end








@implementation MinePreferenceCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.rightSWITCH = [[UISwitch alloc] init];
        [self.contentView addSubview:self.rightSWITCH];
        self.rightSWITCH.on = YES;
        
        
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
    
    self.nameLAB.frame = CGRectMake(10, (KHEIGHT-20)/2, 100, 20);
    self.rightSWITCH.frame = CGRectMake(KWIDTH-60, (KHEIGHT-30)/2, 50, 30); //默认为 49 * 31
}







-(void)setTitle:(NSString *)title
      indexpath:(NSIndexPath *)indexpath {
    
    self.title = title;
    self.indexPath = indexpath;
    
    self.nameLAB.text = title;
    
    
    switch (indexpath.item) {
        case 0:
        {
            BOOL ret = [PreferenceManager.share queryPreference_voice];
            self.rightSWITCH.on = ret;
        }
            break;
            
        case 1:
        {
            BOOL ret = [PreferenceManager.share queryPreference_virate];
            self.rightSWITCH.on = ret;
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}
//-(void)setAMinePreferenceCellBlock:(MinePreferenceCellBlock)aMinePreferenceCellBlock {
//    _aMinePreferenceCellBlock = aMinePreferenceCellBlock;
//}


@end
