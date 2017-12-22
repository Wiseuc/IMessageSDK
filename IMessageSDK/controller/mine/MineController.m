//
//  MineController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/14.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "MineController.h"
#import "UIConfig.h"
#import "MineCell01.h"
#import "MineCell02.h"
#import "LTSDKFull.h"
#import "InformationController.h"




@interface MineController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end





@implementation MineController

#pragma mark - UI
- (void)setUI {
    [self.view addSubview:self.tableView];
    
    UIButton *logoutBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
    logoutBTN.frame = CGRectMake(0, 20, 300, 50);
    [logoutBTN setTitle:@"Log Out" forState:(UIControlStateNormal)];
    [logoutBTN setBackgroundColor:kDarkGreenColor];
    [logoutBTN setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    logoutBTN.layer.cornerRadius = 4;
    logoutBTN.layer.masksToBounds = YES;
    logoutBTN.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [logoutBTN addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.tableView.tableFooterView = logoutBTN;
    
    
    
    
    
    
    /*****不要动我代码***********不要动我代码*******不要动我代码***********不要动我代码********/
    UILabel *jhLAB = [[UILabel alloc] init];
    jhLAB.frame = CGRectMake((kScreenWidth-300)/2, kScreenHeight-40-49, 300, 20);
    jhLAB.text = @"IMessageSDK版权由深圳市励拓软件有限公司所有，盗版必究";
    jhLAB.textColor = [UIColor lightGrayColor];
    jhLAB.font = [UIFont boldSystemFontOfSize:10.0];
    [self.view addSubview:jhLAB];
    jhLAB.textAlignment = NSTextAlignmentCenter;
    
    UILabel *jhLAB02 = [[UILabel alloc] init];
    jhLAB02.frame = CGRectMake((kScreenWidth-200)/2, kScreenHeight-20-49, 200, 20);
    jhLAB02.text = @"Editor：江海   TEL:18823780407";
    jhLAB02.textColor = [UIColor lightGrayColor];
    jhLAB02.font = [UIFont boldSystemFontOfSize:10.0];
    [self.view addSubview:jhLAB02];
    jhLAB02.textAlignment = NSTextAlignmentCenter;
   /*****不要动我代码*******不要动我代码*********不要动我代码**************不要动我代码********/
}
- (void)setDatas
{
    NSArray *titles = @[
                        @"我的信息",
                        @"软件设置",
                        @"关于"
                        ];
    NSArray *images = @[
                        @"wodexinxi",
                        @"wodefangchang",
                        @"shezhi"
                        ];
    
    [self.dataSource removeAllObjects];
    for (NSInteger i = 0; i < titles.count; i ++) {
        [self.dataSource addObject:titles[i]];
    }
    [self.tableView reloadData];
}







#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    
    [self setUI];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setDatas];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}








#pragma mark - private

-(void)buttonClick:(UIButton *)sender {
    
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:@"注销之后将不能及时收到消息,确定注销账号吗" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [LTLogin.share asyncLogout];
        [kMainVC showLoginController];
    }];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertvc addAction:ac1];
    [alertvc addAction:ac2];
    [self presentViewController:alertvc animated:YES completion:nil];
    
}








#pragma mark - 代理：tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
        MineCell01 *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell01"];
        NSDictionary  *userDict = [LTUser.share queryUser];
        NSString *UserName = userDict[@"UserName"];
        //NSString *JID = userDict[@"JID"];
        //NSString *IMPwd = userDict[@"IMPwd"];
        
        [cell setTitle:UserName];
        return cell;
    }
    MineCell02 *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell02"];
    [cell setTitle:self.dataSource[indexPath.item]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {

    }else if (indexPath.section == 1){
        
        NSInteger row = indexPath.row;
        if (row == 0)
        {
            NSDictionary  *userDict = [LTUser.share queryUser];
            //NSString *UserName = userDict[@"UserName"];
            NSString *JID = userDict[@"JID"];
            //NSString *IMPwd = userDict[@"IMPwd"];
            InformationController *infovc = [[InformationController alloc] init];
            infovc.jid = JID;
            [self.navigationController pushViewController:infovc animated:YES];
        }
        else if (row == 1)
        {
            
        }
        else if (row == 2)
        {
            
        }
        
    }
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? NO : YES;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44) style:UITableViewStyleGrouped];
        [_tableView registerClass:[MineCell01 class] forCellReuseIdentifier:@"MineCell01"];
        [_tableView registerClass:[MineCell02 class] forCellReuseIdentifier:@"MineCell02"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
