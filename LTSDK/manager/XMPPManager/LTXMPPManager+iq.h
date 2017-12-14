//
//  LTXMPPManager+iq.h
//  LTSDK
//
//  Created by JH on 2017/12/14.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager.h"
void runCategoryForFramework34();


@interface LTXMPPManager (iq)

//  发送授权 iq
- (void)sendAuthIqWithUserName:(NSString *)name
                      password:(NSString *)password
                      serverIP:(NSString *)serverIP
                    enableLDAP:(BOOL)enableLDAP;


/**登录错误**/
- (void)xmppIqLoginCheck:(XMPPIQ *)iq;


@end
