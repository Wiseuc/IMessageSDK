//
//  AddRGScanQRCodeController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/16.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AddRGScanQRCodeController.h"
#import "ZXingObjC.h"
#import "UIConfig.h"
#import "LTSDKFull.h"
#import "SVProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>
#import "InformationController.h"





@interface AddRGScanQRCodeController ()<ZXCaptureDelegate>
{
    CGAffineTransform _captureSizeTransform;
    int index;
}
@property (nonatomic, strong) UIView *scanview;
@property (nonatomic, strong) ZXCapture *capture;
@end








@implementation AddRGScanQRCodeController

#pragma mark - UI

-(void)settingUI {
    
    [self.view addSubview:self.scanview];
    
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.scanview];
}











#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingUI];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self applyOrientation];
    
    [kMainVC hiddenTbaBar];
    
    index = 0;
    
    [self.capture start];
}
- (void)dealloc {
    [self.capture.layer removeFromSuperlayer];
}

















#pragma mark - private


/**
 修改方向
 **/
- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];
    self.capture.layer.frame = self.view.frame;
}
/**
 扫描的兴趣范围
 **/
- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = self.scanview.frame;
    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        videoSizeX = 1080;
        videoSizeY = 1920;
    } else {
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}
/**
 条形码类型转字符串
 **/
- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}
















#pragma mark - 代理：UIviewController

/**
 是否可以自动旋转屏幕
 **/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
/**
 已经选择屏幕
 **/
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self applyOrientation];
}
/**
 视图将会转换成新的size
 **/
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self applyOrientation];
     }];
}


















#pragma mark - 代理：ZXCapture

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (result == nil){ return;}
    
    
    if (index > 0) {
        return;
    }
    
//    CGAffineTransform inverse = CGAffineTransformInvert(_captureSizeTransform);
//    NSMutableArray *points = [[NSMutableArray alloc] init];
//    NSString *location = @"";
    
    //point
//    for (ZXResultPoint *resultPoint in result.resultPoints)
//    {
//        CGPoint cgPoint = CGPointMake(resultPoint.x, resultPoint.y);
//        CGPoint transformedPoint = CGPointApplyAffineTransform(cgPoint, inverse);
//        transformedPoint = [self.scanview convertPoint:transformedPoint toView:self.scanview.window];
//        NSValue* windowPointValue = [NSValue valueWithCGPoint:transformedPoint];
//        location = [NSString stringWithFormat:@"%@ (%f, %f)", location, transformedPoint.x, transformedPoint.y];
//        [points addObject:windowPointValue];
//    }
    
    
    /**
     result：
     
     barcodeFormat = kBarcodeFormatQRCode
     text = http://weixin.qq.com/r/skyWjg7ER1M4rUrt9xmg
     
     resultPoints =
     <__NSArrayM 0x1c04573d0>(
     (225.000000,162.500000),
     (230.500000,29.000000),
     (374.000000,36.000000),
     (350.500000,155.000000)
     )
     **/
    
    //码的类型（条形码、二维码）
//    NSString *formatStr = [self barcodeFormatToString:result.barcodeFormat];
//    NSString *display = [NSString stringWithFormat:@"\nScanned!  \nFormat:%@  \nContents:%@", formatStr, result.text];
//    NSLog(@"dispaly = %@",display);
    
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.capture stop];
    
    index = index + 1;
    InformationController *vc = [[InformationController alloc] initWithJID:result.text];
    [self.navigationController pushViewController:vc animated:YES];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self.capture start];
//    });
}














#pragma mark - Init

-(UIView *)scanview{
    if (!_scanview) {
        _scanview = [[UIView alloc] init];
        _scanview.frame = CGRectMake((kScreenWidth-200)/2, (kScreenHeight-200)/2, 200, 200);
        _scanview.layer.borderWidth = 1;
        _scanview.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return _scanview;
}

-(ZXCapture *)capture{
    if (!_capture) {
        _capture = [[ZXCapture alloc] init];
        
        _capture.delegate = self;
        _capture.camera = self.capture.back;
        _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        _capture.layer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        //_capture.sessionPreset = AVCaptureSessionPreset1920x1080;
    }
    return _capture;
}

@end
