//
//  ChatController.h
//  IMessageSDK
//
//  Created by JH on 2017/12/14.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatController : UIViewController

/**初始**/
//-(instancetype)initWithCurrentOtherJID:(NSString *)aCurrentOtherJID;
-(instancetype)initWithCurrentOtherJID:(NSString *)aCurrentOtherJID  conversationName:(NSString *)aConversationName;


@end
