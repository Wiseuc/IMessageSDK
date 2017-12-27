//
//  CreateGroupController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "CreateGroupController.h"
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CreateGroupCell.h"
#import "UITextView+ZWPlaceHolder.h"
#import "SelectGroupMemberController.h"
#import "SVProgressHUD.h"
#import "OrgModel.h"
#import "LTSDKFull.h"




@interface CreateGroupController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *allDatasource;


@property (nonatomic, strong) UITextView *nameTV;          /**名称**/
@property (nonatomic, strong) UITextView *titleTV;         /**主题**/
@property (nonatomic, strong) UITextView *introTV;         /**简介**/
@property (nonatomic, strong) UITextView *announcementTV;  /**公告**/
@end









@implementation CreateGroupController

-(void)settingUI {
    
    UIBarButtonItem *rightItem =
    [[UIBarButtonItem alloc] initWithTitle:@"创建"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(createGroup)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    self.nameTV = [[UITextView alloc] init];
    self.nameTV.frame = CGRectMake(0, 10 + 64, kScreenWidth, 50);
    self.nameTV.layer.borderWidth = 1;
    self.nameTV.font = [UIFont systemFontOfSize:14];
    self.nameTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //文字设置居右、placeHolder会跟随设置
    //    textView.textAlignment = NSTextAlignmentRight;
    self.nameTV.zw_placeHolder = @"名称";
    self.nameTV.zw_limitCount = 30;
    self.nameTV.zw_placeHolderColor = [UIColor lightGrayColor];
    [self.view addSubview:self.nameTV];
    
    
    
    self.titleTV = [[UITextView alloc] init];
    self.titleTV.frame = CGRectMake(0, 70 + 64, kScreenWidth, 50);
    self.titleTV.layer.borderWidth = 1;
    self.titleTV.font = [UIFont systemFontOfSize:14];
    self.titleTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //文字设置居右、placeHolder会跟随设置
    //    textView.textAlignment = NSTextAlignmentRight;
    self.titleTV.zw_placeHolder = @"主题";
    self.titleTV.zw_limitCount = 30;
    self.titleTV.zw_placeHolderColor = [UIColor lightGrayColor];
    [self.view addSubview:self.titleTV];
    
    
    
    self.introTV = [[UITextView alloc] init];
    self.introTV.frame = CGRectMake(0, 130 + 64, kScreenWidth, 80);
    self.introTV.layer.borderWidth = 1;
    self.introTV.font = [UIFont systemFontOfSize:14];
    self.introTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //文字设置居右、placeHolder会跟随设置
    //    textView.textAlignment = NSTextAlignmentRight;
    self.introTV.zw_placeHolder = @"简介";
    self.introTV.zw_limitCount = 100;
    self.introTV.zw_placeHolderColor = [UIColor lightGrayColor];
    [self.view addSubview:self.introTV];
    
    
    
    self.announcementTV = [[UITextView alloc] init];
    self.announcementTV.frame = CGRectMake(0, 220 + 64, kScreenWidth, 80);
    self.announcementTV.layer.borderWidth = 1;
    self.announcementTV.font = [UIFont systemFontOfSize:14];
    self.announcementTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //文字设置居右、placeHolder会跟随设置
    //    textView.textAlignment = NSTextAlignmentRight;
    self.announcementTV.zw_placeHolder = @"公告";
    self.announcementTV.zw_limitCount = 100;
    self.announcementTV.zw_placeHolderColor = [UIColor lightGrayColor];
    [self.view addSubview:self.announcementTV];
    
    
    
    [self.view addSubview:self.collectionview];
    self.collectionview.frame = CGRectMake(0, 310 + 64, kScreenWidth, kScreenHeight - 310 - 64);
}
//-(void)settingData {
//
//    NSArray *images = @[
//                        @"AddGroupMemberBtnHL_58x58_",
//                        ];
//    [self.allDatasource addObjectsFromArray:images];
//
//    [self.collectionview reloadData];
//}
-(void)settingGesture {
    UITapGestureRecognizer *tapG =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing)];
    tapG.numberOfTapsRequired = 1;
    tapG.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapG];
}
-(void)refreshData {
    
    [self.allDatasource removeAllObjects];
    
    
    if (self.datasource.count > 0) {
        [self.allDatasource addObjectsFromArray:self.datasource];
    }
    
    OrgModel *model = [[OrgModel alloc] init];
    model.isAdd = YES;
    model.NAME = @"";
    [self.allDatasource addObject:model];
    
    [self.collectionview reloadData];
}











- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    self.title = @"创建群组";
    
    [self settingUI];
    
    [self refreshData];
    
    //[self settingGesture];
    
    
    self.view.userInteractionEnabled = YES;
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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
-(void)viewEndEditing {
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self viewEndEditing];
}






#pragma mark - Private

-(void)createGroup {
    
    [self.view endEditing:YES];
    if (self.nameTV.text.length == 0  ||
        self.titleTV.text.length == 0 ||
        self.introTV.text.length == 0 ||
        self.announcementTV.text.length == 0
        )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"群组名称和群组主题不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *UserName = userDict[@"UserName"];
    NSString *Domain   = userDict[@"Domain"];
    NSString *resource = UserName;
    NSString *roomID   = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *domain   = Domain;
    NSString *roomJID  = [NSString stringWithFormat:@"%@@%@",roomID.lowercaseString,domain];
    NSString *presence = [NSString stringWithFormat:@"%@/%@",roomID,resource];
    
//    [GroupManager.defaultManager createGroupWithRoomID:roomID
//                                               roomJID:roomJID
//                                              presence:presence
//                                                domain:domain
//                                              resource:resource
//                                         isCreateGroup:self.isCreateGroup
//                                            datasource:self.dataSource
//                                      groupDetailModel:gModel];
    
}






















#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allDatasource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-30)/5, (kScreenWidth-30)/5);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CreateGroupCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateGroupCell" forIndexPath:indexPath];
    
    cell.model = self.allDatasource[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.allDatasource.count - 1) {
        SelectGroupMemberController *vc = [[SelectGroupMemberController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        __weak typeof(self) weakself = self;
        [vc selectGroupMember:^(NSArray *arr) {
           //返回群租成员数组。。。
            weakself.datasource = [arr mutableCopy];
            [weakself refreshData];
        }];
    }
}




//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView  *reuseableView = nil;
//    //    __weak typeof(self) weakself = self;
//    if (kind == CHTCollectionElementKindSectionHeader)
//    {
//        AddRosterGroupHeader *aAddRosterGroupHeader =
//        [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AddRosterGroupHeader" forIndexPath:indexPath];
//        reuseableView = aAddRosterGroupHeader;
//    }
//    return reuseableView;
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
-(NSMutableArray *)allDatasource {
    if (!_allDatasource) {
        _allDatasource = [NSMutableArray array];
    }
    return _allDatasource;
}


-(CHTCollectionViewWaterfallLayout *)chLayout {
    if (!_chLayout) {
        _chLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _chLayout.columnCount = 5;
        _chLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _chLayout.minimumColumnSpacing = 5;
        _chLayout.minimumInteritemSpacing = 5;
        
        //_chLayout.headerHeight = 150;  /**页眉页脚高度：设置了之后必须实现，不然报错**/
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
        [_collectionview registerClass:[CreateGroupCell class]
            forCellWithReuseIdentifier:@"CreateGroupCell"];
        //
//        [_collectionview registerClass:[AddRosterGroupHeader class]
//            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
//                   withReuseIdentifier:@"AddRosterGroupHeader"];
    }
    return _collectionview;
}



@end
