//
//  LXChatBoxMoreView.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXChatBoxMoreViewItem.h"
typedef NS_ENUM(NSInteger, LXChatBoxItem){
    LXChatBoxItemPicture = 0,   // picture
    LXChatBoxItemCamera,        // camera
    
    LXChatBoxItemVibrate,       // vibrate
    LXChatBoxItemFile,          // file
    
    LXChatBoxItemLocation,      // location

    
//    LXChatBoxItemVideo,       // video
};

@class LXChatBoxMoreView;

@protocol LXChatBoxMoreViewDelegate <NSObject>
/**
 *  点击更多的类型
 *
 *  @param chatBoxMoreView ICChatBoxMoreView
 *  @param itemType        类型
 */
- (void)chatBoxMoreView:(LXChatBoxMoreView *)chatBoxMoreView didSelectItem:(LXChatBoxItem)itemType;

@end
@interface LXChatBoxMoreView : UIView
@property (nonatomic, weak) id<LXChatBoxMoreViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *items;
@end
