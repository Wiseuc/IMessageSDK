//
//  RosterController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "RosterController.h"
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "LTSDKFull.h"
#import "RosterModel.h"
#import "MJRefresh.h"
#import "RosterReuseableHeader.h"
#import "OrgController.h"
#import "GroupController.h"
#import "CompanyController.h"
#import "RosterCell.h"
#import "ChatController.h"
#import "NewRosterGroupController.h"
#import "NewRosterMessage.h"
#import "AddRosterGroupController.h"


@interface RosterController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end









@implementation RosterController



#pragma mark - UI

-(void)settingUI {
    
    [self settingUIBarButtonItem];
    
    [self.view addSubview:self.collectionview];
}

-(void)settingUIBarButtonItem {
    UIImage *img = [[UIImage imageNamed:@"barbuttonicon_addfriends_30x30_"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:img
                                                                  style:(UIBarButtonItemStylePlain)
                                                                 target:self
                                                                 action:@selector(gotoAddRosterGroupVC)];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

-(void)settingData {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [LTFriend.share queryRostersCompleted:^(NSMutableArray *rosters, LTError *error) {
            
            [weakself.datasource removeAllObjects];
            
            for (NSDictionary *dict01 in rosters)
            {
                RosterModel *model = [[RosterModel alloc] init];
                model.FN = dict01[@"FN"];
                model.group = dict01[@"group"];
                model.jid = dict01[@"jid"];
                model.name = dict01[@"name"];
                model.pinYin = dict01[@"pinYin"];
                model.subscription = dict01[@"subscription"];
                model.vcardver = dict01[@"vcardver"];
                [self.datasource addObject:model];
            }
            [weakself refreshData];
        }];
    });
}
-(void)refreshData {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [weakself.collectionview.mj_header endRefreshing];
        [weakself.collectionview reloadData];
    });
}
/**
 注册监听NewRosterMessage数据库监听
 */
-(void)settingDBOberser{
    __weak typeof(self) weakself = self;
    [NewRosterMessage settingDBOberser:^{
        [weakself refreshNewRosterMessage];
    }];
}
-(void)unsettingDBOberser{
    [NewRosterMessage unsettingDBOberser];
}

/**有新的好友请求消息**/
-(void)refreshNewRosterMessage {
    /**给新的朋友和新的群组 添加一个红点**/
    
}










#pragma mark - runLoop

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self settingUI];
    
    [self settingData];
    
    [self settingDBOberser];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self settingDBOberser];
    
    [self settingData];
    
    [kMainVC showTbaBar];
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self unsettingDBOberser];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)gotoAddRosterGroupVC {
    AddRosterGroupController *vc = [[AddRosterGroupController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    RosterCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"roster_cell" forIndexPath:indexPath];
    RosterModel *model = self.datasource[indexPath.item];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    RosterModel *model = self.datasource[indexPath.item];
    NSString *ohterJID = model.jid;
    ChatController *chatvc = [[ChatController alloc] initWithCurrentOtherJID:ohterJID conversationName:model.name];
    [self.navigationController pushViewController:chatvc animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView  *reuseableView = nil;
    __weak typeof(self) weakself = self;
    if (kind == CHTCollectionElementKindSectionHeader)
    {
        RosterReuseableHeader *aRosterReuseableHeader =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"roster_header" forIndexPath:indexPath];
        [aRosterReuseableHeader setARosterReuseableHeaderSelectBlock:^(NSInteger tag) {
            
            /**跳转**/
            switch (tag) {
                case 1000:
                {
                    NewRosterGroupController *newvc = [[NewRosterGroupController alloc] init];
                    [weakself.navigationController pushViewController:newvc animated:YES];
                }
                    break;
                    
                case 1001:
                {
                    GroupController *groupvc = [[GroupController alloc] init];
                    [weakself.navigationController pushViewController:groupvc animated:YES];
                }
                    break;
                    
                case 1002:
                {
                    OrgController *orgvc = [[OrgController alloc] init];
                    [weakself.navigationController pushViewController:orgvc animated:YES];
                }
                    break;
                    
                case 1003:
                {
                    CompanyController *companyvc = [[CompanyController alloc] init];
                    [weakself.navigationController pushViewController:companyvc animated:YES];
                }
                    break;
            }
        }];
        reuseableView = aRosterReuseableHeader;
        
    }
    return reuseableView;
}

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
        
        _chLayout.headerHeight = 206+20 +10 +10;  /**页眉页脚高度：设置了之后必须实现，不然报错**/
        //_chLayout.footerHeight = 100; 206  154 + 20
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  [kBackgroundColor colorWithAlphaComponent:0.5];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        __weak typeof(self) weakself = self;
        _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself settingData];
        }];
        
        [_collectionview registerClass:[RosterCell class]
            forCellWithReuseIdentifier:@"roster_cell"];
        
        [_collectionview registerClass:[RosterReuseableHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:@"roster_header"];
    }
    return _collectionview;
}


@end
