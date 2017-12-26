//
//  ChatListCell.m
//  IMessageSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "ChatListCell.h"
@interface ChatListCell ()

@property (nonatomic, strong) UIImageView *iconIMGV;
@property (nonatomic, strong) UILabel *nameLAB;
@property (nonatomic, strong) UILabel *messageLAB;
@property (nonatomic, strong) UILabel *timeLAB;
@end





@implementation ChatListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconIMGV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconIMGV];
        self.iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
        self.iconIMGV.layer.cornerRadius = 4;
        self.iconIMGV.layer.masksToBounds = YES;
        
        
        self.nameLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.nameLAB];
        self.nameLAB.text = @"淮安瓶套史蒂夫好似 u 啊好的大赛季第三个";
        self.messageLAB.font = [UIFont systemFontOfSize:18.0];
//        self.messageLAB.textColor = [UIColor grayColor];
        
        
        self.messageLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.messageLAB];
        self.messageLAB.text = @"打算低价啊是个好睇噶的嘎嘎大";
        self.messageLAB.font = [UIFont systemFontOfSize:14.0];
        self.messageLAB.textColor = [UIColor lightGrayColor];
        
        
        self.timeLAB = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLAB];
        self.timeLAB.text = @"下午30:30";
        self.timeLAB.textAlignment = NSTextAlignmentRight;
        self.timeLAB.font = [UIFont systemFontOfSize:12.0];
        self.timeLAB.textColor = [UIColor grayColor];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat KWIDTH  = self.frame.size.width;
    CGFloat KHEIGHT = self.frame.size.height;
    
    
    self.iconIMGV.frame = CGRectMake(10, 8, (KHEIGHT-16), (KHEIGHT-16));
    
    self.nameLAB.frame = CGRectMake(10+(KHEIGHT-16)+10, 8, 150, 20);
    
    self.messageLAB.frame = CGRectMake(10+(KHEIGHT-16)+10, 28+2, 300, 20);
    
    self.timeLAB.frame = CGRectMake((KWIDTH-140), 8, 130, 20);
    
}



-(void)setModel:(Message *)model {
    _model = model;
    
    self.nameLAB.text = model.conversationName;
    self.messageLAB.text = model.body;
    self.timeLAB.text = model.stamp;
    
    if ([model.currentOtherJID containsString:@"conference"]) {
        self.iconIMGV.image = [UIImage imageNamed:@"group"];
    }else {
        self.iconIMGV.image = [UIImage imageNamed:@"icon_40pt"];
    }
}

@end
