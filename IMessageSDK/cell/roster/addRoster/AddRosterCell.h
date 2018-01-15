//
//  AddRosterCell.h
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgModel.h"
typedef void(^AddRosterCellBlock)(OrgModel *model);

@interface AddRosterCell : UICollectionViewCell


@property (nonatomic, strong) OrgModel *model;


@property (nonatomic, strong) AddRosterCellBlock aAddRosterCellBlock;

@end
