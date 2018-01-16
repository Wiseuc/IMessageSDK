//
//  MineQRCodeController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/16.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "MineMakeQRCodeController.h"
#import "ZXingObjC.h"
#import "UIConfig.h"
#import "LTSDKFull.h"
#import "SVProgressHUD.h"





@interface MineMakeQRCodeController ()


@property (nonatomic, strong) UIImageView *iconIMGV;  /**头像**/
@property (nonatomic, strong) UIImageView *imageview;  /**二维码**/

@property (nonatomic, strong) UILabel *nameLAB;
@property (nonatomic, strong) UILabel *addressLAB;

@property (nonatomic, strong) UIImageView *iconCenterIMGV;  /**二维码中间头像**/
@property (nonatomic, strong) UILabel *noticeLAB;  /**提示**/
@end







@implementation MineMakeQRCodeController

#pragma mark - UI

-(void)settingUI {
    self.title = @"我的二维码";

    
    //背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //容器0
    UIView *rootview = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:rootview];
    rootview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    
    
    CGFloat WIDTH = 320.0;
    CGFloat HEIGHT = 420;
    
    //容器
    UIView *panel = [[UIView alloc] init];
    panel.frame = CGRectMake((kScreenWidth-WIDTH)/2, (kScreenHeight-HEIGHT+64)/2, WIDTH, HEIGHT);
    [rootview addSubview:panel];
    panel.backgroundColor = [UIColor whiteColor];
    panel.layer.cornerRadius = 4;
    panel.layer.masksToBounds = YES;
    
    //头像
    self.iconIMGV = [[UIImageView alloc] init];
    [panel addSubview:self.iconIMGV];
    self.iconIMGV.frame = CGRectMake(40, 20, 50, 50);
    self.iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
//    self.iconIMGV.layer.borderWidth = 1;
    
    //nameLAB
    self.nameLAB = [[UILabel alloc] init];
    [panel addSubview:self.nameLAB];
    self.nameLAB.text = @"江海sann";
    self.nameLAB.frame = CGRectMake(100, 20, 320-80-20, 30);
    self.nameLAB.font = [UIFont systemFontOfSize:18.0];
//    self.nameLAB.layer.borderWidth = 1;
    
    //nameLAB
    self.addressLAB = [[UILabel alloc] init];
    [panel addSubview:self.addressLAB];
    self.addressLAB.text = @"中国香港 九龙城区";
    self.addressLAB.frame = CGRectMake(100, 50, 320-80-20, 20);
    self.addressLAB.textColor = [UIColor grayColor];
    self.addressLAB.font = [UIFont systemFontOfSize:14.0];
//    self.addressLAB.layer.borderWidth = 1;
    
    
    //二维码
    self.imageview = [[UIImageView alloc] init];
    [panel addSubview:self.imageview];
    self.imageview.frame = CGRectMake(0, HEIGHT-WIDTH-30, WIDTH, WIDTH);
    self.imageview.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
//    self.imageview.layer.borderWidth = 1;

    
    //nameLAB
    self.noticeLAB = [[UILabel alloc] init];
    [panel addSubview:self.noticeLAB];
    self.noticeLAB.text = @"扫一扫上面的二维码图案，加我好友";
    self.noticeLAB.frame = CGRectMake(0, HEIGHT-30, WIDTH, 20);
    self.noticeLAB.textColor = [UIColor grayColor];
    self.noticeLAB.textAlignment = NSTextAlignmentCenter;
    self.noticeLAB.font = [UIFont systemFontOfSize:14.0f];
//    self.noticeLAB.layer.borderWidth = 1;
}


-(void)settingData {
    
    //名字
    NSDictionary *userdict = [LTUser.share queryUser];
    NSString *JID = [NSString stringWithFormat:@"wiseuc:%@",userdict[@"JID"]];
    NSString *UserName = userdict[@"UserName"];
    [self settingQRCodeWithJID:JID username:UserName];
    self.nameLAB.text = UserName;
    
    //手机号
    NSDictionary *orgdict = [LTOrg queryInformationByJid:userdict[@"JID"]];
    __block NSString *mobile = orgdict[@"MOBILE"];

    
    if (mobile == nil || mobile.length < 7) {
        __weak typeof(self) wealself = self;
        [LTFriend.share queryRosterVCardByJID:userdict[@"JID"] completed:^(NSDictionary *dict) {
            mobile = dict[@"CELL"];
            if (mobile == nil || mobile.length < 7) {
                mobile = @"暂无";
            }
            wealself.addressLAB.text = [NSString stringWithFormat:@"手机号: %@",mobile];
        }];
    }
    self.addressLAB.text = [NSString stringWithFormat:@"手机号: %@",mobile];
}

-(void)settingQRCodeWithJID:(NSString *)aJID
                   username:(NSString *)aUsername  {
    
    ZXEncodeHints *hints = [ZXEncodeHints hints];
    hints.encoding = NSUTF8StringEncoding;
    // 设置编码类型
    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:aJID
                                  format:kBarcodeFormatQRCode
                                   width:self.imageview.frame.size.width
                                  height:self.imageview.frame.size.width
                                   hints:hints
                                   error:&error];
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"error：二维码生成出现错误"];
    }
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.imageview.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.imageview.image = nil;
    }
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
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [kMainVC hiddenTbaBar];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [kMainVC showTbaBar];
}








#pragma mark - Init
//
//-(UIImageView *)imageview{
//    if (!_imageview) {
//        _imageview = [[UIImageView alloc] init];
//        _imageview.frame = CGRectMake((kScreenWidth-320)/2, (kScreenHeight-320)/2, 320, 320);
//        _imageview.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
//    }
//    return _imageview;
//}


@end
