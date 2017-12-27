//
//  SelectGroupMemberCell.h
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgModel.h"
typedef void(^SelectGroupMemberCellBlock)(OrgModel *model);


@interface SelectGroupMemberCell : UITableViewCell

@property (nonatomic, strong) OrgModel *model;

-(void)setModel:(OrgModel *)model completed:(SelectGroupMemberCellBlock)aBlock;

@end
