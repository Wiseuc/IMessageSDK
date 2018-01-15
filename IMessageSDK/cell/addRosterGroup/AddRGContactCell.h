//
//  AddRGContactCell.h
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRGContactModel.h"
typedef void(^AddRGContactCellBlock)(AddRGContactModel *model);


@interface AddRGContactCell : UICollectionViewCell


@property (nonatomic, strong) AddRGContactModel *model;


@property (nonatomic, strong) AddRGContactCellBlock aAddRGContactCellBlock;

@end
