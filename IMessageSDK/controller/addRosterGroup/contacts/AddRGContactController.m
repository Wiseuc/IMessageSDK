//
//  AddRGContactController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "AddRGContactController.h"
#import "UIConfig.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import <Contacts/Contacts.h>
#import "SVProgressHUD.h"
#import "AddRGContactModel.h"
#import "AddRGContactCell.h"



@interface AddRGContactController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end







@implementation AddRGContactController

#pragma mark - UI

-(void)settingUI {
    
    [self.view addSubview:self.collectionview];
}
-(void)settingData {

    [self requestAuthorizationForAddressBook];
}

/*
 请求授权
 
 typedef NS_ENUM(NSInteger, CNAuthorizationStatus)
 {
 CNAuthorizationStatusNotDetermined  未授权
 CNAuthorizationStatusRestricted  受限制
 CNAuthorizationStatusDenied   被拒绝
 CNAuthorizationStatusAuthorized  授权
 } NS_ENUM_AVAILABLE(10_11, 9_0);
 */
-(void)requestAuthorizationForAddressBook{
    if (@available(iOS 9.0, *))
    {
        
        CNAuthorizationStatus authorizationStatus
        = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

        if (authorizationStatus == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            
            [contactStore requestAccessForEntityType:CNEntityTypeContacts
                                   completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                       if (granted) {
                                           [self loadAddressBook];
                                       } else {
                                           [SVProgressHUD showInfoWithStatus:@"授权失败"];
                                       }
                                   }];
        }
        else if (authorizationStatus == CNAuthorizationStatusDenied){
            [SVProgressHUD showInfoWithStatus:@"程序被禁止访问通讯录，请前往隐私设置中更改通讯录访问权限!"];
        }
        else if (authorizationStatus == CNAuthorizationStatusRestricted){
            [SVProgressHUD showInfoWithStatus:@"程序访问通讯录受限，请前往隐私设置中更改通讯录访问权限!"];
        }
        else if (authorizationStatus == CNAuthorizationStatusAuthorized){
            [self loadAddressBook];
        }
        
    }
    else
    {
        //@available(iOS *, 9.0)
    }
}

-(void)loadAddressBook{

    if (@available(iOS 9.0, *))
    {
        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
        NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            AddRGContactModel *model = [[AddRGContactModel alloc]init];
            //名字
            NSString *familyName = contact.familyName;
            NSString *givenName = contact.givenName;
            if (familyName && givenName) {
                model.username = [NSString stringWithFormat:@"%@%@",familyName, givenName];
            }else if(familyName){
                model.username = familyName;
            } else if(givenName){
                model.username = givenName;
            }else{
                model.username = @"无名字";
            }
            
            //电话
            NSArray *phoneNumbers = contact.phoneNumbers;
            NSMutableArray *arrM = [NSMutableArray array];
            
            if (phoneNumbers.count == 0) {
                model.phoneNumbers = nil;
            }
            
            for (int i = 0; i < phoneNumbers.count; i ++)
            {
                CNLabeledValue *labelValue = phoneNumbers[i];
                CNPhoneNumber *phoneNumber = labelValue.value;
                NSString *phoneNumberStr = phoneNumber.stringValue;
                phoneNumberStr = [phoneNumberStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                phoneNumberStr = [phoneNumberStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [arrM addObject:phoneNumberStr];
            }
            model.phoneNumbers = [arrM copy];
            
            [self.datasource addObject:model];
        }];
    }
    else
    {
        
    }
    
    [self.collectionview reloadData];
}









#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    
    self.title = @"手机通讯录";
    
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
}












#pragma mark - private

/**默认拨打第一个**/
-(void)action_call:(AddRGContactModel *)model{
    
    
    if (model.phoneNumbers.count == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"对方号码为空"];
    }
    else
    {
        NSString *num = [model.phoneNumbers.firstObject stringByReplacingOccurrencesOfString:@"\xc2\xa0" withString:@""];
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",num];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
//        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",num];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}










#pragma mark - 代理：collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddRGContactCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"AddRGContactCell" forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.model = self.datasource[indexPath.item];
    [cell setAAddRGContactCellBlock:^(AddRGContactModel *model) {
        [self action_call:model];
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView  *reuseableView = nil;
//    //    __weak typeof(self) weakself = self;
//    if (kind == CHTCollectionElementKindSectionHeader)
//    {
//        AddRosterGroupHeader *aAddRosterGroupHeader =
//        [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                           withReuseIdentifier:@"AddRosterGroupHeader"
//                                                  forIndexPath:indexPath];
//        reuseableView = aAddRosterGroupHeader;
//
//        [aAddRosterGroupHeader setAAddRosterGroupHeaderBlock:^{
//
//            [self setEditing:NO animated:YES];
//            [self toAddRosterController];
//        }];
//    }
//    return reuseableView;
//}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
//    return 100;
//}














#pragma mark - Init

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
        
//        _chLayout.headerHeight = 150;
        //_chLayout.footerHeight = 100; 206  154 + 20
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.chLayout];
        _collectionview.backgroundColor =  kBackgroundColor;
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[AddRGContactCell class]
            forCellWithReuseIdentifier:@"AddRGContactCell"];
    }
    return _collectionview;
}

@end
