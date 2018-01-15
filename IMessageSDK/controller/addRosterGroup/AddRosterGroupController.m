//
//  AddRosterGroupController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "AddRosterGroupController.h"
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "AddRosterGroupHeader.h"
#import "AddRosterGroupCell.h"
#import "CreateGroupController.h"
#import "AddRosterController.h"
#import "AddRosterController.h"
#import "AddRGContactController.h"


@interface AddRosterGroupController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *subtitles;
@end













@implementation AddRosterGroupController

-(void)settingUI {
    
    [self.view addSubview:self.collectionview];
}
-(void)settingData {
    
    NSArray *images = @[
                        @"icon_40pt",
                        @"icon_40pt",
                        @"icon_40pt",
                        @"icon_40pt",
                        ];
    
    NSArray *titles = @[
                        @"添加好友",
                        @"创建群组",
                        @"扫一扫",
                        @"手机联系人",
                        ];
    
    NSArray *subtitles = @[
                        @"添加组织架构中的好友",
                        @"选择组织架构中的好友创建群组",
                        @"扫描二维码名片",
                        @"浏览通讯录中的好友拨打电话",
                        ];
    
    self.datasource = [titles mutableCopy];
    
    self.titles = [titles mutableCopy];
     self.subtitles = [subtitles mutableCopy];
     self.images = [images mutableCopy];
    
    
    [self.collectionview reloadData];
}








#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBackgroundColor;
    
    self.title = @"添加朋友";
    
    [self settingUI];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self settingData];
    
    [kMainVC hiddenTbaBar];
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    //[kMainVC showTbaBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc
{
   // [kMainVC showTbaBar];
}
-(void)toAddRosterController{
    AddRosterController *vc =  [[AddRosterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}











#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 60);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddRosterGroupCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"AddRosterGroupController_Cell" forIndexPath:indexPath];
    [cell setIconImage:self.images[indexPath.item]
                 title:self.titles[indexPath.item]
              subTitle:self.subtitles[indexPath.item]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.item) {
        case 0:
        {
            AddRosterController *vc = [[AddRosterController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            CreateGroupController *vc = [[CreateGroupController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            
        }
            break;
            
        case 3:
        {
            AddRGContactController *vc = [[AddRGContactController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView  *reuseableView = nil;
//    __weak typeof(self) weakself = self;
    if (kind == CHTCollectionElementKindSectionHeader)
    {
        AddRosterGroupHeader *aAddRosterGroupHeader =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:@"AddRosterGroupHeader"
                                                  forIndexPath:indexPath];
        reuseableView = aAddRosterGroupHeader;
        
        [aAddRosterGroupHeader setAAddRosterGroupHeaderBlock:^{
            
            [self setEditing:NO animated:YES];
            [self toAddRosterController];
        }];
    }
    return reuseableView;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}













#pragma mark - Init
-(NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

-(NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(NSMutableArray *)subtitles {
    if (!_subtitles) {
        _subtitles = [NSMutableArray array];
    }
    return _subtitles;
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
        
        _chLayout.headerHeight = 150;  /**页眉页脚高度：设置了之后必须实现，不然报错**/
        //_chLayout.footerHeight = 100; 206  154 + 20
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  kBackgroundColor;
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
//        __weak typeof(self) weakself = self;
//        _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakself settingData];
//        }];
//
        [_collectionview registerClass:[AddRosterGroupCell class]
            forCellWithReuseIdentifier:@"AddRosterGroupController_Cell"];
//
        [_collectionview registerClass:[AddRosterGroupHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:@"AddRosterGroupHeader"];
    }
    return _collectionview;
}


@end
