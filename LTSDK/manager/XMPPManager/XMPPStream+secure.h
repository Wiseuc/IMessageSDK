//
//  XMPPStream+secure.h
//  WiseUC
//
//  Created by JH on 2017/7/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "XMPPManager.h"
void runCategoryForFramework35();
@interface XMPPStream (secure)

- (void)setIsSecure:(BOOL)flag;

@end
