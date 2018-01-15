//
//  AddRosterGroupHeader.h
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddRosterGroupHeaderBlock)(void);


@interface AddRosterGroupHeader : UICollectionReusableView


@property (nonatomic, strong) AddRosterGroupHeaderBlock aAddRosterGroupHeaderBlock;

@end
