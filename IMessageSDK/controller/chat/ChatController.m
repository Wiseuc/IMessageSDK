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
#import "VideoController.h"
#import "LXChatBox.h"

@interface ChatController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate,
LTChatBoxDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSString *currentOtherJID;  /**对方jid**/
@property (nonatomic, strong) NSString *conversationName; /**对方name**/
@property (nonatomic, strong) LXChatBox *chatBox;  /**输入框**/
@end








@implementation ChatController

#pragma mark - UI

-(void)settingUI {
    
    [self.view addSubview:self.collectionview];
    
    [self settingUIBarButtonItem];
    
    /**添加输入框 - 开始输入**/
    [self.view addSubview:self.chatBox];
}
-(void)settingUIBarButtonItem{
    UIBarButtonItem *rightItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wode_changtai"]
                                     style:UIBarButtonItemStylePlain
                                    target:self action:@selector(pushToInformationController)];
    
    UIBarButtonItem *rightItem2 =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TabBar_Call_NL"]
                                     style:UIBarButtonItemStylePlain
                                    target:self action:@selector(sendRequestQueryPIDWithJID)];
    
    rightItem.tag = 1001;
    rightItem2.tag = 1002;
    self.navigationItem.rightBarButtonItems = @[rightItem /**rightItem2**/ ];
}
-(void)pushToInformationController {    
    InformationController *infovc = [[InformationController alloc] initWithJID:self.currentOtherJID];
    [self.navigationController pushViewController:infovc animated:YES];
}
/**
 根据jid请求PID
 **/
// FIXME:video
-(void)sendRequestQueryPIDWithJID {
    
    __weak typeof(self) weakself = self;
    [LTUser.share sendRequestPidWithJid:self.currentOtherJID
                              completed:^(NSDictionary *dict, LTError *error) {
        NSString *key = dict.allKeys.firstObject;
                                  
        if ([key isEqualToString:@"myPID"])
        {
        }
        else if ([key isEqualToString:@"otherPID"])
        {
            NSString *otherPID = dict[@"otherPID"];
            
            if ([self.currentOtherJID containsString:@"conference"])
            {
                
            }
            else
            {
                [weakself pushToVideoControllerWithPID:otherPID];
            }
        }
    }];

}
-(void)pushToVideoControllerWithPID:(NSString *)otherPID {
    VideoController *videovc =[[VideoController alloc] initWithPID:otherPID];
    [self presentViewController:videovc animated:YES completion:nil];
}


/**点击屏幕**/
-(void)settingGesture {
    UITapGestureRecognizer *tapG =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing)];
    tapG.numberOfTapsRequired = 1;
    tapG.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapG];
}
-(void)viewEndEditing {
    [self.view endEditing:YES];
    self.chatBox.status = LTChatBoxStatusNothing;
}











#pragma mark - Data

-(void)settingData {
    if (self.currentOtherJID == nil) {
        return;
    }
    /**通过对方jid获取**/
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];
    NSArray *arr = [Message jh_queryByCurrentOtherJID:self.currentOtherJID currentMyJID:myJID];
    if (arr == nil || arr.count == 0) {
        return;
    }
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (Message *message in arr) {
        if (message.body != nil && message.body.length > 0 && ![message.type isEqualToString:@"NewFriend"]) {
            [arrTemp addObject:message];
        }
    }
    
    self.datasource = [arrTemp mutableCopy];
    
    if (self.datasource.count == 0) {
        return;
    }
    [self refreshData];
    
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
    
    [self settingUI];
    
    [self settingGesture];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self settingDBOberser];
    
    [kMainVC hiddenTbaBar];
    
    [self settingData];
    
    self.chatBox.isDisappear = NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unsettingDBOberser];
    
    [kMainVC showTbaBar];
    
    self.chatBox.isDisappear = YES;
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
    if ([self.currentOtherJID isEqualToString:@"conference"])
    {
        NSDictionary *dict02 =
        [LTMessage.share sendMessageWithSenderJID:myJID
                                         otherJID:self.currentOtherJID
                                             body:content];
        [self dealData:dict02];
    }
    else
    {
        NSDictionary *dict03 =
        [LTMessage.share sendConferenceMessageWithSenderJID:myJID
                                              conferenceJID:self.currentOtherJID
                                                      conferenceName:self.conversationName
                                                       body:content];
        [self dealData:dict03];
    }
    
    
    
    
    
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
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *model = self.datasource[indexPath.item];
    
    
    
    NSString *body = model.body;
    
    // <i@12.gif会影响长度计算>
    body = [body stringByReplacingOccurrencesOfString:@"<i@" withString:@""];
    body = [body stringByReplacingOccurrencesOfString:@".gif>" withString:@""];
    NSLog(@"width0== %li", body.length);
    
    CGSize size = [body sizeWithFontSize:17.0 maxSize:CGSizeMake(kScreenWidth-120, MAXFLOAT)];
    
    
    
    NSLog(@"width0== %f   height0 == %f", size.width,size.height );
    
    //行数
    int row = size.height/20.28;
    NSLog(@"行数：%i",row);
    
    
    //20.28为一行高度(font = 17)
    size = CGSizeMake(kScreenWidth, 40 + 30 + 20.28 * (row-1));
    
