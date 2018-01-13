//
//  ChatLocationController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/13.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatLocationController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"

#import "ChatLocationModel.h"
//#import "CommonUtility.h"

#import "ChatLocationCell2.h"



@interface ChatLocationController ()
<
MAMapViewDelegate,
AMapSearchDelegate,
AMapLocationManagerDelegate,

CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) MAMapView     *mapview;
@property (nonatomic, strong) AMapSearchAPI *searchApi; /**搜索者**/
@property (nonatomic, strong) AMapLocationManager *locationManager;  /**定位管理类**/

//POI
@property (nonatomic, strong) AMapPOIAroundSearchRequest *aroundRequest;  /**周边搜索**/



@property (nonatomic, strong) CLLocation *myLocation;  /**自己定位的坐标**/
@property (nonatomic, strong) AMapLocationReGeocode *myReGeocode;  /**自己定位的逆地址**/



@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end










@implementation ChatLocationController


#pragma mark - UI

-(void)settingUI{
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
    [self.view addSubview:self.mapview];
    
    [self.view addSubview:self.collectionview];
}

-(void)settingUIBarButtonItem{
    
    UIBarButtonItem *right_item =
    [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                     style:(UIBarButtonItemStylePlain)
                                    target:self
                                    action:@selector(sendAddress)];
    self.navigationItem.rightBarButtonItems = @[right_item];
}

-(void)settingData {
    
    [self action_startUpdatingLocation];
}







