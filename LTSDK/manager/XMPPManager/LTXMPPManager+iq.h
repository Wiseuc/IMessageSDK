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

/**发送请求服务器时间iq**/
- (void)sendRequestServerTimeIq;

/**发送请求头像**/
- (void)sendRequestHeaderIconURLWithJID:(NSString *)jid;


/**登录错误**/
- (void)xmppIqLoginCheck:(XMPPIQ *)iq;
/**通过JID获取资料**/
- (void)queryInformationByJid:(NSString *)aJID completed:(LTXMPPManager_iq_queryInformationByJidBlock)aBlock;


@end
