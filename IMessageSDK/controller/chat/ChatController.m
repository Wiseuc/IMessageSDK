//
//  ChatController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/14.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "ChatController.h"
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MJRefresh.h"
#import "InformationController.h"
#import "LTSDKFull.h"
#import "Message.h"
#import "ChatCell.h"
#import "NSString+Extension.h"
#import "InputView.h"

@interface ChatController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSString *currentOtherJID;  /**对方jid**/
@property (nonatomic, strong) InputView *inputView;  /**输入框**/
@end








@implementation ChatController

#pragma mark - UI

-(void)settingUI {
    
    [self.view addSubview:self.collectionview];
    [self settingUIBarButtonItem];
    /**添加输入框 - 开始输入**/
    [self.view addSubview:self.inputView];
    
    __weak typeof(self) weakself = self;
    [self.inputView startInputView:^(NSString *message) {
        [weakself sendMessage:message];
    }];
    
}
-(void)settingUIBarButtonItem{
    UIBarButtonItem *rightItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wode_changtai"]
                                     style:UIBarButtonItemStylePlain
                                    target:self action:@selector(pushToInformationController)];
    rightItem.tag = 1001;
    self.navigationItem.rightBarButtonItems = @[rightItem];
}
-(void)pushToInformationController {
    InformationController *infovc = [[InformationController alloc] init];
    [self.navigationController pushViewController:infovc animated:YES];
}
/**键盘监听**/
- (void)settingKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardHide)
     name:UIKeyboardWillHideNotification
     object:nil];
}
- (void) keyboardShow:(NSNotification *)no
{
    /**
     {
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 251.5}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 693.75}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 442.25}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 568}, {320, 251.5}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 316.5}, {320, 251.5}}";
     UIKeyboardIsLocalUserInfoKey = 1;
     }
     **/
    NSDictionary *dic = no.userInfo;
    id objFrame = dic[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect kbFrame = {0};
    [objFrame getValue:&kbFrame];
    
    /**键盘**/
    CGFloat kbMinY = kbFrame.origin.y;
    CGFloat kbH    = kbFrame.size.height;
    //视图
    CGFloat btnMaxY =  CGRectGetMaxY(self.view.frame);  /**这里设置最低的视图**/
    
    if (btnMaxY+20 > kbMinY)
    {
        CGRect tempFrame = self.view.frame;
        /**标准Y**/
        CGFloat standY = kScreenHeight - (kbH);
        /**现在Y**/
        CGFloat nowY   = btnMaxY;
        /**Y差距**/
        CGFloat distance = nowY - standY;
        
        tempFrame.origin.y = tempFrame.origin.y - distance;
        
        self.view.frame = tempFrame;
    }
}
- (void)keyboardHide{
    self.view.frame = self.view.bounds;
}

-(void)settingGesture {
    UITapGestureRecognizer *tapG =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing)];
    tapG.numberOfTapsRequired = 1;
    tapG.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapG];
}
-(void)viewEndEditing {
    [self.view endEditing:YES];
}











#pragma mark - Data

-(void)settingData {
    if (self.currentOtherJID == nil) {
        return;
    }
    /**通过对方jid获取**/
    
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];
    
    NSString *ConversationName = [Message jh_queryConversationNameByJID:self.currentOtherJID];
    NSArray *arr = [Message jh_queryByConversationName:ConversationName];
    //NSArray *arr = [Message jh_queryByConversationName:ConversationName currentMyJID:myJID];
    
    
    self.datasource = [arr mutableCopy];
    [self refreshData];
    
    
    self.title = ConversationName;
}
-(void)refreshData {
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakself.collectionview.mj_header endRefreshing];
        [weakself.collectionview reloadData];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:self.datasource.count-1 inSection:0];
        [weakself.collectionview scrollToItemAtIndexPath:indexpath
                                        atScrollPosition:(UICollectionViewScrollPositionBottom)
                                                animated:NO];
    });
}
/**
 注册监听bg_tablename表的数据变化，唯一识别标识是@"change".
 */
