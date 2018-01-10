//
//  FileController.m
//  IMessageSDK
//
//  Created by JH on 2018/1/10.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "FileController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "UIConfig.h"
#import "FileCell.h"
#import "LTSDKFull.h"
#import "CommonHelper.h"
#import "Message.h"
@interface FileController ()
<
CHTCollectionViewDelegateWaterfallLayout,
UICollectionViewDataSource,
UICollectionViewDelegate
>
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *chLayout;
@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) FileControllerSelectBlock aFileControllerSelectBlock;
@end










@implementation FileController

#pragma mark - UI

-(void)settingUI {
    [self.view addSubview:self.collectionview];
}

-(void)settingData {
    
    [self getFilePreviewDatas];
     [self.collectionview reloadData];
}


#pragma mark
#pragma mark ===数据

/*!
 @method
 @abstract 查找沙盒中的文件
 @discussion <#备注#>
 */
- (void)getFilePreviewDatas
{
    NSString *filePath = kFilePath;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:filePath];
    NSString *localPath = nil;
    //清空
    self.datasource = nil;
    
    //迭代direnum：localPath == 23542353454325.log
    while ( localPath = (NSString *)[direnum nextObject])
    {
        NSString *fileDirPath = [kFilePath stringByAppendingPathComponent:localPath];
        LTFileType fileType = [CommonHelper fileType:fileDirPath];
        
        if ( fileType == LTFileType_NoFound ) {
            continue;
        }
        Message *message = [[Message alloc] init];
        message.body = [fileDirPath lastPathComponent];
        message.localPath = fileDirPath;
        NSDate *fileCreateDate = nil;
        CGFloat fileSize = [self getFileSize:fileDirPath fileModifiedDate:&fileCreateDate fileType:nil];
        message.size = [NSString stringWithFormat:@"%.02f",fileSize];
        [self.datasource addObject:message];
        
//        switch ( fileType ) {
//            case LTFileType_Audio:
//                break;
//
//            case LTFileType_Text:
//                break;
//
//            case LTFileType_Default:
//                break;
//
//            case LTFileType_Picture:
//                break;
//
//            default:
//                break;
//        }
    }/**end while**/
}
/**获取文件size**/
- (CGFloat)getFileSize:(NSString *)filePath
      fileModifiedDate:(NSDate **)modifiedDate
              fileType:(NSString **)fileType {
    
    NSFileManager *manger = [NSFileManager defaultManager];
    if ( [manger fileExistsAtPath:filePath] ) {
        NSDictionary *fileDict =
        [manger attributesOfItemAtPath:filePath error:nil];
        *modifiedDate = [fileDict fileModificationDate];
        return [[manger attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}















#pragma mark - start

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];//kBackgroundColor;
    
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
- (void)dealloc
{
    NSLog(@"文件页面dealloc");
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
    return CGSizeMake(kScreenWidth-40, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FileCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"FileCell" forIndexPath:indexPath];
    Message *model = [self.datasource objectAtIndex:indexPath.item];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Message *mdoel =self.datasource[indexPath.item];
    if (self.aFileControllerSelectBlock) {
        self.aFileControllerSelectBlock(mdoel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}











#pragma mark - Init

-(void)settingFileControllerSelect:(FileControllerSelectBlock)aBlock{
    self.aFileControllerSelectBlock = aBlock;
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
        _chLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _chLayout.minimumColumnSpacing = 0;
        _chLayout.minimumInteritemSpacing = 5;
    }
    return _chLayout;
}
-(UICollectionView *)collectionview {
    if (!_collectionview) {
        _collectionview =
        [[UICollectionView alloc]
         initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)
         collectionViewLayout:self.chLayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        
        [_collectionview registerClass:[FileCell class] forCellWithReuseIdentifier:@"FileCell"];
        _collectionview.backgroundColor = kBackgroundColor;
        
        
        
//        [self.collectionview registerClass:[UICollectionReusableView class]
//                forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
//                       withReuseIdentifier:@"footer"];
    }
    return _collectionview;
}


@end
