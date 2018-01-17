//
//  MinePreferenceCell.h
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^MinePreferenceCellBlock)(NSIndexPath *indexpath);

@interface MinePreferenceCell : UICollectionViewCell

-(void)setTitle:(NSString *)title
      indexpath:(NSIndexPath *)indexpath;



//@property (nonatomic, strong) MinePreferenceCellBlock aMinePreferenceCellBlock;
@end
