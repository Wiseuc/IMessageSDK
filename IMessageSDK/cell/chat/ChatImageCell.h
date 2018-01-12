//
//  ChatImageCell.h
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
typedef void(^ChatImageCellTapBlock)(Message *model);


@interface ChatImageCell : UICollectionViewCell

@property (nonatomic, strong) Message *model;

@property (nonatomic, strong) UIImageView *contentIMGV;  /**背景**/
//tapG点击手势
-(void)settingChatImageCellTapBlock:(ChatImageCellTapBlock)aBlock;

@end
