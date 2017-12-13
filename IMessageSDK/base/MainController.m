//
//  MainController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "MainController.h"
#import "GuideController.h"
#import "TabbarController.h"
#import "LoginController.h"
#import "LTSDKFull.h"
#import "AppUtility.h"
#import "UIViewController+child.h"


@interface MainController ()
@property (nonatomic, strong) LoginController     *loginController;
@property (nonatomic, strong) GuideController     *guideController;
@property (nonatomic, strong) TabbarController    *tabBarController;
@end




@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginController = [[LoginController alloc] init];
    self.guideController = [[GuideController alloc] init];
    self.tabBarController = [[TabbarController alloc] init];
    
    //是否首次登录
    BOOL ret = [AppUtility queryIsFirstLaunching];
    if (ret)
    {
        __weak typeof(self) weakself = self;
        [self showGuideController];
        [self.guideController setEnterBlock:^(BOOL ret) {
            if (ret) {
                [AppUtility updateIsFirstLaunching:NO];
                [weakself showLoginController];
            }
        }];
        
    }else{
        [self showLoginController];
    }
}


- (void)showLoginController {
    [self jianghai_removeAllChildController];
    [self jianghai_addChildController:self.loginController];
}
- (void)showGuideController {
    [self jianghai_removeAllChildController];
    [self jianghai_addChildController:self.guideController];
}
- (void)showTabBarController {
    [self jianghai_removeAllChildController];
    [self jianghai_addChildController:self.tabBarController];
}




@end
