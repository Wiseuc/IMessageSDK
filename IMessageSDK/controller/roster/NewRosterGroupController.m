//
//  NewRosterGroupController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/26.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "NewRosterGroupController.h"
#import "UIConfig.h"
#import "NewRosterMessage.h"
#import "LTSDKFull.h"



@interface NewRosterGroupController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end









@implementation NewRosterGroupController

#pragma mark - UI

-(void)settingUI {
    
    [self.view addSubview:self.tableView];
}

-(void)settingData {

    /**给新的朋友和新的群组 添加一个红点**/
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];
    
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSArray *jids = [NewRosterMessage jh_queryAllCurrentOtherJIDByCurrentMyJID:myJID];
    for (NSString *jid in jids) {
        [arrM addObject:jid];
    }
    self.dataSource = [arrM copy];
    [self.tableView reloadData];
    
}
    
    
    






#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的好友／群组";
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
-(void)acceptNewFriend:(NSString *)jid {
    NSString *aFriendJid = jid;
    NSString *aFriendName = [jid componentsSeparatedByString:@"@"].firstObject;
    [LTFriend.share acceptAddFriendJid:aFriendJid friendName:aFriendName];
    [self deleteNewFriendRecode:jid];
}

/**
 拒绝好友请求
 **/
-(void)refrusedNewFriend:(NSString *)jid {
    NSString *aFriendJid = jid;
    //NSString *aFriendName = message.from;
    [LTFriend.share refuseAddFriendJid:aFriendJid];
    [self deleteNewFriendRecode:jid];
}

/**
 删除请求记录
 **/
-(void)deleteNewFriendRecode:(NSString *)jid {
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];

    [NewRosterMessage jh_deleteMessageByType:@"NewRoster"
                                currentMyJID:myJID
                              curentOtherJID:jid];
    
    //[self settingData];
    [self.navigationController popViewControllerAnimated:YES];
}















#pragma mark - 代理：tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewRosterGroupCell"];
    NSString *jid = self.dataSource[indexPath.row];
    
    if ([jid containsString:@"conference"]) {
        cell.imageView.image = [UIImage imageNamed:@"group"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"roster"];
    }
    cell.textLabel.text = [jid componentsSeparatedByString:@"@"].firstObject;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                 editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *jid = self.dataSource[indexPath.row];
    
    UITableViewRowAction *action01 =
    [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive)
                                       title:@"拒绝"
                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                         [self refrusedNewFriend:jid];
                                     }];
    UITableViewRowAction *action02 =
    [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal)
                                       title:@"同意"
                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                         [self acceptNewFriend:jid];
                                     }];
    NSArray *arr = @[action01,action02];
    return arr;
}
//自定义段头断尾视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    if (section == 0)
    {
        [button setTitle:@"新的好友" forState:UIControlStateNormal];
    }else if (section == 1){
        [button setTitle:@"新的群组" forState:UIControlStateNormal];
    }
    
    return button;
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
        [[UITableView alloc] initWithFrame:self.view.bounds
                                     style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NewRosterGroupCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



@end
