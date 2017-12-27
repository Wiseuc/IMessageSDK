//
//  SelectGroupMemberController.h
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectGroupMemberBlock)(NSArray *arr);


@interface SelectGroupMemberController : UIViewController


-(void)selectGroupMember:(SelectGroupMemberBlock)aBlock;

@end