//    if (size.height < 30)
//    {
//        //70 = 头像40 + 底部间距 + 顶部间距30
//        size = CGSizeMake(kScreenWidth, 40 + 30 + 20.28 * row);
//    }
//    //40.57为2行高度
//    else
//    {
//        size = CGSizeMake(kScreenWidth, size.height + 40);
//    }
    
    
    
//    NSLog(@"width1== %f   height1 == %f", size.width,size.height );
    return size;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"ChatCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    Message *model = self.datasource[indexPath.item];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.chatBox.status = LTChatBoxStatusNothing;
}








#pragma mark - 代理 ChatBox
-(void)changeStatusChat:(CGFloat)chatBoxY{
    
    self.collectionview.frame = CGRectMake(0, 64, kScreenWidth, chatBoxY - 64);
    if (self.datasource.count > 0) {
        [self.collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.datasource.count-1 inSection:0]
                                    atScrollPosition:(UICollectionViewScrollPositionBottom)
                                            animated:YES];
    }
}

/**“更多”页面点击的item**/
-(void)chatBox:(LXChatBox *)chatBox didSelectItem:(LXChatBoxItem)itemType {
    
    switch (itemType) {
        case LXChatBoxItemAlbum:
        {
            NSLog(@"LXChatBoxItemAlbum");
        }
            break;
            
        case LXChatBoxItemDoc:
        {
            NSLog(@"LXChatBoxItemDoc");
        }
            break;
            
        case LXChatBoxItemVideo:
        {
            NSLog(@"LXChatBoxItemVideo");
        }
            break;
            
        case LXChatBoxItemCamera:
        {
            NSLog(@"LXChatBoxItemCamera");
        }
            break;
        default:
            break;
    }
}


/**发送文本text**/
-(void)chatBox:(LXChatBox *)chatBox sendText:(NSString *)text {
    NSAttributedString *attribute =
    [LXEmotionManager transferMessageString:text
                                       font:[UIFont systemFontOfSize:16.0]
                                 lineHeight:[UIFont systemFontOfSize:16.0].lineHeight];
    NSLog(@"=== %@",attribute);
    [self sendMessage:text];
    if (self.datasource.count > 0) {
        [self.collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.datasource.count-1 inSection:0]
                                    atScrollPosition:(UICollectionViewScrollPositionBottom)
                                            animated:YES];
    }
}

/**发送音频voice**/
-(void)chatBox:(LXChatBox *)chatBox
     sendVoice:(NSString *)voiceLocalPath
       seconds:(NSTimeInterval)duration{
    
    
    
    
    
    
}











#pragma mark - Init


//-(instancetype)initWithCurrentOtherJID:(NSString *)aCurrentOtherJID {
//    self = [super init];
//    if (self) {
//        self.currentOtherJID = aCurrentOtherJID;
//    }
//    return self;
//}
-(instancetype)initWithCurrentOtherJID:(NSString *)aCurrentOtherJID
                      conversationName:(NSString *)aConversationName {
    self = [super init];
    if (self) {
        self.currentOtherJID = aCurrentOtherJID;
        self.conversationName = aConversationName;
        
        self.title = self.conversationName;
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
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49)
                           collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor = kBackgroundColor;
        // [UIColor whiteColor];//[[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
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
-(LXChatBox *)chatBox {
    if (!_chatBox) {
        _chatBox = [[LXChatBox alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
        _chatBox.maxVisibleLine = 3;
        _chatBox.delegate = self;
    }
    return _chatBox;
}













@end
