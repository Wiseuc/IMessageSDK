//
//  AddGroupController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/16.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AddGroupController.h"
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "DocManager.h"
#import "AddGroupCell.h"
#import "LTSDKFull.h"
#import "SVProgressHUD.h"
#import "GroupModel.h"








@interface AddGroupController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate,
UISearchBarDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *resultArrM;

/**搜索bar**/
@property (nonatomic, strong) UISearchBar *searchBar;
@end










@implementation AddGroupController


#pragma mark - UI

-(void)settingUI{
    
    [self.view addSubview:self.searchBar];
    
    [self.view addSubview:self.collectionview];
    
}


-(void)settingData {
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /**
         {
         FN = "\U5927\U7897\U83dc-\U805a\U9910-20170519";
         category = conference;
         conferencetype = 1;
         introduction = "";
         jid = "d3e01480a5e24ae182d883ec29329216@conference.duowin-server";
         name = "\U5927\U7897\U83dc-\U805a\U9910-20170519";
         owner = "\U5218\U816e\U5b9d@duowin-server";
         password = 0;
         subject = "\U805a\U9910";
         type = public;
         },
         **/
        
        [LTGroup.share queryGroupsCompleted:^(NSMutableArray *groups, LTError *error) {
            [weakself.datasource removeAllObjects];
            NSDictionary *dict01 = groups[0];
            for (NSDictionary *dict02 in dict01[@"item"])
            {
                GroupModel *model = [[GroupModel alloc] init];
                model.FN = dict02[@"FN"];
                model.category = dict02[@"category"];
                model.conferencetype = dict02[@"conferencetype"];
                model.introduction = dict02[@"introduction"];
                model.jid = dict02[@"jid"];
                
                model.name = dict02[@"name"];
                model.owner = dict02[@"owner"];
                model.password = dict02[@"password"];
                model.subject = dict02[@"subject"];
                model.type = dict02[@"type"];
                [self.datasource addObject:model];
            }
        }];
    });
}












#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索群组";
    
    self.view.backgroundColor = kBackgroundColor;
    
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
    
    //[kMainVC showTbaBar];
}











#pragma mark - Private

/**添加群组**/
-(void)action_addGroup:(GroupModel *)model {
    UIAlertController *alertvc =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"确定添加群组吗"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self addFriend:model];
                                                }];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertvc addAction:ac1];
    [alertvc addAction:ac2];
    [self presentViewController:alertvc animated:YES completion:nil];
}
-(void)addFriend:(GroupModel *)model {
    [LTFriend.share sendRequestAddFriendWithFriendJid:model.jid
                                           friendName:model.name
                                            completed:nil];
    [SVProgressHUD showInfoWithStatus:@"添加好友请求已经发送给对方，等待对方确认"];
}







#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resultArrM.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddGroupCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"AddGroupCell" forIndexPath:indexPath];
    //    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.model = self.resultArrM[indexPath.item];
    [cell setAAddGroupCellBlock:^(GroupModel *model) {
        //[self action_addGroup:model];
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
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











#pragma mark - 代理：scrollView

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}











#pragma mark - 代理：UISearchBar

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始输入搜索内容");
    searchBar.showsCancelButton = YES;//取消的字体颜色，
    [searchBar setShowsCancelButton:YES animated:YES];
    
    //改变取消的文本
    for(UIView *view in [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateSelected];
            [cancel setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        }
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"输入搜索内容完毕");
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
}
//取消的响应事件
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"取消搜索");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
//键盘上搜索事件的响应
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    
    //NSLog(@"输入的关键字是---%@---%lu",searchText,(unsigned long)searchText.length);
    [self.resultArrM removeAllObjects];
    
    //多线程，否则数量量大的时候，有明显的卡顿现象
    //这里最好放在数据库里面再进行搜索，效率会更快一些
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        if (searchBar.text!=nil && searchBar.text.length>0) {
            
            for (GroupModel *model in self.datasource)
            {
                NSString *name_pinyin = [self transformToPinyin:model.name];
                
                if ([name_pinyin rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].length >0 ) {
                    NSLog(@"pinyin--%@",name_pinyin);
                    [self.resultArrM addObject:model];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionview reloadData];
        });
    });
}
- (NSString *)transformToPinyin:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}











#pragma mark - Init

-(NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
//        _datasource = [DocManager.share queryAllSUBGROUP];
    }
    return _datasource;
}

-(NSMutableArray *)resultArrM {
    if (!_resultArrM) {
        _resultArrM = [NSMutableArray array];
    }
    return _resultArrM;
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
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50+64, kScreenWidth, kScreenHeight-50-64)
                           collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  [kBackgroundColor colorWithAlphaComponent:0.5];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[AddGroupCell class]
            forCellWithReuseIdentifier:@"AddGroupCell"];
    }
    return _collectionview;
}

-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
        _searchBar.keyboardType = UIKeyboardAppearanceDefault;
        _searchBar.placeholder = @"请输入搜索关键字";
        _searchBar.delegate = self;
        //底部的颜色
        _searchBar.barTintColor = kBackgroundColor;//[UIColor lightGrayColor];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.barStyle = UISearchBarStyleDefault;  /**去掉边框线**/
    }
    return _searchBar;
}





@end
