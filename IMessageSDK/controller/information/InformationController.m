//
//  InformationController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "InformationController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "UIConfig.h"
#import "LTSDKFull.h"
#import "InformationCell.h"

@interface InformationController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) NSMutableDictionary *dict;
@end







@implementation InformationController


#pragma mark - UI

-(void)settingUI {
    [self.view addSubview:self.collectionview];
    [self.collectionview reloadData];
}

-(void)settingData {
    __weak typeof(self) weakself = self;
    [LTUser.share queryInformationByJID:self.jid
                              completed:^(NSDictionary *dict) {
                                  [weakself dealDict:dict];
                              }];
}

-(void)dealDict:(NSDictionary *)dict {
    
    
    self.dict = [dict mutableCopy];
    [self.dict removeObjectForKey:@"ORG"];
    [self.collectionview reloadData];
    
//    InformationModel *infoModel = [[InformationModel alloc] init];
//
//    infoModel.BDAY = dict[@"BDAY"];
//    infoModel.CELL = dict[@"CELL"];
//    infoModel.EMAIL = dict[@"EMAIL"];
//    infoModel.FN = dict[@"FN"];
//    infoModel.GENDER = dict[@"GENDER"];
//
//    infoModel.LOCALITY = dict[@"LOCALITY"];
//    infoModel.LOGINNAME = dict[@"LOGINNAME"];
//    infoModel.MOBILEEXT = dict[@"MOBILEEXT"];
//    infoModel.NICKNAME = dict[@"NICKNAME"];
//    infoModel.PCODE = dict[@"PCODE"];
//
//    infoModel.REGION = dict[@"REGION"];
//    infoModel.STREET = dict[@"STREET"];
//    infoModel.TITLE = dict[@"TITLE"];
//    infoModel.TITLEDESC = dict[@"TITLEDESC"];
//    infoModel.URL = dict[@"URL"];
//
//    infoModel.WORK = dict[@"WORK"];
//    infoModel.WORKURL = dict[@"WORKURL"];
//    infoModel.jid = dict[@"jid"];
//    infoModel.name = dict[@"name"];
//    infoModel.pinYin = dict[@"pinYin"];
//
//    infoModel.vcardver = dict[@"vcardver"];
//    [self.datasource addObject:infoModel];
//    [self.collectionview reloadData];
    
    
    
}





#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    
    self.title = @"个人资料";
    
    [self settingUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self settingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.dict.allKeys.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InformationCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"InformationCell" forIndexPath:indexPath];
    
    if (self.dict.allKeys.count>0) {
        
        NSString *key = self.dict.allKeys[indexPath.item];
        NSString *value = self.dict[key];
        [cell setDataWithName:key value:value];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
}












#pragma mark - init
-(NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
-(NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}
-(CHTCollectionViewWaterfallLayout *)chLayout {
    if (!_chLayout) {
        _chLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _chLayout.columnCount = 1;
        _chLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _chLayout.minimumColumnSpacing = 0;
        _chLayout.minimumInteritemSpacing = 2;
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc]
         initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49)
         collectionViewLayout:self.chLayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[InformationCell class]
            forCellWithReuseIdentifier:@"InformationCell"];
        _collectionview.backgroundColor = kBackgroundColor;
    }
    return _collectionview;
}




@end