#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self settingUI];
    
    [self settingUIBarButtonItem];
    
    [self settingData];
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
/**发送地址**/
-(void)sendAddress{
    for (ChatLocationModel *model in self.datasource) {
        if (model.isSelected) {
            if (self.aChatLocationControllerBlock) {
                self.aChatLocationControllerBlock(model);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

/**开始定位：持续性的**/
-(void)action_startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
}
-(void)action_stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}


/**开始POI周边搜索**/
-(void)action_aroundRequest {
    float latitude = self.myLocation.coordinate.latitude;
    float longitude = self.myLocation.coordinate.longitude;
    self.aroundRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    [self.searchApi AMapPOIAroundSearch:self.aroundRequest];
}
/**取消所有未回调的请求，触发错误回调。**/
-(void)action_cancelAllSearch {
    [self.searchApi cancelAllRequests];
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












#pragma mark - 代理：AMapSearchApi

/**
 * @brief 当请求发生错误时，会调用代理的此方法.
 * @param request 发生错误的请求.
 * @param error   返回的错误.
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    
    
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0){
        return;
    }
    self.datasource = nil;
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        AMapGeoPoint *point = obj.location;
        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        anno.title      = obj.name;
        anno.subtitle   = obj.address;
         [poiAnnotations addObject:anno];
        
        //
        ChatLocationModel *model = [[ChatLocationModel alloc] init];
        model.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
        model.title = obj.name;
        model.subtitle = obj.address;
        model.isSelected = NO;
        if (idx == 0) {
            model.isSelected = YES;
        }
        [self.datasource addObject:model];
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapview addAnnotations:poiAnnotations];
    if (poiAnnotations.count == 1){
        /* 如果只有一个结果，设置其为中心点. */
        [self.mapview setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }else{
        /* 如果有多个结果, 设置地图使所有的annotation都可见. */
        [self.mapview showAnnotations:poiAnnotations animated:NO];
    }
    [self.collectionview reloadData];
}










#pragma mark - 代理：MapLocatonManager

/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager
           didFailWithError:(NSError *)error {
    
}
/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager
          didUpdateLocation:(CLLocation *)location
                  reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
    //赋值
    self.myLocation = location;
    self.myReGeocode = reGeocode;
    
    //设置缩放级别
    [self.mapview setZoomEnabled:YES];
    [self.mapview setZoomLevel:15 animated:YES];
    
    //周边搜索
    [self action_aroundRequest];
}
















#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.datasource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatLocationCell2 *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatLocationCell2" forIndexPath:indexPath];
    
    ChatLocationModel *anno =self.datasource[indexPath.item];
    cell.model = anno;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (ChatLocationModel *model in self.datasource) {
        model.isSelected = NO;
    }
    
    ChatLocationModel *model = self.datasource[indexPath.item];
    model.isSelected = YES;
    [collectionView reloadData];
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView  *reuseableView = nil;
//    __weak typeof(self) weakself = self;
//    if (kind == CHTCollectionElementKindSectionHeader)
//    {
//        RosterReuseableHeader *aRosterReuseableHeader =
//        [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"roster_header" forIndexPath:indexPath];
//        reuseableView = aRosterReuseableHeader;
//    }
//    return reuseableView;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}












#pragma mark - Init

-(MAMapView *)mapview{
    if (!_mapview) {
        _mapview = [[MAMapView alloc] init];
        _mapview.frame = CGRectMake(0, 64, kScreenWidth, 250);
        _mapview.delegate = self;
        _mapview.mapType = MAMapTypeStandard;
        _mapview.showsUserLocation = YES;  /**显示自己定位**/
        _mapview.userTrackingMode = MAUserTrackingModeFollow;  /**定位模式：普通、追随、追随+方位**/
        
        //_mapview.zoomLevel = 15;  /**地图缩放水平：越高越清晰**/
//        [_mapview setZoomEnabled:NO]
        
    }
    return _mapview;
}

-(AMapSearchAPI *)searchApi{
    if (!_searchApi) {
        _searchApi = [[AMapSearchAPI alloc] init];
        _searchApi.delegate = self;
        _searchApi.timeout = 10;  /**搜索超时**/
        _searchApi.language = AMapSearchLanguageZhCN;  /**搜索结果语言**/
        
        
    }
    return _searchApi;
}
/**周边搜索**/
-(AMapPOIAroundSearchRequest *)aroundRequest {
    if (!_aroundRequest) {
        _aroundRequest = [[AMapPOIAroundSearchRequest alloc] init];
        //_aroundRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
        //_aroundRequest.types = @"商务住宅|公司企业|地名地址信息|政府机构及社会团体";
        //_aroundRequest.types = @"住宅|写字楼|政府机构|商场|银行";
        _aroundRequest.types = @"住宅|写字楼|政府机构";
        _aroundRequest.sortrule = 0;  /**距离远近排序**/
        _aroundRequest.offset = 30;  /**每页记录数,**/
        _aroundRequest.requireExtension = YES;  /**是否返回扩展信息**/
    }
    return _aroundRequest;
}


-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100.0f;  /**位置发生偏移100.0m，触发代理方法**/
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;  /**期望的精度：最佳**/
        _locationManager.reGeocodeLanguage = AMapLocationReGeocodeLanguageDefault;  /**逆地址语言类型**/
        _locationManager.locatingWithReGeocode = YES;  /**是否返回逆地址信息：默认为NO（外国没有）**/
//        _locationManager.allowsBackgroundLocationUpdates = YES;  /**iOS9之后：允许后台定位**/
//        _locationManager.pausesLocationUpdatesAutomatically = NO;  /**iOS9之前：允许后台定位参数，保持不会被系统挂起**/
    }
    return _locationManager;
}


-(void)setAChatLocationControllerBlock:(ChatLocationControllerBlock)aChatLocationControllerBlock {
    _aChatLocationControllerBlock = aChatLocationControllerBlock;
}

-(NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
-(CHTCollectionViewWaterfallLayout *)chLayout {
    if (!_chLayout) {
        _chLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _chLayout.columnCount = 1;
        _chLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _chLayout.minimumColumnSpacing = 0;
        _chLayout.minimumInteritemSpacing = 2;
        
//        _chLayout.headerHeight = 206+20 +10 +10;  /**页眉页脚高度：设置了之后必须实现，不然报错**/
        //_chLayout.footerHeight = 100; 206  154 + 20
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+250, kScreenWidth, kScreenHeight-250-64)
                           collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  [kBackgroundColor colorWithAlphaComponent:0.5];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[ChatLocationCell2 class] forCellWithReuseIdentifier:@"ChatLocationCell2"];
    }
    return _collectionview;
}

@end
