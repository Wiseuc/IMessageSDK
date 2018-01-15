//
//  ChatLocationCell.h
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
typedef void(^ChatLocationCellTapBlock)(Message *model);

@interface ChatLocationCell : UICollectionViewCell

@property (nonatomic, strong) Message *model;


@property (nonatomic, strong) ChatLocationCellTapBlock aChatLocationCellTapBlock;


@end
