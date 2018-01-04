//
//  LXChatServerDefs.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

#ifndef LXChatServerDefs_h
#define LXChatServerDefs_h

#define HEIGHT_TABBAR       49      // 就是chatBox的高度
#define     CHATBOX_BUTTON_WIDTH        37

#define  HEIGHT_TEXTVIEW   36

#define  BOXBTNSPACE 4
#define  BOXOTHERH 215
#define  BOXTOTALH   (HEIGHT_TABBAR+BOXOTHERH)
#define  BOXBTNBOTTOMSPACE    6
#define  BOXTEXTViewSPACE 6.5





/************Notification*************/

#import "LXChatBoxConst.h"



#define LBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LBRandomColor LBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define KScreenW [[UIScreen mainScreen]bounds].size.width
#define KScreenH [[UIScreen mainScreen]bounds].size.height
#define Font(x) [UIFont systemFontOfSize:(x)]
#import "MJExtension.h"
#import "NSString+JHExtension.h"
#import "UIImage+JHExtension.h"
#import "UIView+JHFrame.h"

#endif /* LXChatServerDefs_h */