-(void)settingDBOberser{
    __weak typeof(self) weakself = self;
    [Message settingDBOberser:^{
        [weakself settingData];
    }];
}
-(void)unsettingDBOberser{
    [Message unsettingDBOberser];
}










#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    self.view.userInteractionEnabled = YES;
    [self settingKeyBoardNotification];
    [self settingUI];
    [self settingGesture];
    
    
    [self settingData];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self settingDBOberser];
    
    [kMainVC hiddenTbaBar];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unsettingDBOberser];
    [kMainVC showTbaBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








#pragma mark - private

-(void)buttonClick:(UIButton *)sender {
    
    
}

-(void)sendMessage:(NSString *)content {
    
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID =userDict[@"JID"];
        
    NSDictionary *dict = [LTMessage.share asyncSendMessageWithMyJID:myJID
                                                           otherJID:self.currentOtherJID
                                                               body:content
                                                           chatType:@"chat"];
    [self dealData:dict];
}
-(void)dealData:(NSDictionary *)dict {
    Message *msg = [[Message alloc] init];
    msg.currentMyJID = dict[@"currentMyJID"];
    msg.currentOtherJID = dict[@"currentOtherJID"];
    msg.conversationName = dict[@"conversationName"];
    msg.stamp = dict[@"stamp"];
    msg.body = dict[@"body"];
    msg.bodyType = dict[@"bodyType"];
    msg.from = dict[@"from"];
    msg.to = dict[@"to"];
    msg.type = dict[@"type"];
    msg.UID = dict[@"UID"];
    msg.SenderJID = dict[@"SenderJID"];
    [msg jh_saveOrUpdate];
    
    
   // [self settingData];
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
    
    Message *model = self.datasource[indexPath.item];
    CGSize size = [model.body sizeWithFontSize:17.0 maxSize:CGSizeMake(kScreenWidth-120, MAXFLOAT)];
    
    if (size.height + 30 < 70) {
        return CGSizeMake(kScreenWidth, 70);
    }
    return CGSizeMake(kScreenWidth, size.height + 40);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    Message *model = self.datasource[indexPath.item];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView  *reuseableView = nil;
//    __weak typeof(self) weakself = self;
//    if (kind == CHTCollectionElementKindSectionHeader)
//    {
//        RosterReuseableHeader *aRosterReuseableHeader =
//        [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"roster_header" forIndexPath:indexPath];
//        [aRosterReuseableHeader setARosterReuseableHeaderSelectBlock:^(NSInteger tag) {
//
//        }];
//        reuseableView = aRosterReuseableHeader;
//    }
//    return reuseableView;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
//    Message *model = self.datasource[indexPath.item];
//    CGSize size = [model.body sizeWithFontSize:14.0 maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    return CGSizeMake(kScreenWidth, 30+size.height);
//}











#pragma mark - Init


-(instancetype)initWithCurrentOtherJID:(NSString *)aCurrentOtherJID {
    self = [super init];
    if (self) {
        self.currentOtherJID = aCurrentOtherJID;
    }
    return self;
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
        
        //_chLayout.headerHeight = 174;  /**页眉页脚高度：设置了之后必须实现，不然报错**/
        //_chLayout.footerHeight = 100;
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64 - 49)
                           collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  [UIColor whiteColor];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        //__weak typeof(self) weakself = self;
        //        _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakself settingData];
        //        }];
        [_collectionview registerClass:[ChatCell class]
            forCellWithReuseIdentifier:@"ChatCell"];
        //        [_collectionview registerClass:[RosterReuseableHeader class]
        //            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
        //                   withReuseIdentifier:@"roster_header"];
    }
    return _collectionview;
}
-(UIView *)inputView {
    if (!_inputView) {
        _inputView = [[InputView alloc] init];
        _inputView.frame = CGRectMake(0, kScreenHeight-49, kScreenWidth, 49);
        _inputView.backgroundColor = kBackgroundColor;
    }
    return _inputView;
}















@end