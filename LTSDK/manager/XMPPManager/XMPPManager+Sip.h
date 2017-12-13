//
//  XMPPManager+Sip.h
//  WiseUC
//
//  Created by JH on 2017/5/23.
//  Copyright © 2017年 WiseUC. All rights reserved.
//
/*
 send:
 <iq id="jcl_54" to="168测试1@115871" type="get">
       <vCard xmlns="vcard-temp">
            <pid/>
       </vCard>
 </iq>
 
 
 rec:
 <iq id='jcl_54' to='admin@115871/WinduoIM' type='result' from='168测试1@115871'>
         <pid>xxxxx</pid>
         <vCard/>
 </iq>
 */
#import "XMPPManager.h"

@interface XMPPManager (Sip)

//请求获取pid
+ (void)requestPidWithChatterJid:(NSString *)chatterJid;
@end
