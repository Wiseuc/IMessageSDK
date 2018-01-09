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
#import "LTSDKFull.h"
#import "Message.h"
#import "NSString+Extension.h"
#import "VideoController.h"
#import "LXChatBox.h"

#import "ChatTextCell.h"
#import "ChatVoiceCell.h"
#import "ChatFileCell.h"
#import "ChatImageCell.h"
#import "ChatLocationCell.h"
#import "ChatVideoCell.h"
#import "ChatVibrateCell.h"
#import "ChatCommandCell.h"

#import "InformationController.h"
#import "EMCDDeviceManager.h"
#import "HMImagePickerController.h"
#import "LTPictureMessage.h"




@interface ChatController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate,
LTChatBoxDelegate,
//UIImagePickerControllerDelegate,
//UINavigationControllerDelegate,
HMImagePickerControllerDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSString *currentOtherJID;  /**对方jid**/
@property (nonatomic, strong) NSString *conversationName; /**对方name**/
@property (nonatomic, strong) LXChatBox *chatBox;  /**输入框**/

@property (nonatomic) NSArray *selectImages;   // 选中照片数组
//@property (nonatomic) NSMutableArray *selectedAssets; // 选中资源素材数组，用于定位已经选择的照片
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
        if (message.body != nil && message.body.length > 0
            && ![message.type isEqualToString:@"NewFriend"]) {
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
        
        NSIndexPath *indexpath =
        [NSIndexPath indexPathForItem:self.datasource.count-1 inSection:0];
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

/*!
 @method
 @abstract 发送文本信息
 @discussion <#备注#>
 @param content <#描述1#>
 */
-(void)sendTextMessage:(NSString *)content {
    
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID =userDict[@"JID"];
    //会话类型
    LTConversationType type = LTConversationTypeChat;
    
    if ([self.currentOtherJID containsString:@"conference"]) {
        type = LTConversationTypeGroupChat;
    }
    NSDictionary *dict =
    [LTMessage.share sendTextWithSenderJID:myJID
                                  otherJID:self.currentOtherJID
                          conversationName:self.conversationName
                          conversationType:(type)
                               messageType:(LTMessageType_Text)
                                      body:content];
    [self dealData:dict];
}

/*!
 @method
 @abstract 发送语音信息
 @discussion null
 @param localPath  /var/mobile/Containers/Data/Application/D713BC89-59C4-428B-BA05-A64C280D0084/Documents/wiseuc/Voice/151539219460275.mp3
 @param aDuration 语音时长
 */
-(void)sendVoiceMessageWithVoiceLocalPath:(NSString *)voiceLocalPath
                                 duration:(NSString *)aDuration {
 
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID =userDict[@"JID"];
    //会话类型
    LTConversationType type = LTConversationTypeChat;
    if ([self.currentOtherJID containsString:@"conference"]) {
        type = LTConversationTypeGroupChat;
    }
    
    //151539219460275.mp3
    NSString *aBody = [voiceLocalPath lastPathComponent];
    NSDictionary *dict =
    [LTMessage.share sendVoiceWithSenderJID:myJID
                                   otherJID:self.currentOtherJID
                           conversationName:self.conversationName
                           conversationType:(type)
                                messageType:(LTMessageType_Voice)
                                  localPath:voiceLocalPath
                                   duration:aDuration
                                       body:aBody];
    [self dealData:dict];
}

/*!
 @method
 @abstract 发送图片信息
 @discussion <#备注#>
 @param aImage 图片
 */
-(void)sendImageMessageWithImage:(UIImage *)aImage {
    //保存图片到沙盒本地
    //内部进行压缩处理
    [LTPictureMessage saveImageToLocal:aImage
                         isCompression:YES
                              complete:^(BOOL finished, NSString *localPath) {
                                  
                                  if (finished)
                                  {
                                      NSDictionary *userDict = [LTUser.share queryUser];
                                      NSString *myJID =userDict[@"JID"];
                                      //会话类型
                                      LTConversationType type = LTConversationTypeChat;
                                      if ([self.currentOtherJID containsString:@"conference"]) {
                                          type = LTConversationTypeGroupChat;
                                      }
                                      
                                      //151539219460275.jpg
                                      NSString *aBody = [localPath lastPathComponent];
                                      NSDictionary *dict = [LTMessage.share sendImageWithSenderJID:myJID
                                                                     otherJID:self.currentOtherJID
                                                             conversationName:self.conversationName
                                                             conversationType:(type)
                                                                  messageType:LTMessageType_Image
                                                                    localPath:localPath
                                                                         body:aBody];
                                      [self dealData:dict];
                                  }
                              }];
}

-(void)dealData:(NSDictionary *)dict {
    Message *msg = [[Message alloc] init];
    msg.currentMyJID = dict[@"currentMyJID"];
    msg.currentOtherJID = dict[@"currentOtherJID"];
    msg.body = dict[@"body"];
    msg.bodyType = dict[@"bodyType"];
    msg.stamp = dict[@"stamp"];
    
    //一组
    msg.UID = dict[@"UID"];
    
    //二组
    msg.to = dict[@"to"];
    
    //三组
    msg.conversationName = dict[@"conversationName"];
    //msg.SenderJID = dict[@"SenderJID"];  //为空，则为nil
    
    //四组
    msg.from = dict[@"from"];
    msg.type = dict[@"type"];
    
    //voice
    msg.duration = dict[@"duration"]; //为空，则为nil
    msg.localPath = dict[@"localPath"];
    msg.remotePath = dict[@"remotePath"];
    
    //file
    //xxx
    
    [msg jh_saveOrUpdate];
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
    
    if ([model.bodyType isEqualToString:@"text"]){
        // <i@12.gif会影响长度计算>
        body = [body stringByReplacingOccurrencesOfString:@"<i@" withString:@""];
        body = [body stringByReplacingOccurrencesOfString:@".gif>" withString:@""];
        CGSize size = [body sizeWithFontSize:17.0 maxSize:CGSizeMake(kScreenWidth-120, MAXFLOAT)];
        //NSLog(@"width0== %f   height0 == %f", size.width,size.height );
        
        //行数
        int row = size.height/20.28;
        //NSLog(@"行数：%i",row);
        
        //20.28为一行高度(font = 17)
        size = CGSizeMake(kScreenWidth, 40 + 30 + 20.28 * (row-1));
        return size;
    }
    else if ([model.bodyType isEqualToString:@"voice"]){
        return CGSizeMake(kScreenWidth, 40 + 30);
    }
    else if ([model.bodyType isEqualToString:@"image"]){
        return CGSizeMake(kScreenWidth, 30 + 150);
    }
    else if ([model.bodyType isEqualToString:@"file"]){
    }
    else if ([model.bodyType isEqualToString:@"video"]){
    }
    else if ([model.bodyType isEqualToString:@"command"]){
    }
    else if ([model.bodyType isEqualToString:@"vibrate"]){
    }
    else if ([model.bodyType isEqualToString:@"location"]){
    }
    return CGSizeMake(kScreenWidth, 40 + 30);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    Message *model = self.datasource[indexPath.item];
    UICollectionViewCell *cell = nil;
    
    if ([model.bodyType isEqualToString:@"text"]){
        LTMessageType type = LTMessageType_Text;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatTextCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        return cell01;
    }
    else if ([model.bodyType isEqualToString:@"voice"]){
        LTMessageType type = LTMessageType_Voice;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatVoiceCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        
        //tapG点击手势
        [cell01 settingChatVoiceCellTapBlock:^(Message *model) {
            [EMCDDeviceManager.sharedInstance asyncPlayingWithPath:model.localPath
                                                        completion:^(NSError *error) {
           
                                                        }];
        }];
        
        //longG长按手势
        
        return cell01;
    }
    else if ([model.bodyType isEqualToString:@"image"]){
        LTMessageType type = LTMessageType_Image;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatImageCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        return cell01;
    }
    else if ([model.bodyType isEqualToString:@"file"]){
        LTMessageType type = LTMessageType_File;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatFileCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        return cell01;
    }
    else if ([model.bodyType isEqualToString:@"video"]){
        LTMessageType type = LTMessageType_Video;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatVideoCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        return cell01;
    }
    else if ([model.bodyType isEqualToString:@"command"]){
        LTMessageType type = LTMessageType_Command;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatTextCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        return cell01;
    }
    else if ([model.bodyType isEqualToString:@"vibrate"]){
        LTMessageType type = LTMessageType_Vibrate;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatVibrateCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        return cell01;
    }
    else if ([model.bodyType isEqualToString:@"location"]){
        LTMessageType type = LTMessageType_Location;
        NSString *cellIndentifier = [self cellIndetifyForMessageType:type];
        ChatLocationCell *cell01 =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
        cell01.model = model;
        return cell01;
    }

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
            // 显示相册
//            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
//            pickerC.delegate = self;
//            [self presentViewController:pickerC
//                               animated:YES
//                             completion:nil];
            
//            [self.selectImages removeAllObjects];
//            [self.selectedAssets removeAllObjects];
            HMImagePickerController *picker =
            [[HMImagePickerController alloc] initWithSelectedAssets:nil];
            picker.pickerDelegate = self;            // 设置图像选择代理
            picker.targetSize = CGSizeMake(600, 600);// 设置目标图片尺寸
            picker.maxPickerCount = 9;               // 设置最大选择照片数量
            [self presentViewController:picker animated:YES completion:nil];
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
    [self sendTextMessage:text];
    if (self.datasource.count > 0) {
        [self.collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.datasource.count-1 inSection:0]
                                    atScrollPosition:(UICollectionViewScrollPositionBottom)
                                            animated:YES];
    }
}

