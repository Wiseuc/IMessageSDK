//
//  SelectGroupMemberController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//选择群成员

#import "SelectGroupMemberController.h"
#import "UIConfig.h"






@interface SelectGroupMemberController ()

@property (nonatomic, strong) SelectGroupMemberBlock aSelectGroupMemberBlock;
@end









@implementation SelectGroupMemberController






#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = kBackgroundColor;
    
    self.title = @"选择群成员";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







#pragma mark - Public

-(void)selectGroupMember:(SelectGroupMemberBlock)aBlock {
    self.aSelectGroupMemberBlock = aBlock;
}





@end
