//
//  GuideController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/12.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "GuideController.h"
#import "UIConfig.h"

@interface GuideController ()

@end

@implementation GuideController

#pragma mark -================= UI

- (void)settingUI {
    
    int num = 3;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(num * kScreenWidth, kScreenHeight);
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < num; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"img_intro_%d_320x568_",i+1];
        UIImageView *imageView =
        [[UIImageView alloc] initWithFrame:
         CGRectMake(i * kScreenWidth, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        
        if (i == num-1)
        {
            imageView.userInteractionEnabled = YES;
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [enterButton setTitle:@"进入主程序" forState:(UIControlStateNormal)];
            [enterButton setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
            enterButton.layer.cornerRadius = 20.0;
            enterButton.layer.masksToBounds = YES;
            [enterButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [imageView addSubview:enterButton];
            enterButton.frame = CGRectMake((kScreenWidth - 100)/2, kScreenHeight - 50, 100, 40);
            [enterButton addTarget:self action:@selector(enterTabbarPage) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)enterTabbarPage
{
    if (_enterBlock) {
        _enterBlock(YES);
    }
}




#pragma mark -================= runLoop
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark -================= Init
-(void)setEnterBlock:(GuideControllerEnterBlock)enterBlock {
    _enterBlock = enterBlock;
}

@end