/**发送音频voice**/
-(void)chatBox:(LXChatBox *)chatBox
     sendVoice:(NSString *)voiceLocalPath
       seconds:(NSInteger)duration{
    
    NSString *aDuration = [NSString stringWithFormat:@"%li",duration];
    [self sendVoiceMessageWithVoiceLocalPath:voiceLocalPath
                                    duration:aDuration];
}









#pragma mark - HMImagePicker

- (void)imagePickerController:(HMImagePickerController *)picker
      didFinishSelectedImages:(NSArray<UIImage *> *)images
               selectedAssets:(NSArray<PHAsset *> *)selectedAssets {
    
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"发送原图会消耗大量流量，是否发送压缩图？"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"发送原图"
                             style:UIAlertActionStyleCancel
                           handler:nil];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                           handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    self.selectImages = images; // 记录图像，方便在 CollectionView 显示
//    self.selectedAssets = [selectedAssets mutableCopy]; // 记录选中资源集合，方便再次选择照片定位
    
    for (id image in self.selectImages) {
        [self sendImageMessageWithImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

        [_collectionview registerClass:[ChatTextCell class]
            forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_Text)]];
        [_collectionview registerClass:[ChatVoiceCell class]
             forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_Voice)]];
        [_collectionview registerClass:[ChatFileCell class]
             forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_File)]];
        [_collectionview registerClass:[ChatImageCell class]
             forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_Image)]];
        [_collectionview registerClass:[ChatLocationCell class]
             forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_Location)]];
        [_collectionview registerClass:[ChatVideoCell class]
             forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_Video)]];
        [_collectionview registerClass:[ChatVibrateCell class]
             forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_Vibrate)]];
        [_collectionview registerClass:[ChatCommandCell class]
            forCellWithReuseIdentifier:[self cellIndetifyForMessageType:(LTMessageType_Command)]];
        
        //__weak typeof(self) weakself = self;
        //        _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakself settingData];
        //        }];
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

