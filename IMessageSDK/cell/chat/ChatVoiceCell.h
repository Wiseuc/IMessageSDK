//
//  ChatVoiceCell.h
//  IMessageSDK
//
//  Created by JH on 2018/1/8.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
typedef void(^ChatVoiceCellTapBlock)(Message *model);


@interface ChatVoiceCell : UICollectionViewCell

@property (nonatomic, strong) Message *model;

//tapG点击手势
-(void)settingChatVoiceCellTapBlock:(ChatVoiceCellTapBlock)aBlock;

//longG长按手势

@end
