//
//  AddRGBottomSelectMenu
//  WiseUC
//
//  Created by JH on 2017/7/3.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "AddRGBottomSelectMenu.h"
#import "AddRGBottomSelectMenuCell.h"
#define WIDTH  UIScreen.mainScreen.bounds.size.width
#define HEIGHT UIScreen.mainScreen.bounds.size.height
@interface AddRGBottomSelectMenu ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *titles;

@end



@implementation AddRGBottomSelectMenu
#pragma mark
#pragma mark =====初始化

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
        [self loadData];
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }
    return self;
}
-(NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
-(void)back {
    [NSThread sleepForTimeInterval:0.2];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _tableview.frame = CGRectMake(0, HEIGHT, WIDTH, self.titles.count * 50);
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}




#pragma mark
#pragma mark =====UI
-(void)loadUI {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self addSubview:view];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [view addGestureRecognizer:tapG];
    
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, self.titles.count * 50) style:0];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.estimatedRowHeight = 50;
    _tableview.tableFooterView = [UIView new];
    [self addSubview:_tableview];
    [_tableview registerClass:[AddRGBottomSelectMenuCell class] forCellReuseIdentifier:@"AddRGBottomSelectMenuCell"];
    
}

#pragma mark
#pragma mark ====数据

-(void)loadData {
    
    self.titles = @[
                    @"查找朋友",
                    @"刷新组织架构",
                    @"取消",
                    ];
    
    
    
    [_tableview reloadData];
}


#pragma mark
#pragma mark =====布局
-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _tableview.frame = CGRectMake(0, HEIGHT - (self.titles.count * 50), WIDTH, self.titles.count * 50);
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
        
    }];
    
}







#pragma mark
#pragma mark 代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddRGBottomSelectMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddRGBottomSelectMenuCell"];
    cell.titlelabel.text = self.titles[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(addRGBottomSelectMenuDelegate:didSelectRowAtIndexPath:)]) {
        [_delegate addRGBottomSelectMenuDelegate:self didSelectRowAtIndexPath:indexPath];
    }
    [self back];
}

@end
