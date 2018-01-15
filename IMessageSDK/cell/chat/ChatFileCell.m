//
//  ChatFileCell.m
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "ChatFileCell.h"
#import "UIConfig.h"
#import "JHLabel.h"




@interface ChatFileCell ()

@property (nonatomic, strong) UIImageView *iconIMGV;  /**头像**/
@property (nonatomic, strong) JHLabel *messageLAB;  /**消息**/

@property (nonatomic, strong) UILabel *filenameLAB;  /**文件名**/
@property (nonatomic, strong) UIImageView *fileIMGV;  /**文件图片**/
@property (nonatomic, strong) UILabel *filenameSizeLAB;  /**文件名**/


@property (nonatomic, strong) UIView      *line;  /**汇讯icon图片**/
@property (nonatomic, strong) UIImageView *companyIMGV;  /**汇讯icon图片**/
@property (nonatomic, strong) UILabel     *resourceLAB;  /**登录客户端名：汇讯Iphone版**/

//@property (nonatomic, strong) UILabel *timeLAB;  /**时间**/
@end








@implementation ChatFileCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = kBackgroundColor;
        //        self.timeLAB = [[UILabel alloc] init];
        //        [self.contentView addSubview:self.timeLAB];
        //        self.timeLAB.text = @"2017-33-30 12:23:25";
        //        self.timeLAB.textAlignment = NSTextAlignmentCenter;
        //        self.timeLAB.font = [UIFont systemFontOfSize:10.0];
        //        self.timeLAB.textColor = [UIColor whiteColor];
        //        self.timeLAB.backgroundColor = [UIColor lightGrayColor];
        //        self.timeLAB.layer.cornerRadius = 4.0;
        //        self.timeLAB.layer.masksToBounds = YES;
        //self.timeLAB.textInsets = UIEdgeInsetsMake(0,5,0,5); // 设置左内边距
        
        
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
        self.iconIMGV.layer.cornerRadius = 4;
        self.iconIMGV.layer.masksToBounds = YES;
        
        
        
        self.messageLAB = [[JHLabel alloc] init];
        [self.contentView addSubview:self.messageLAB];
        //self.messageLAB.text = @"语音";
        self.messageLAB.font = [UIFont systemFontOfSize:15.0];
        self.messageLAB.numberOfLines = 0;
        self.messageLAB.backgroundColor = [UIColor whiteColor];
        self.messageLAB.layer.cornerRadius = 4.0;
        self.messageLAB.layer.masksToBounds = YES;
        self.messageLAB.textInsets = UIEdgeInsetsMake(5,5,5,5); // 设置左内边距,撑大控件10
        
        
        
        //文件名
        self.filenameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.filenameLAB];
        self.filenameLAB.numberOfLines = 0;
        self.filenameLAB.text = @"文件名称，文件名称，文件名称，";
        self.filenameLAB.font = [UIFont boldSystemFontOfSize:16.0];
        
        
        
    
        //文件size
        self.filenameSizeLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.filenameSizeLAB];
        self.filenameSizeLAB.text = @"100.00M";
        self.filenameSizeLAB.font = [UIFont systemFontOfSize:10];
        self.filenameSizeLAB.textColor = [UIColor grayColor];
        self.filenameSizeLAB.textAlignment = NSTextAlignmentRight;
        
        
        
        //file icon
        self.fileIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.fileIMGV];
        self.fileIMGV.image = [UIImage imageNamed:@"file_image"];
        self.fileIMGV.layer.cornerRadius = 4;
        self.fileIMGV.layer.masksToBounds = YES;
        
        
        
        
        //分割线line
        self.line = [[UIImageView alloc] init];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        
        
        
        //companyIMGV icon
        self.companyIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.companyIMGV];
        self.companyIMGV.image = [UIImage imageNamed:@"icon_40pt"];
        self.companyIMGV.layer.cornerRadius = 4;
        self.companyIMGV.layer.masksToBounds = YES;
        
        
        
        
        //资源：汇讯iphone版
        self.resourceLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.resourceLAB];
        self.resourceLAB.text = @"汇讯iphone版";
        self.resourceLAB.font = [UIFont systemFontOfSize:9];
        self.resourceLAB.textColor = [UIColor grayColor];
        
        
        
        
        //点击手势
        self.messageLAB.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGClick:)];
        [self.messageLAB addGestureRecognizer:tapG];
        
        //长按手势
        //        UILongPressGestureRecognizer *longPress =
        //        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGClick:)];
        //        longPress.minimumPressDuration = 0.2;
        //        //[longPress requireGestureRecognizerToFail:tap];
        //        [self.messageLAB addGestureRecognizer:longPress];

    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //    self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
    //    self.messageLAB.frame = CGRectMake(60, 20, KWIDTH-120, KHEIGHT-30);
    //    self.timeLAB.frame = CGRectMake((KWIDTH-140)/2, 0, 140, 10);
    
}
-(void)tapGClick:(UITapGestureRecognizer *)gesture {
    if (self.aChatFileCellTapBlock) {
        self.aChatFileCellTapBlock(_model);
    }
}



-(void)setModel:(Message *)model {
    _model = model;
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    
    
    self.filenameLAB.text = model.body;
    //b -> kb
    float size = model.size.floatValue/1024;
    
    NSString *sizeStr = nil;
    if (size < 512)
    {
        sizeStr = [NSString stringWithFormat:@"%0.2fKB",size];
    }else{
        sizeStr = [NSString stringWithFormat:@"%0.2fM",size/1024];
    }
    self.filenameSizeLAB.text = sizeStr;
    self.resourceLAB.text = [NSString stringWithFormat:@"汇讯%@版",model.resource];
    

    
    /**我是否为发送方**/
    if ([model.from containsString:model.currentMyJID])
    {
        self.iconIMGV.frame = CGRectMake(KWIDTH-10-40, 20, 40, 40);
        self.messageLAB.frame = CGRectMake(KWIDTH-60-200, 20, 200, 100);
        
        
        self.fileIMGV.frame = CGRectMake(KWIDTH-60-10-50, 20+10, 50, 50);
        self.filenameLAB.frame = CGRectMake(KWIDTH-60-200+10, 20+10, 200-70, 20);
        
        
        
        self.line.frame = CGRectMake(KWIDTH-60-200, KHEIGHT-32, 200, 1);
        self.companyIMGV.frame = CGRectMake(KWIDTH-60-200+5, KHEIGHT-30, 20, 20);
        self.resourceLAB.frame = CGRectMake(KWIDTH-60-200+5+20+5, KHEIGHT-30, 100, 20);
        self.filenameSizeLAB.frame = CGRectMake(KWIDTH-60-100, KHEIGHT-30, 90, 20);
        [self.filenameLAB sizeToFit];
        
    }
    else
    {
        self.iconIMGV.frame = CGRectMake(10, 20, 40, 40);
        self.messageLAB.frame = CGRectMake(60, 20, 200, 100);
        
        
        self.filenameLAB.frame = CGRectMake(60+5, 20+10, 130, 20);
        self.fileIMGV.frame = CGRectMake(60+200-10-50, 20+10, 50, 50);
        
        
        
        self.line.frame = CGRectMake(60, KHEIGHT-32, 200, 1);
        self.companyIMGV.frame = CGRectMake(60+5, KHEIGHT-30, 20, 20);
        self.resourceLAB.frame = CGRectMake(60+5+20+5, KHEIGHT-30, 100, 20);
        self.filenameSizeLAB.frame = CGRectMake(60+200-100, KHEIGHT-30, 90, 20);
        [self.filenameLAB sizeToFit];
    }
    
    
    
    
    
    
}

@end