//-(NSMutableArray *)selectImages{
//    if (!_selectImages) {
//        _selectImages = [NSMutableArray array];
//    }
//    return _selectImages;
//}
//-(NSMutableArray *)selectedAssets{
//    if (!_selectedAssets) {
//        _selectedAssets = [NSMutableArray array];
//    }
//    return _selectedAssets;
//}




/*!
 @method
 @abstract 根据消息类型取不同的cell
 @discussion <#备注#>
 @param aMessageType 消息类型
 @result  信息cell
 */
- (NSString *)cellIndetifyForMessageType:(LTMessageType)aMessageType{
    
    switch (aMessageType) {
        case LTMessageType_Text:
            return @"ChatTextCell";
            break;
            
        case LTMessageType_Voice:
            return @"ChatVoiceCell";
            break;
            
        case LTMessageType_Image:
            return @"ChatImageCell";
            break;


        case LTMessageType_File:
            return @"ChatFileCell";
            break;

        case LTMessageType_Video:
            return @"ChatVideoCell";
            break;

        case LTMessageType_Command:
            return @"ChatCell_command";
            break;


        case LTMessageType_Vibrate:
            return @"ChatVibrateCell";
            break;

        case LTMessageType_Location:
            return @"ChatLocationCell";
            break;
            
        default:
            break;
    }
}



@end
