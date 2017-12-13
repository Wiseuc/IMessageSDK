//
//  UIViewController+child.h
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (child)


/**添加子控制器**/
- (void)jianghai_addChildController:(UIViewController *)aChildVC;
- (void)jianghai_addChildController:(UIViewController *)aChildVC  rect:(CGRect)aRect;
/**删除子控制器**/
- (void)jianghai_removeAllChildController ;
- (void)jianghai_removeAllChildController:(UIViewController *)aChildVC ;
    
@end
