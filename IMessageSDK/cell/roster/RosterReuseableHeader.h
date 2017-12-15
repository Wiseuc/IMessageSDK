//
//  RosterReuseableHeader.h
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RosterReuseableHeaderSelectBlock)(NSInteger tag);

@interface RosterReuseableHeader : UICollectionReusableView

@property (nonatomic, strong) RosterReuseableHeaderSelectBlock aRosterReuseableHeaderSelectBlock;

@end
