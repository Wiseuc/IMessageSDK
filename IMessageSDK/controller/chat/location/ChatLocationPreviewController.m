//
//  ChatLocationPreviewController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatLocationPreviewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "UIConfig.h"









@interface ChatLocationPreviewController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AMapLocationManagerDelegate
>

@property (nonatomic, strong) Message       *message;
@property (nonatomic, strong) MAMapView     *mapview;
@end










@implementation ChatLocationPreviewController

#pragma mark - UI

-(void)settingUI{
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
    [self.view addSubview:self.mapview];
}










#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"位置预览";
    
    [self settingUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [kMainVC hiddenTbaBar];
    
    
    //添加标注
    MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
    anno.coordinate =
    CLLocationCoordinate2DMake(self.message.latitude.floatValue, self.message.longitude.floatValue);
    anno.title = self.message.body;
    anno.subtitle = self.message.address;
    [self.mapview addAnnotation:anno];
    
    
    //设置中心点
    CLLocationCoordinate2D coor2D
    = CLLocationCoordinate2DMake(self.message.latitude.floatValue, self.message.longitude.floatValue);
    [self.mapview setCenterCoordinate:(coor2D) animated:YES];
    
    
    //设置缩放级别
    [self.mapview setZoomEnabled:YES];
    [self.mapview setZoomLevel:15 animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [kMainVC showTbaBar];
}










#pragma mark - 代理：MAMapView

/**标注样式**/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isMemberOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView01 = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView01 == nil)
        {
            annotationView01 = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView01.canShowCallout               = YES;
        annotationView01.animatesDrop                 = YES;
        annotationView01.draggable                    = YES;
        annotationView01.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView01.pinColor                     = MAPinAnnotationColorRed;
        //annotationView.image = [UIImage imageNamed:@"location_icon"];
        //annotationView.centerOffset = CGPointMake(0, - 18);
        return annotationView01;
    }
    
    //    /* 自己标注*/
    //    if ([annotation isMemberOfClass:[MAUserLocation class]])
    //    {
    //        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
    //        MAAnnotationView *annotationView02 = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
    //        if (annotationView02 == nil)
    //        {
    //            annotationView02 = [[MAAnnotationView alloc] initWithAnnotation:annotation
    //                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
    //        }
    //        annotationView02.image = [UIImage imageNamed:@"userPosition"];
    //        annotationView = annotationView02;
    //    }
    
    return nil;
}














#pragma mark - Init

- (instancetype)initWithMessage:(Message *)message
{
    self = [super init];
    if (self) {
        _message = message;
    }
    return self;
}

-(MAMapView *)mapview{
    if (!_mapview) {
        _mapview = [[MAMapView alloc] init];
        _mapview.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
        _mapview.delegate = self;
        _mapview.mapType = MAMapTypeStandard;
        _mapview.showsUserLocation = YES;  /**显示自己定位**/
        _mapview.userTrackingMode = MAUserTrackingModeFollow;  /**定位模式：普通、追随、追随+方位**/
        
        //_mapview.zoomLevel = 15;  /**地图缩放水平：越高越清晰**/
        //        [_mapview setZoomEnabled:NO]
        
    }
    return _mapview;
}


@end
