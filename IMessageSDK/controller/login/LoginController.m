//
//  LoginController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LoginController.h"
#import "SVProgressHUD.h"
#import "LTSDKFull.h"
#import "UIConfig.h"

@interface LoginController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *usernameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *loginBTN;
@end




@implementation LoginController

#pragma mark -================= UI

- (void)settingUI {
    self.view.backgroundColor = kBackgroundColor;
    
    /**用户名**/
    self.usernameTF = [[UITextField alloc] init];
    self.usernameTF.frame = CGRectMake(20, 200, kScreenWidth-40, 40);
    [self.view addSubview:self.usernameTF];
    self.usernameTF.placeholder = @"username";
    self.usernameTF.text = @"江海";
    self.usernameTF.layer.borderWidth = 1.0;
    self.usernameTF.layer.borderColor =
    [[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
    self.usernameTF.delegate = self;
    
    /**密码**/
    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.frame = CGRectMake(20, 250, kScreenWidth-40, 40);
    [self.view addSubview:self.passwordTF];
    self.passwordTF.placeholder = @"password";
    self.passwordTF.text = @"666666";
    self.passwordTF.layer.borderWidth = 1.0;
    self.passwordTF.layer.borderColor =
    [[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
    self.passwordTF.delegate = self;
    
    /**登录**/
    self.loginBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.loginBTN.frame = CGRectMake(20, 300, kScreenWidth-40, 40);
    [self.view addSubview:self.loginBTN];
    [self.loginBTN setBackgroundColor: kDarkGreenColor];
    [self.loginBTN setTitle:@"login" forState:(UIControlStateNormal)];
    self.loginBTN.layer.cornerRadius = 20;
    self.loginBTN.layer.masksToBounds = YES;
    [self.loginBTN setTitleColor:[UIColor whiteColor]
                        forState:(UIControlStateNormal)];
    [self.loginBTN addTarget:self
                      action:@selector(buttonClick:)
            forControlEvents:(UIControlEventTouchUpInside)];
}
/**键盘监听**/
- (void)settingKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardHide)
     name:UIKeyboardWillHideNotification
     object:nil];
}
- (void) keyboardShow:(NSNotification *)no
{
    /**
     {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 251.5}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 693.75}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 442.25}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 568}, {320, 251.5}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 316.5}, {320, 251.5}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     }
     **/
    NSDictionary *dic = no.userInfo;
    id objFrame = dic[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect kbFrame = {0};
    [objFrame getValue:&kbFrame];
    
    /**键盘**/
    CGFloat kbMinY = kbFrame.origin.y;
    CGFloat kbH    = kbFrame.size.height;
    //视图
    CGFloat btnMaxY =  CGRectGetMaxY(self.loginBTN.frame);
    
    if (btnMaxY+20 > kbMinY)
    {
        CGRect tempFrame = self.view.frame;
        /**标准Y**/
        CGFloat standY = kScreenHeight - (kbH + 20);
        /**现在Y**/
        CGFloat nowY   = btnMaxY;
        /**Y差距**/
        CGFloat distance = nowY - standY;
        
        tempFrame.origin.y = tempFrame.origin.y - distance;
        
        self.view.frame = tempFrame;
    }
}
- (void)keyboardHide
{
    self.view.frame = self.view.bounds;
}







#pragma mark -================= runLoop

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingKeyBoardNotification];
    [self settingUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}







#pragma mark -================= Private

- (void)buttonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self doLogin];
}
- (void)doLogin{
    
    BOOL ret1 = [self.usernameTF.text isEqualToString:@""];
    BOOL ret2 = [self.passwordTF.text isEqualToString:@""];
    if (ret1 || ret2) {
        [SVProgressHUD showErrorWithStatus:@"用户名和密码不能为空"];
        return;
    }
    __weak typeof(self) weakself = self;
    [SVProgressHUD showWithStatus:@"登录中"];
    [LTLogin.share asyncLoginWithUsername:self.usernameTF.text
                                 password:self.passwordTF.text
                                 serverIP:@"im.lituosoft.cn"
                                     port:@"5223"
                                completed:^(LTError *error) {
                                    [SVProgressHUD dismiss];
                                    if (error) {
                                        NSLog(@"%@",error.localDescription);
                                        [weakself loginFailureAction];
                                    }else{
                                        NSLog(@"登录成功");
                                        [weakself loginSuccessAction];
                                    }
                                }];
}
- (void)loginSuccessAction {
//    UIViewController *vc = kAppDelegate.mainvc;
}
- (void)loginFailureAction {
    [SVProgressHUD showErrorWithStatus:@"登录失败"];
//    [_loginView hideServerView];
}












#pragma mark -================= Init

@end
