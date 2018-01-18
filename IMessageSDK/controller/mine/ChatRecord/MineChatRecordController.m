//
//  MineChatRecordController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/17.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "MineChatRecordController.h"
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MineChatRecordCell.h"
#import "MineFuntionIntroController.h"
#import "MineHelpController.h"
#import "GuideController.h"
#import "PreferenceManager.h"
#import "AppUtility.h"
#import "SVProgressHUD.h"
#import "Message.h"
#import "LTUser.h"


@interface MineChatRecordController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end







@implementation MineChatRecordController


#pragma mark - UI

-(void)settingUI {
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"聊天记录";
    
    UIView *topPanel = [[UIView alloc] init];
    topPanel.frame = CGRectMake(0, 20+64, kScreenWidth, 50);
    [self.view addSubview:topPanel];
    topPanel.backgroundColor = [UIColor whiteColor];
    
    
    
    //lab
    UILabel *romingLAB = [[UILabel alloc] init];
    [topPanel addSubview:romingLAB];
    romingLAB.frame = CGRectMake(10,(50-20)/2, kScreenWidth-70, 20);
    romingLAB.text = @"同步最近的聊天记录至本机";
    
    
    //漫游
    UISwitch *romingSwitch = [[UISwitch alloc] init];
    [topPanel addSubview:romingSwitch];
    romingSwitch.frame = CGRectMake(kScreenWidth-60, (50-30)/2, 50, 30);
    BOOL ret = [PreferenceManager.share queryPreference_roming];
    romingSwitch.on = ret;
    
    
    
    
    
    UILabel *nameLAB = [[UILabel alloc] init];
    [self.view addSubview:nameLAB];
    nameLAB.frame = CGRectMake(0, 80+64, kScreenWidth, 20);
    nameLAB.textAlignment = NSTextAlignmentCenter;
    nameLAB.textColor = [UIColor grayColor];
    nameLAB.font = [UIFont systemFontOfSize:12.0f];
    nameLAB.text = @"开启漫游后，您在其它设备的聊天记录都可以在本机查看";
    
    
    [self.view addSubview:self.collectionview];
}
-(void)settingData {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *titles = @[
                            @"清空所有聊天记录",
                            ];
        
        self.datasource = [titles mutableCopy];
        CGFloat cacheSize = [AppUtility cacheSize];
        //CGFloat documentSize = [AppUtility documentSize];
        NSString *cacheSizeStr = [NSString stringWithFormat:@"清空缓存数据（%0.2fKB)",cacheSize];
        if (cacheSize > 1024/2) {
            cacheSizeStr = [NSString stringWithFormat:@"清空缓存数据（%0.2fM)",cacheSize/1024];
        }
        [self.datasource addObject:cacheSizeStr];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionview reloadData];
        });
    });

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
-(void)dealloc{
    [SVProgressHUD dismiss];
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
    MineChatRecordCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"MineChatRecordCell" forIndexPath:indexPath];
    [cell setTitle:self.datasource[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    switch (indexPath.item) {
        case 0:
        {
            //清除此登录用户所有信息
            [SVProgressHUD showWithStatus:@"正在聊天记录..."];
            NSDictionary *userDict = [LTUser.share queryUser];
            NSString *JID = userDict[@"JID"];
            [Message jh_deleteByMyJID:JID];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"聊天记录清除完成"];
            });
            
        }
            break;
            
        case 1:
        {
            __weak typeof(self) weakself = self;
            [SVProgressHUD showWithStatus:@"正在清除缓存..."];
            [AppUtility clearCacheAction:^(BOOL clearFinished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"缓存清除完成"];
                    [weakself settingData];
                });
            }];
        }
            break;
            
        default:
            break;
    }
    
    
}
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
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 150+64, kScreenWidth, kScreenHeight-64-150)
                           collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  [kBackgroundColor colorWithAlphaComponent:0.5];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        
        [_collectionview registerClass:[MineChatRecordCell class]
            forCellWithReuseIdentifier:@"MineChatRecordCell"];
        
        //        [_collectionview registerClass:[RosterReuseableHeader class]
        //            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
        //                   withReuseIdentifier:@"roster_header"];
    }
    return _collectionview;
}
@end
