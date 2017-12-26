//
//  NewFriendController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/26.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "NewFriendController.h"
#import "UIConfig.h"
#import "Message.h"
#import "LTSDKFull.h"


@interface NewFriendController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end




@implementation NewFriendController

#pragma mark - UI
-(void)settingUI {
    
    [self.view addSubview:self.tableView];
    
}

-(void)settingData {
    
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];
    NSMutableArray *arrM = [NSMutableArray array];
    /**会话数组**/
    NSArray *arr = [Message jh_queryCurrentOtherJIDByMyJID:myJID];
    
    for (Message *msg in arr)
    {
        /**会话名**/
        NSString *conversationName = msg.conversationName;
        NSArray *arr02 = [Message jh_queryByConversationName:conversationName currentMyJID:myJID];
        
        for (Message *newMessage in arr02)
        {
            NSString *type = newMessage.type;
            BOOL isNewFriend = NO;
            if ([type isEqualToString:@"NewFriend"])
            {
                isNewFriend = YES;
            }
            
            BOOL isHave = NO;
            for (Message *message in arrM)
            {
                if ([message.from isEqualToString:newMessage.from]) {
                    isHave = YES;
                }
            }
            
            if (isHave == NO && isNewFriend) {
                [arrM addObject:newMessage];
            }
        }
    }
    self.dataSource = arrM;
    [self.tableView reloadData];
}




#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新的好友";
    self.view.backgroundColor = kBackgroundColor;
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









#pragma mark - Private

/**
 接受好友请求
 **/
-(void)acceptNewFriend:(Message *)message {
    NSString *aFriendJid = message.currentOtherJID;
    NSString *aFriendName = message.from;
    [LTFriend.share acceptAddFriendJid:aFriendJid friendName:aFriendName];
    [self deleteNewFriendRecode:message];
}

/**
 拒绝好友请求
 **/
-(void)refrusedNewFriend:(Message *)message {
    NSString *aFriendJid = message.currentOtherJID;
    //NSString *aFriendName = message.from;
    [LTFriend.share refuseAddFriendJid:aFriendJid];
    [self deleteNewFriendRecode:message];
}

/**
 删除请求记录
 **/
-(void)deleteNewFriendRecode:(Message *)message {
    
    NSString *type = message.type;
    NSString *myJID = message.currentMyJID;
    NSString *otherJID = message.currentOtherJID;
    NSString *otherName = message.from;
    
    [Message jh_deleteMessageByType:type
                       currentMyJID:myJID
                     curentOtherJID:otherJID
                   currentOtherName:otherName];
    
    //[self settingData];
    [self.navigationController popViewControllerAnimated:YES];
}








#pragma mark - 代理：tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriendCell"];
    //cell.textLabel.text = @"name";
    
    Message *msg  =  self.dataSource[indexPath.row];
    //    NSLog(@"== %@",msg.currentOtherJID);
    cell.textLabel.text = msg.from;
    cell.imageView.image = [UIImage imageNamed:@"NewFriend"];
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    ChatController *chatvc = [[ChatController alloc] init];
//    [self.navigationController pushViewController:chatvc animated:YES];
//}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    Message *model = self.dataSource[indexPath.row];
//}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = self.dataSource[indexPath.row];
    
    __weak typeof(self) weakself = self;
    UITableViewRowAction *action01 =
    [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive)
                                       title:@"拒绝"
                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                         [weakself refrusedNewFriend:message];
                                     }];
    
    UITableViewRowAction *action02 =
    [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal)
                                       title:@"接受"
                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                         [weakself acceptNewFriend:message];
                                     }];
    
    NSArray *arr = @[action01,action02];
    return arr;
}











#pragma mark - Init
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView =
        [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49)
                                     style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NewFriendCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
