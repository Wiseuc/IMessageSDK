//
//  AddGroupCell.h
//  IMessageSDK
//
//  Created by JH on 2018/1/16.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupModel.h"
typedef void(^AddGroupCellBlock)(GroupModel *model);


@interface AddGroupCell : UICollectionViewCell
@property (nonatomic, strong) GroupModel *model;
@property (nonatomic, strong) AddGroupCellBlock aAddGroupCellBlock;
@end
