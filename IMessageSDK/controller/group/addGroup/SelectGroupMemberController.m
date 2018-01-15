//
//  SelectGroupMemberController.m
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//选择群成员

#import "SelectGroupMemberController.h"
#import "UIConfig.h"
#import "RATreeView.h"
#import "OrgModel.h"
#import "DocManager.h"
#import "SelectGroupMemberCell.h"



@interface SelectGroupMemberController ()
<
RATreeViewDataSource,
RATreeViewDelegate
>

@property (nonatomic, strong) RATreeView *treeView;         // 树形结构

@property (nonatomic, strong) NSMutableArray *firstDatasource;
@property (nonatomic, strong) NSMutableArray *selectedDatasource;
@property (nonatomic, strong) NSMutableArray *datasource;


@property (nonatomic, strong) SelectGroupMemberBlock aSelectGroupMemberBlock;
@end









@implementation SelectGroupMemberController

#pragma mark - UI

-(void)settingUI {
    UIBarButtonItem *rightItem =
    [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(commit)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self.view addSubview:self.treeView];
    
    
    
    
    
}

-(void)settingData {
    /**第一层数据**/
    NSArray *arr = [self parseOrgWith:nil];
    self.firstDatasource = [arr mutableCopy];
    
    
    
    /**第二层到最后一层数据**/
    for (OrgModel *model in self.firstDatasource) {
        [self findModelInModel:model];
    }
    [self.treeView reloadData];
    
}

/**第二层到最后一层数据**/
- (void)findModelInModel:(OrgModel *)model {
    
    //SUBGROUP
    if ([model.ITEMTYPE isEqualToString:@"1"])
    {
        model.children = [self parseOrgWith:model];
        
        for (OrgModel *orgModel in model.children)
        {
            orgModel.lever = model.lever + 1;
            
            orgModel.parent = @[model];
            
            [self findModelInModel:orgModel];
        }
        [self.datasource addObject:model];
    }
    //JID
    else if ([model.ITEMTYPE isEqualToString:@"2"])
    {
        
    }
}

/**解析组织架构**/
- (NSArray *)parseOrgWith:(OrgModel *)model {
    
    NSArray *datas = nil;
    
    if ( model == nil || [model.ID isEqualToString:@"0"] )
    {
        datas = [DocManager.share queryNextOrgData:nil];
    }else {
        datas = [DocManager.share queryNextOrgData:model];
    }
    return datas;
}










#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = kBackgroundColor;
    
    self.title = @"选择群组成员";
    
    [self settingUI];
    
    [self settingData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}













#pragma mark - Public

-(void)selectGroupMember:(SelectGroupMemberBlock)aBlock {
    self.aSelectGroupMemberBlock = aBlock;
}

#pragma mark - private
/**提交**/
-(void)commit {
    
    for (OrgModel *model in self.datasource) {
        
        [self getModelIsSelected:model];
    }
    if (self.aSelectGroupMemberBlock) {
        self.aSelectGroupMemberBlock([self.selectedDatasource copy]);
    }
    [self back];
}
-(void)getModelIsSelected:(OrgModel *)model {
    
    if ([model.ITEMTYPE isEqualToString:@"1"])
    {
        for (OrgModel *model2 in model.children) {
            [self getModelIsSelected:model2];
        }
    }
    else  if ([model.ITEMTYPE isEqualToString:@"2"])
    {
        if (model.isSelect)
        {
            [self.selectedDatasource addObject:model];
        }
    }
}



















#pragma mark - 代理：TreeView

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 50;
}
//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {

}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    
}
// 只有刷新 和展开 才会走此方法
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    OrgModel *model = item;
    SelectGroupMemberCell *cell = [self.treeView dequeueReusableCellWithIdentifier:@"SelectGroupMemberCell"];
    
//     __weak typeof(self) weakSelf = self;
    [cell setModel:model completed:^(OrgModel *model) {
        
        if ([model.ITEMTYPE isEqualToString:@"1"]) //subgroup
        {
            
        }
        else if ([model.ITEMTYPE isEqualToString:@"2"]) //jid
        {
            model.isSelect = !model.isSelect;
            [_treeView reloadRowsForItems:@[model] withRowAnimation:(RATreeViewRowAnimationTop)];
        }
    }];
    return cell;
}
/**
 *  必须实现
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item == nil) {
        return [self.datasource count];
    }
    
    OrgModel *model = item;
    return [model.children count];
}
/**
 *必须实现的dataSource方法
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    OrgModel *model = item;
    if (item == nil) {
        return [self.datasource objectAtIndex:index];
    }
    return model.children[index];
}





/** cell是否高亮显示**/
//- (BOOL)treeView:(RATreeView *)treeView shouldHighlightRowForItem:(id)item {
//    return YES;
//}
//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    [treeView deselectRowForItem:item animated:YES];
}
//编辑要实现的方法
//- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
//    NSLog(@"编辑了实现的方法");
//}










#pragma mark - Init

-(NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
-(NSMutableArray *)firstDatasource {
    if (!_firstDatasource) {
        _firstDatasource = [NSMutableArray array];
    }
    return _firstDatasource;
}
-(NSMutableArray *)selectedDatasource {
    if (!_selectedDatasource) {
        _selectedDatasource = [NSMutableArray array];
    }
    return _selectedDatasource;
}




-(RATreeView *)treeView {
    if (!_treeView) {
        _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 64 , kScreenWidth, kScreenHeight - 64)];
        
        _treeView.delegate = self;
        _treeView.dataSource = self;
        _treeView.treeFooterView = [UIView new];
        _treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
        
        //self.treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_treeView registerClass:[SelectGroupMemberCell class] forCellReuseIdentifier:@"SelectGroupMemberCell"];
        _treeView.backgroundColor = [UIColor whiteColor];
    }
    return _treeView;
}





@end
