//
//  MinePreferenecController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "MinePreferenecController.h"

#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MinePreferenceCell.h"

#import "PreferenceManager.h"




@interface MinePreferenecController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end










@implementation MinePreferenecController
#pragma mark - UI

-(void)settingUI {
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"偏好设置";
    
    //
    UIImageView *iconIMGV = [[UIImageView alloc] init];
    [self.view addSubview:iconIMGV];
    iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
    iconIMGV.frame = CGRectMake((kScreenWidth-80)/2, (240+64+64-80)/2, 80, 80);
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    
    
    
    UILabel *nameLAB = [[UILabel alloc] init];
    [self.view addSubview:nameLAB];
    nameLAB.text = [NSString stringWithFormat:@"%@%@",appCurName,appCurVersion ];
    nameLAB.frame = CGRectMake(0, (240+64+64-80)/2+80+5, kScreenWidth, 20);
    nameLAB.textAlignment = NSTextAlignmentCenter;
    nameLAB.textColor = [UIColor grayColor];
    nameLAB.font = [UIFont systemFontOfSize:12.0f];
    
    
    [self.view addSubview:self.collectionview];
}
-(void)settingData {
    
    NSArray *titles = @[
                        @"声音提示",
                        @"震动提示",
//                        @"按在线状态排序",
                        ];
    
    self.datasource = [titles mutableCopy];
    
    [self.collectionview reloadData];
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
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //    [kMainVC hiddenTbaBar];
}

















#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MinePreferenceCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"MinePreferenceCell" forIndexPath:indexPath];
    [cell setTitle:self.datasource[indexPath.item] indexpath:indexPath];
    return cell;
}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    
//}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView  *reuseableView = nil;
//    __weak typeof(self) weakself = self;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}


















#pragma mark - Init

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
        
        //        _chLayout.headerHeight = 240;  /**页眉页脚高度：设置了之后必须实现，不然报错**/
        //_chLayout.footerHeight = 100; 206  154 + 20
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 240+64, kScreenWidth, kScreenHeight-64-240)
                           collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  [kBackgroundColor colorWithAlphaComponent:0.5];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        
        [_collectionview registerClass:[MinePreferenceCell class]
            forCellWithReuseIdentifier:@"MinePreferenceCell"];
        
        //        [_collectionview registerClass:[RosterReuseableHeader class]
        //            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
        //                   withReuseIdentifier:@"roster_header"];
    }
    return _collectionview;
}
@end
