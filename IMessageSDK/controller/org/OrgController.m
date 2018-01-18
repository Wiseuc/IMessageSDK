//
//  OrgController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "OrgController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "UIConfig.h"
#import "OrgModel.h"
#import "DocManager.h"
#import "OrgCell.h"
#import "StackView.h"
#import "LTStack.h"
#import "ChatController.h"
#import "LTSDKFull.h"
#import "SVProgressHUD.h"



@interface OrgController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) StackView *stackView;
@property (nonatomic, strong) LTStack *ltStack;   /**堆栈管理器**/
@end






@implementation OrgController

#pragma mark - UI
-(void)settingUI {
    self.title = @"组织架构";
    [self.view addSubview:self.stackView];
    
    __weak typeof(self) weakself = self;
    [self.stackView setBackAction:^{
        [weakself returnBeforeOrgData];
    }];
    
    //重新下载组织架构
    [self.stackView setAStackViewRefreshBlock:^{
        
        [SVProgressHUD showWithStatus:@"刷新组织架构..."];
        
        [LTOrg.share downloadOrg:^(GDataXMLDocument *doc, LTError *error) {
            
            if (error)
            {
                [SVProgressHUD showErrorWithStatus:@"刷新组织架构失败"];
            }
            else
            {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"刷新完毕"];

                    //                [SVProgressHUD dismiss];
                    [weakself settingData];
                });
            }/**end if(error)**/
        }];
    }];
    
    [self.view addSubview:self.collectionview];
}

-(void)refreshCollectionView {
    
    [self.collectionview reloadData];
}









#pragma mark - data

-(void)settingData {
    [self parseOrgWith:nil];
}

/**解析组织架构**/
- (void)parseOrgWith:(OrgModel *)model {
    NSArray *datas = nil;
    if ( model == nil || [model.ID isEqualToString:@"0"] )
    {
        NSDictionary *dict = [DocManager.share queryDocumentDescribe];
        model = [[OrgModel alloc] init];
        model.ITEMTYPE = dict[@"ITEMTYPE"];
        model.NAME = dict[@"NAME"];
        model.ID = dict[@"ID"];
        [self.ltStack clear];
        [self.ltStack push:model];
        datas = [DocManager.share queryNextOrgData:nil];
    }else{
        datas = [DocManager.share queryNextOrgData:model];
    }
    
    
    self.datasource = [datas mutableCopy];
    [self refreshCollectionView];
    
    /**堆栈view**/
    NSString *content = [self.ltStack queryStackDescription];
    [self.stackView showContent:content];
}

- (void)returnBeforeOrgData {
    
    if ([self.ltStack queryStackCount] > 1) {
        
        [self.ltStack pop];
        /**获取最顶层栈**/
        OrgModel *beforerModel = [self.ltStack queryTopItem];
        [self parseOrgWith:beforerModel];
    }
}








#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingUI];
    
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

















#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrgCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    OrgModel *model =self.datasource[indexPath.item];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    OrgModel *model = self.datasource[indexPath.item];

    if ([model.ITEMTYPE isEqualToString:@"1"])
    {
        [self.ltStack push:model];
        [self parseOrgWith:model];
    }
    else if ([model.ITEMTYPE isEqualToString:@"2"])
    {
        NSString *otherJID = model.JID;
        ChatController *chatvc = [[ChatController alloc] initWithCurrentOtherJID:otherJID conversationName:model.NAME];
        [self.navigationController pushViewController:chatvc animated:YES];
    }
}









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
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc]
         initWithFrame:CGRectMake(0, 64+50, kScreenWidth, kScreenHeight-64-50)
         collectionViewLayout:self.chLayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[OrgCell class]
            forCellWithReuseIdentifier:@"cell"];
        _collectionview.backgroundColor = kBackgroundColor;
    }
    return _collectionview;
}

-(UIView *)stackView {
    if (!_stackView) {
        _stackView = [[StackView alloc] init];
        _stackView.backgroundColor = [UIColor whiteColor];
        _stackView.frame = CGRectMake(0, 64, kScreenWidth, 50);
        _stackView.layer.borderWidth = 1;
        _stackView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _stackView;
}

-(LTStack *)ltStack {
    if (!_ltStack) {
        _ltStack = [[LTStack alloc] init];
    }
    return _ltStack;
}
@end
