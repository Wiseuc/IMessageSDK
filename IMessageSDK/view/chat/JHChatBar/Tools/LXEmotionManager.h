//
//  LXEmotionManager.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LXEmotion;
@interface LXEmotionManager : NSObject

+(NSArray *)emojiEmotion;
+(NSArray *)customEmotion;
+(NSArray *)gifEmotion;
+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight;
@end
