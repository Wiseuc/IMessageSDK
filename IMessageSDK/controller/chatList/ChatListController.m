//
//  ChatListController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "ChatListController.h"
#import "UIConfig.h"
#import "ChatController.h"
#import "ChatListCell.h"
#import "LTSDKFull.h"
#import "Message.h"


@interface ChatListController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end










@implementation ChatListController
#pragma mark - UI
- (void)setUI {
    [self.view addSubview:self.tableView];
}
-(void)refreshData {
    
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];
    NSMutableArray *arrM = [NSMutableArray array];
    /**会话数组**/
    NSArray *arr = [Message jh_queryCurrentOtherJIDByMyJID:myJID];
    
    for (Message *msg in arr) {
        /**会话名**/
        NSString *conversationName = msg.conversationName;
        NSArray *arr02 = [Message jh_queryByConversationName:conversationName currentMyJID:myJID];
        NSLog(@"%li",arr02.count);
        
        Message *message =arr02.lastObject;
        if (message == nil) {
            continue;
        }
        [arrM addObject:message];
    }
    self.dataSource = arrM;
    [self.tableView reloadData];
}
/**
 注册监听bg_tablename表的数据变化，唯一识别标识是@"change".
 */
-(void)settingDBOberser{
    __weak typeof(self) weakself = self;
    [Message settingDBOberser:^{
        [weakself refreshData];
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
    
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self settingDBOberser];
    [self refreshData];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unsettingDBOberser];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
    //cell.textLabel.text = @"name";
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    ChatController *chatvc = [[ChatController alloc] init];
//    [self.navigationController pushViewController:chatvc animated:YES];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Message *model = self.dataSource[indexPath.row];
    
    ChatController *chatvc = [[ChatController alloc] initWithCurrentOtherJID:model.currentOtherJID];
    [self.navigationController pushViewController:chatvc animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    return indexPath.section == 0 ? NO : YES;
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *action01 =
    [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive)
                                       title:@"删除"
                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                      
                                     }];
    
    UITableViewRowAction *action02 =
    [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal)
                                       title:@"置顶"
                                     handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                      
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
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"ChatListCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
