//
//  VideoController.m
//  LTClient_Pro
//
//  Created by JH on 2017/11/21.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "VideoController.h"
#import "LTSDKFull.h"
//#import "LTLinphoneManager.h"
//#import "AppDelegate.h"
//#import "UIViewController+Bar.h"

//NSString *const kVideoCallUpdate  = @"LinphoneCallUpdate";   //通话更新

@interface VideoController ()

@property (nonatomic, strong) NSString  *otherPID; /**对方pid**/
@property (nonatomic, strong) NSString     *otherJID; /**对方jid**/


@property (nonatomic, strong) UILabel      *chatterLabel; /**对方名字**/
@property (nonatomic, strong) UIButton     *hangupBTN;    /**挂断按钮**/
@property (nonatomic, strong) UIButton     *acceptBTN;    /**接听按钮**/
@property (nonatomic, strong) UIButton     *videoBTN;     /**视频按钮**/
@property (nonatomic, strong) UIView       *chatterView;  /**对方视频图层**/
@property (nonatomic, strong) UIView       *myView;       /**自己视频图层**/
@end








@implementation VideoController

#pragma mark - UI

-(void)settingUI {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat WIDTH  = UIScreen.mainScreen.bounds.size.width;
    CGFloat HEIGHT = UIScreen.mainScreen.bounds.size.height;
    
    /**对方视频图层**/
    self.chatterView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.chatterView];
    
    /**自己视频图层**/
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 80, HEIGHT - 320, 80, 100)];
    [self.view addSubview:self.myView];
    
    /**对方名字**/
    self.chatterLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 100, 20)];
    [self.view addSubview:self.chatterLabel];
    self.chatterLabel.text = @"";
    self.chatterLabel.font = [UIFont systemFontOfSize:30];
    self.chatterLabel.textAlignment = NSTextAlignmentCenter;
    
    /**拒绝按钮**/
    self.hangupBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    self.hangupBTN.frame = CGRectMake((WIDTH - 60)/2, (HEIGHT - 80), 60, 60);
    
    [self.hangupBTN setImage:[[UIImage imageNamed:@"refuseBTN"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    forState:UIControlStateNormal];
    [self.view addSubview: self.hangupBTN];

    /**挂断按钮**/
    self.acceptBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    self.acceptBTN.frame = CGRectMake(WIDTH - 80, (HEIGHT - 80), 60, 60);
    [self.acceptBTN setImage:[[UIImage imageNamed:@"acceptBTN"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                    forState:UIControlStateNormal];
    [self.view addSubview: self.acceptBTN];
    
    
    /**挂断按钮**/
    self.videoBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    self.videoBTN.frame = CGRectMake(20, (HEIGHT - 80), 60, 60);
    [self.videoBTN setImage:[[UIImage imageNamed:@"cameraBTN"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                    forState:UIControlStateNormal];
    [self.view addSubview: self.videoBTN];
    
    
    
    self.hangupBTN.tag  = 1001;
    self.acceptBTN.tag  = 1002;
    self.videoBTN.tag   = 1003;
    [self.hangupBTN addTarget:self
                       action:@selector(buttonClick:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.acceptBTN addTarget:self
                       action:@selector(buttonClick:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.videoBTN addTarget:self
                       action:@selector(buttonClick:)
             forControlEvents:UIControlEventTouchUpInside];
}













#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingUI];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sendCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}















#pragma mark - Private

-(void)buttonClick:(UIButton *)sender {
    /**挂断**/
    if (sender.tag == 1001)
    {
//        [LTLinphoneManager.defaultManager hangup];
        [self back];
    }
    /**接听**/
    else if (sender.tag == 1002)
    {
//        [LTLinphoneManager.defaultManager acceptWithChatterView:self.chatterView myView:self.myView];
    }
    else if (sender.tag == 1003)
    {
//        [LTLinphoneManager.defaultManager openCamara];
    }
}
/**拨打**/
-(void)sendCall {
    
    
    
    
    
}
















#pragma mark - Init

- (instancetype)initWithPID:(NSString *)aPID
{
    self = [super init];
    if (self) {
        self.otherPID = aPID;
    }
    return self;
}


@end
