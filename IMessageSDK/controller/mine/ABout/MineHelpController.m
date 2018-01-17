//
//  MineHelpController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "MineHelpController.h"
#import "UIConfig.h"
#import "SVProgressHUD.h"







@interface MineHelpController ()
<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webview;
@end









@implementation MineHelpController

#pragma mark - UI

-(void)settingUI {
    self.view.backgroundColor = kBackgroundColor;
    
    self.title = @"帮助";
    
    [SVProgressHUD showWithStatus:@"loading..."];
    
    //网页
    self.webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenHeight, kScreenHeight - 64)];
    [self.view addSubview:self.webview];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kMine_Web_Help]]];
    self.webview.delegate = self;
    
}

-(void)settingData {
    
    
}









#pragma mark - 代理：webview

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    
    //消除广告
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('down-footer').remove()"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementByClassName('toast').remove()"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
}







#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingUI];
    
    [self settingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Init


@end
