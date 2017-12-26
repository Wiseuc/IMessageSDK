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
#import "RosterModel.h"

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

/**必须设置jid**/
@property (nonatomic, strong) NSString *jid;
@end







@implementation InformationController


#pragma mark - UI

-(void)settingUI {
    [self.view addSubview:self.collectionview];
    [self.collectionview reloadData];
    
    
    
//    self.collectionview.sec
}

-(void)settingData {
    __weak typeof(self) weakself = self;
    if ([self.jid containsString:@"conference"])
    {
        [LTGroup.share queryGroupVCardByGroupJID:self.jid completed:^(NSDictionary *dict) {
            [weakself dealDict:dict];
        }];
    }else{
        [LTFriend.share queryRosterVCardByJID:self.jid completed:^(NSDictionary *dict) {
            [weakself dealDict:dict];
        }];
    }
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
- (void)dealloc
{
    NSLog(@"个人信息页面dealloc");
}








#pragma mark - Private
/**添加好友**/
-(void)addFriend {
    UIAlertController *alertvc =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"确定添加好友吗"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"确定"
                                                 style:UIAlertActionStyleDestructive
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   [self add];
                                               }];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertvc addAction:ac1];
    [alertvc addAction:ac2];
    [self presentViewController:alertvc animated:YES completion:nil];
}
/**删除好友**/
-(void)deleteFriend {
    UIAlertController *alertvc =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"确定删除好友吗"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self delete];
                                                }];
    UIAlertAction *ac2 =
    [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertvc addAction:ac1];
    [alertvc addAction:ac2];
    [self presentViewController:alertvc animated:YES completion:nil];
}

-(void)add {
    NSDictionary *dict = [LTOrg queryInformationByJid:self.jid];
    NSString *aJID = dict[@"JID"];
    NSString *aName = dict[@"NAME"];
    
    [LTFriend.share sendRequestAddFriendWithFriendJid:aJID
                                           friendName:aName
                                            completed:nil];
    [self back];
}
-(void)delete {
    [LTFriend.share deleteFriendJid:self.jid];
    [self back];
}
-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
//每段的段头视图，或者段尾视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footer =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        __weak typeof(self) weakself = self;
        [LTFriend.share queryRostersCompleted:^(NSMutableArray *rosters, LTError *error) {
            
            //是否为好友
            BOOL isfriend = NO;
            for (NSDictionary *dict01 in rosters)
            {
                if ([dict01[@"jid"] isEqualToString:self.jid]) {
                    isfriend = YES;
                }
            }
            
            //是否为自己
            NSDictionary *userDict = [LTUser.share queryUser];
            NSString *myJID = userDict[@"JID"];
            if ([weakself.jid isEqualToString:myJID])
            {
                
            }
            else
            {
                //是否为会议
                if ([weakself.jid containsString:@"conference"])
                {
                    
                }else{
                    [weakself addFooterWithFooter:footer ByIsFriend:isfriend];
                }
            }
        }];
        return footer;
    }
    return nil;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
heightForFooterInSection:(NSInteger)section {
    return 100.0f;
}
-(void)addFooterWithFooter:(UICollectionReusableView *)footer ByIsFriend:(BOOL)isfriend {
    
    UIButton *addFriendBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [footer addSubview:addFriendBTN];
    addFriendBTN.frame = CGRectMake(10, 10, kScreenWidth-20, 40);
    [addFriendBTN setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    if (isfriend)
    {
        [addFriendBTN setTitle:@"删除好友" forState:(UIControlStateNormal)];
        [addFriendBTN setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5f]];
        [addFriendBTN addTarget:self action:@selector(deleteFriend) forControlEvents:(UIControlEventTouchUpInside)];
    }else{
        [addFriendBTN setTitle:@"添加好友" forState:(UIControlStateNormal)];
        [addFriendBTN setBackgroundColor:kDarkGreenColor];
        [addFriendBTN addTarget:self action:@selector(addFriend) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
}









#pragma mark - init

- (instancetype)initWithJID:(NSString *)aJID
{
    self = [super init];
    if (self) {
        self.jid = aJID;
    }
    return self;
}
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
        
        
        
        [self.collectionview registerClass:[UICollectionReusableView class]
                forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                       withReuseIdentifier:@"footer"];
    }
    return _collectionview;
}




@end
