//
//  TabbarController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "TabbarController.h"
#import "ChatListController.h"
#import "MineController.h"
#import "RosterController.h"
#import "UIConfig.h"
#import "LTSDKFull.h"
#import "Message.h"
#import "SVProgressHUD.h"


@interface TabbarController ()

@end

@implementation TabbarController

#pragma mark - UI

#pragma mark -================= UI

-(void)settingUI {
    
    ChatListController *chatvc = [[ChatListController alloc] init];
    RosterController *contactvc = [[RosterController alloc] init];
    MineController *minevc = [[MineController alloc] init];
    
    NSArray *vcs = @[
                     chatvc,  /**聊天**/
                     contactvc,  /**联系人**/
                     minevc,  /**我的**/
                     ];
    
    NSMutableArray *navs = [NSMutableArray array];
    NSArray *titles =
  @[
    @"聊天",
    @"联系人",
    @"我的"
    ];
    
    NSArray *iconNames =
  @[
    @"shouye_changtai",
    @"fuwu_changtai",
    @"wode_changtai"
    ];
    
    NSArray *selectedIconNames =
  @[
    @"shouye_xuanzhong",
    @"fuwu_xuanzhong",
    @"wode_xuanzhong"
    ];
    
    
    for (NSInteger i = 0 ; i < vcs.count; i ++) {
        UIViewController *vc = vcs[i];
        NSString *title = titles[i];
        NSString *iconName = iconNames[i];
        NSString *selectedIconName = selectedIconNames[i];
        
        UINavigationController *nav =
        [[UINavigationController alloc] initWithRootViewController:vc];
        
        nav.tabBarItem.image =
        [[UIImage imageNamed:iconName]
         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        nav.tabBarItem.selectedImage =
        [[UIImage imageNamed:selectedIconName]
         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //nav.title = title;
        vc.title = title;
        UIColor *textColor = kTintColor;
        [nav.tabBarItem
         setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor}
         forState:UIControlStateSelected];
        [navs addObject:nav];
    }
    self.viewControllers = navs;
    
    /**添加自定义按钮**/
//    UIButton *openDoorBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
//    [openDoorBTN setBackgroundImage:[UIImage imageNamed:@"kaimen_xuanzhong"] forState:(UIControlStateNormal)];
//    openDoorBTN.frame = CGRectMake((kScreenWidth - 60)/2, -30, 60, 60);
//    [self.tabBar addSubview:openDoorBTN];
//    [openDoorBTN addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
}


//皮肤设置
- (void)settingAppearence {
    
    //UIView.appearance.backgroundColor = kBackgroundColor;
    
    
    //最底层绿色
    //    UITabBar.appearance.backgroundColor = THEM_COLOR;
    //    UINavigationBar.appearance.backgroundColor = THEM_COLOR;
    
    //最顶层绿色
    //UITabBar.appearance.barTintColor = kTintColor;
    UINavigationBar.appearance.barTintColor = kTintColor;
    
    
    //导航栏title字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //导航栏左右字体颜色
    [UINavigationBar.appearance setTintColor:[UIColor whiteColor]];
}











#pragma mark - runLoop

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
    
    [self settingAppearence];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //默认选择显示中间控制器
    //self.selectedIndex = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - private
#pragma mark -================= Private

//- (void)buttonClick:(UIButton *)sender {
//
//    NSUInteger selectIndex = self.selectedIndex;
//    ZHXQ_TelOpenController  *telVC = [[ZHXQ_TelOpenController alloc] init];
//    [self.viewControllers.firstObject.navigationController pushViewController:telVC animated:YES];
//    UINavigationController *nav = self.viewControllers[selectIndex];
//    [nav pushViewController:telVC animated:YES];
//}




#pragma mark - Init
@end
