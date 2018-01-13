//
//  ChatLocationController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/13.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatLocationController.h"
#import "UIConfig.h"







@interface ChatLocationController ()

@end










@implementation ChatLocationController


#pragma mark - UI








#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBackgroundColor;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [kMainVC hiddenTbaBar];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [kMainVC showTbaBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private







#pragma mark - 代理




#pragma mark - Init

@end
