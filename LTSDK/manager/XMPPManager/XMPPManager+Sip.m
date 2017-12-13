//
//  XMPPManager+Sip.m
//  WiseUC
//
//  Created by JH on 2017/5/23.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "XMPPManager+Sip.h"

@implementation XMPPManager (Sip)



/*
 send:
 <iq type="get" id="jcl_54" to="江海@duowin-server">
        <vCard xmlns="vcard-temp">
              <pid></pid>
        </vCard>
 </iq>
 
 
 rec:
 <iq id='jcl_54' to='admin@115871/WinduoIM' type='result' from='168测试1@115871'>
 <pid>xxxxx</pid>
 <vCard/>
 </iq>
 */
+ (void)requestPidWithChatterJid:(NSString *)chatterJid
{
    XMPPIQ *iqEle = [XMPPIQ iqWithType:kStringXMPPIQTypeGet elementID:kStringXMPPElementIDRequestPid];
    [iqEle addAttributeWithName:kStringXMPPTo stringValue:chatterJid];
        NSXMLElement *queryEle = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
             NSXMLElement *pidEle = [NSXMLElement elementWithName:@"pid"];
    [queryEle addChild:pidEle];
    [iqEle addChild:queryEle];
    
    NSLog(@"发送PID请求 : %@",iqEle);
    
    //XMPPStream
    [XMPPManager.shareXMPPManager.xmppStream sendElement:iqEle];
}



@end
