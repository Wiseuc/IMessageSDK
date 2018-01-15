//
//  ChatFilePreviewController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatFilePreviewController.h"
#import "UIConfig.h"
#import "SVProgressHUD.h"


@interface ChatFilePreviewController ()
@property (nonatomic, strong) UITextView *textview;
@end









@implementation ChatFilePreviewController


#pragma mark - UI

-(void)settingUI{
    [self.view addSubview:self.textview];
}

-(void)settingData{
    
    
    
    NSFileManager *manager = NSFileManager.defaultManager;
    
    //最好先判断文件是否存在
    BOOL isExist = [manager fileExistsAtPath:self.message.localPath];
    if (!isExist) {
        NSString *errStr = @"\n错误 \n\n1.文件不存在 \n2.软件已重装";
        UILabel *warnLAB =
        [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight-200)/2, kScreenWidth, 200)];
        [self.view addSubview:warnLAB];
        warnLAB.font = [UIFont boldSystemFontOfSize:20];
        warnLAB.text = errStr;
        warnLAB.numberOfLines = 0;
//        [warnLAB sizeToFit];
        warnLAB.textAlignment = NSTextAlignmentCenter;
        return;
    }
    
    //抽取内容
    NSString *content =
    [[NSString alloc] initWithContentsOfFile:self.message.localPath
                                    encoding:(NSUTF8StringEncoding)
                                       error:nil];
    self.textview.text = content;
}









#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self settingUI];

    [self settingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [kMainVC hiddenTbaBar];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [kMainVC showTbaBar];
}








#pragma mark - Private






#pragma mark - Init

- (instancetype)initWithMessage:(Message *)message
{
    self = [super init];
    if (self) {
        self.message = message;
        self.title = message.body;
    }
    return self;
}
-(UITextView *)textview{
    if (!_textview) {
        _textview = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textview.editable = NO;
    }
    return _textview;
}



@end
