//
//  UIViewController+child.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "UIViewController+child.h"

@implementation UIViewController (child)

/**添加子控制器**/
- (void)jianghai_addChildController:(UIViewController *)aChildVC {
    [self jianghai_addChildController:aChildVC rect:self.view.bounds];
}
- (void)jianghai_addChildController:(UIViewController *)aChildVC  rect:(CGRect)aRect{
    [self addChildViewController:aChildVC];
    [self.view addSubview:aChildVC.view];
    aChildVC.view.frame = aRect;
    [aChildVC didMoveToParentViewController:self];
}


/**删除子控制器**/
- (void)jianghai_removeAllChildController {
    for (UIViewController *aChildVC in self.childViewControllers) {
        [self jianghai_removeAllChildController:aChildVC];
    }
}
- (void)jianghai_removeAllChildController:(UIViewController *)aChildVC {
    [aChildVC willMoveToParentViewController:nil];
    [aChildVC.view removeFromSuperview];
    [aChildVC removeFromParentViewController];
}


@end
