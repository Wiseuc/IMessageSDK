//
//  LTXMPPManager+iq.m
//  LTSDK
//
//  Created by JH on 2017/12/14.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTXMPPManager+iq.h"

void runCategoryForFramework34(){}
@implementation LTXMPPManager (iq)


/**
 用户名不存在：
 <iq xmlns="jabber:client" type="error">
 <query xmlns="jabber:iq:access:auth">
 <Message>
     <Code_Type>1</Code_Type>
     <Session_ID>E3A27DCBB81D4F9E9177C914C7FFCC94</Session_ID>
     <Return_Code>403</Return_Code>
     <Error_Info>用户名不存在</Error_Info>
 </Message>
 </query>
 </iq>

 密码错误：
 <iq xmlns="jabber:client" type="error">
 <query xmlns="jabber:iq:access:auth">
 <Message>
     <Code_Type>1</Code_Type>
     <Session_ID>D8FAB4FBD22E4084B54E1C070643D5C8</Session_ID>
     <Return_Code>404</Return_Code>
     <Error_Info>密码错误</Error_Info>
 </Message>
 </query>
 </iq>
 
 **/
- (void)xmppIqLoginCheck:(XMPPIQ *)iq {
    
    NSArray *queryArr = [iq elementsForName:kStringXMPPIQQuery];
    if ( queryArr.count > 0 ) {
        NSXMLElement * query = queryArr[0];
        if ( [[query xmlns] isEqualToString:kStringXMPPIQAccessAuth] ) {
            
            /**登录错误**/
             NSArray *errorArr = [iq elementsForName:kStringXMPPIQTypeError];
             if ( errorArr.count > 0 ) {
                 NSXMLElement * errorElement = errorArr[0];
                 //NSString *errorInfo = [errorElement stringValue];
                 LTError *error =
                 [LTError errorWithDescription:@"errorInfo"
                                          code:(LTErrorLogin_loginGeneralFailure)];
                 self.aXMPPManagerLoginBlock(error);
             }
             
            
            /**用户名不存在**/
            NSArray *messageArr = [query elementsForName:@"Message"];
            if ( messageArr.count > 0 ) {
                NSXMLElement * message = messageArr[0];
                NSArray *Return_Codes = [message elementsForName:@"Return_Code"];
                if ( Return_Codes.count > 0 ) {
                    NSXMLElement *Return_Code = Return_Codes[0];
                    NSString *errorInfo = [Return_Code stringValue];
                    
                    if ([errorInfo isEqualToString:@"403"])
                    {
                        LTError *error =
                        [LTError errorWithDescription:@"用户名不存在"
                                                 code:(LTErrorLogin_InvalidUsername)];
                        self.aXMPPManagerLoginBlock(error);
                    }
                    else if ([errorInfo isEqualToString:@"404"])
                    {
                        LTError *error =
                        [LTError errorWithDescription:@"密码错误"
                                                 code:(LTErrorLogin_InvalidPassword)];
                        self.aXMPPManagerLoginBlock(error);
                    }
                }
            }
        }
    }
}








#pragma mark - 代理：iq

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    /**用户名或密码输入有误**/
    BOOL isIqError = [[[iq attributeForName:kStringXMPPIQType] stringValue] isEqualToString:kStringXMPPIQTypeError];
    if ( isIqError ) {
        [self xmppIqLoginCheck:iq];
    }
    
    
    /**获取服务器时间**/
    NSXMLElement *query = [iq elementForName:@"query" xmlns:@"jabber:iq:time"];
    if ( query ) {
        NSString *utc_Str = [[query elementForName:@"utc"] stringValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMdd'T'HH:mm:ss";
        NSDate *serverDate = [dateFormatter dateFromString:utc_Str];
        NSDate *localTime = [NSDate date];
        long long timeOffset = (long long)[localTime timeIntervalSinceDate:serverDate];
        self.timeOffset_localAndServer = timeOffset;
    }
    
    
    
    /**创建群组**/
    //    if ([iq isResultIQ]) {
    //        NSArray *query = [iq elementsForName:@"query"];
    //        if ([iq attributeForName:@"from"].stringValue && query.count == 0) {
    //            if (self.msgReceiverdelegate && [self.msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveSuccessCreateGroup:from:)]) {
    //                [self.msgReceiverdelegate XMPPServer:self didReceiveSuccessCreateGroup:YES from:[iq attributeForName:@"from"].stringValue];
    //                return YES;
    //            }
    //        }
    //    }
    
    
    
    
    /**登录Auth**/
    if ( [iq isResultIQ] ) {
        NSXMLElement *query = [iq elementForName:@"query"];
        NSXMLElement *Message = [query elementForName:@"Message"];
        if (Message != nil) { //防止接收iq消息时result类型时再次登录
            
            NSString *PID            = [[Message elementForName:@"PID"] stringValue];
            NSString *AccountID      = [[Message elementForName:@"AccountID"] stringValue];
            NSString *JID            = [[Message elementForName:@"JID"] stringValue];
            NSString *UserName       = [[Message elementForName:@"UserName"] stringValue];
            
            NSString *IsAdmin        = [[Message elementForName:@"IsAdmin"] stringValue];
            NSString *IMPwd          = [[Message elementForName:@"IMPwd"] stringValue];
            NSString *AccountName    = [[Message elementForName:@"AccountName"] stringValue];
            NSString *Domain         = [[Message elementForName:@"Domain"] stringValue];
            
            NSString *AssistantURL   = [[Message elementForName:@"AssistantURL"] stringValue];
            NSString *Host           = [[Message elementForName:@"Host"] stringValue];
            NSString *FirstChanel    = [[Message elementForName:@"FirstChanel"] stringValue];
            NSString *VisableChanels = [[Message elementForName:@"VisableChanels"] stringValue];
            
            NSString *Email          = [[Message elementForName:@"Email"] stringValue];
            NSString *Code_Type      = [[Message elementForName:@"Code_Type"] stringValue];
            NSString *Session_ID     = [[Message elementForName:@"Session_ID"] stringValue];
            NSString *PushOrgState   = [[Message elementForName:@"PushOrgState"] stringValue];
            
            NSString *ServerVer      = [[Message elementForName:@"ServerVer"] stringValue];
            NSString *HasAdvert      = [[Message elementForName:@"HasAdvert"] stringValue];
            NSString *resource       = @"IphoneIM";
            
            /**使用服务器返回的真实信息登录服务器**/
            [self loginAgainWithJID:JID
                           password:IMPwd
                           resource:resource];
            
            /**将返回的真实信息保存到本地**/
            [LTUser.share updateUserWithPID:PID
                                  AccountID:AccountID
                                   UserName:UserName
                                    IsAdmin:IsAdmin
                                        JID:JID
             
                                      IMPwd:IMPwd
                                AccountName:AccountName
                                     Domain:Domain
                               AssistantURL:AssistantURL
                                       Host:Host
             
                                FirstChanel:FirstChanel
                             VisableChanels:VisableChanels
                                      Email:Email
                                  Code_Type:Code_Type
                                 Session_ID:Session_ID
             
                               PushOrgState:PushOrgState
                                  ServerVer:ServerVer
                                  HasAdvert:HasAdvert];
            
            return YES;
        }
    }
    
    
    /**获取Digest，内部实现发送过去Digest iq请求**/
    if ( [iq isResultIQ] ) {
        NSXMLElement *query = [iq elementForName:@"query" xmlns:@"jabber:iq:auth"];
        if (query) {
            NSDictionary  *userDict = [LTUser.share queryUser];
            NSString *UserName = userDict[@"UserName"];
            //NSString *JID = userDict[@"JID"];
            NSString *IMPwd = userDict[@"IMPwd"];
            [self.aXMPPStream setLoginname:UserName];
            [self.aXMPPStream setPassword:IMPwd];
            /**验证密码**/
            [self loginAuthWithPassword:IMPwd];
        }
    }

    
    
    
    //获取头像
    if ( [iq isResultIQ] ) {
        NSString *elementId = [iq elementID];
        if ([elementId isEqualToString:kStringXMPPElementIDGetPhotoHash]) {
            /**
             http://im.lituosoft.cn:14131/headpicture/eba28ceaa7326eacfcaaf3882ceba6e1f5653ded.jpg
             <vCard xmlns="vcard-temp" ver="0"><PHOTO><type>image/png</type><PHOTOHASH>11</PHOTOHASH></PHOTO></vCard>
             <vCard xmlns="vcard-temp" ver="0"><PHOTO><type>image/jpeg</type><PHOTOHASH>eba28ceaa7326eacfcaaf3882ceba6e1f5653ded</PHOTOHASH></PHOTO></vCard>
             **/
            NSXMLElement *vCard = [iq elementForName:@"vCard"];
            //NSXMLElement *PHOTO = [vCard elementForName:@"PHOTO"];
            //NSString *from = [[[iq attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"][0];
            if (vCard)
            {
                //[XMPPManager parseIQ_PhotoHash:vCard withJID:from];
                return YES;
            }else{
                //[XMPPManager saveDefaultHeadImageByJID:from];
                return YES;
            }
        }
    }
    
    
    if ([iq isResultIQ])
    {
        NSError *error = nil;
        NSString *elementId = [iq elementID];
        NSDictionary *result = [XMLReader dictionaryForXMLString:[iq XMLString] error:&error];
        NSDictionary *info = [NSObject objectForKey:@"iq"  inDictionary:result  espectedType:[NSDictionary class]];
        
        /**获取好友列表**/
        /**
         RECV:
         <iq xmlns="jabber:client" type="result" id="rosters" from="江海@duowin-server/IphoneIM">
         <query xmlns="jabber:iq:roster" ver="162">
         <item jid="刘明@duowin-server" name="刘明" subscription="both" vcardver="38"><group>我的同事</group></item>
         <item jid="刘杰@duowin-server" name="刘杰" subscription="both" vcardver="6"><group>我的同事</group></item>
         <item jid="饶芳玮@duowin-server" name="饶芳玮" subscription="both" vcardver="9"><group>我的同事</group></item>
         <item jid="李晴@duowin-server" name="李晴" subscription="from" ask="subscribe" vcardver="70"><group>我的同事</group></item>
         <item jid="张代伍@duowin-server" name="张代伍" subscription="both" vcardver="3"><group>我的同事</group></item>
         </query>
         </iq>
         
         **/
        if ([elementId isEqualToString:@"rosters"])
        {
            NSDictionary *query = [NSObject objectForKey:kStringXMPPIQQuery inDictionary:info espectedType:[NSDictionary class]];
            id _items = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:query];
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:10];
            if([_items isKindOfClass:[NSDictionary class]])
            {
                [items addObject:[self copiedSomeone:_items]];
            } else if([_items isKindOfClass:[NSArray class]]) {
                for(NSDictionary *_item in _items)
                {
                    [items addObject:[self copiedSomeone:_item]];
                }
            }
            NSString *version = [NSObject objectForKey:kStringXMPPVersion inDictionary:query];
            self.friend_queryRostersBlock(items, version);
        }
        
        
        /**
         获取群组列表
         
         <iq xmlns="jabber:client" type="result" to="江海@duowin-server/IphoneIM" id="groups" var="self" from="conference.duowin-server/IphoneIM">
         <item xmlns="jabber:iq:browse" category="conference" type="public" jid="conference" name="Public Chatrooms" totalnum="15">
         
         <item category="conference" jid="c1c97d0ba53a4328a49da40399d03f18@conference.duowin-server" name="技术中心" password="0" introduction="" subject="企业版交流区" owner="test@duowin-server" type="public" conferencetype="1"><admin>刘明@duowin-server</admin></item>
         </item>
         </iq>
         **/
        if ([elementId isEqualToString:@"groups"])
        {
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:10];
            id _itms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:info];
            if([_itms isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:5];
                NSString *name = [NSObject objectForKey:kStringXMPPRosterName inDictionary:_itms];
                NSString *xmlns = [NSObject objectForKey:kStringXMPPRosterXmlns inDictionary:_itms];
                NSString *jid = [NSObject objectForKey:kStringXMPPRosterJabberId inDictionary:_itms];
                NSString *category = [NSObject objectForKey:kStringXMPPRosterCategory inDictionary:_itms];
                [item setObject:name forKey:kStringXMPPRosterNameFull];
                [item setObject:name forKey:kStringXMPPRosterName];
                [item setObject:xmlns forKey:kStringXMPPRosterXmlns];
                [item setObject:jid forKey:kStringXMPPRosterJabberId];
                [item setObject:category forKey:kStringXMPPRosterCategory];
                
                NSMutableArray *subItems = [[NSMutableArray alloc] initWithCapacity:5];
                id _subitms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:_itms];
                if([_subitms isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *subItem = [self copiedMutableDictionaryFrom:_subitms];
                    [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:subItem] forKey:kStringXMPPRosterNameFull];
                    [subItems addObject:subItem];
                }
                else if([_subitms isKindOfClass:[NSArray class]])
                {
                    for(NSDictionary *_subitm in _subitms) {
                        NSMutableDictionary *subItem = [self copiedMutableDictionaryFrom:_subitm];
                        [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:subItem] forKey:kStringXMPPRosterNameFull];
                        [subItems addObject:subItem];
                    }
                }
                [item setObject:subItems forKey:kStringXMPPRosterItem];
                [items addObject:item];
            }
            else if([_itms isKindOfClass:[NSArray class]])
            {
                NSMutableArray *subItems = [[NSMutableArray alloc] initWithCapacity:5];
                id _subitms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:_itms];
                if([_subitms isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *subItem = [[NSMutableDictionary alloc] initWithDictionary:_subitms];
                    [subItems addObject:subItem];
                }else if([_subitms isKindOfClass:[NSArray class]]){
                    [subItems addObjectsFromArray:_subitms];
                }
                [items addObjectsFromArray:subItems];
            }
            self.friend_queryGroupsBlock(items, nil);
        }
    }
    
    
    
    
    /**
     SEND: <iq type="get" to="江海@duowin-server" id="rstrone"><vCard xmlns="vcard-temp" ver="0"/></iq>
     
     RECV:
     <iq xmlns="jabber:client" type="result" to="江海@duowin-server/IphoneIM" id="rstrone" from="江海@duowin-server/IphoneIM">
     <vCard xmlns="vcard-temp" ver="132">
     
     <LOGINNAME>江海</LOGINNAME>
     <FN>江海</FN>
     <URL> </URL>
     <BDAY>1993-07-02</BDAY>
     <TITLE>iOS 开发工程师</TITLE>
     <GENDER>男</GENDER>
     <WORKURL>http://www.wiseuc.com</WORKURL>
     <ORG>
         <ORGNAME>汇讯试用版(非正式授权)</ORGNAME>
         <ORGREFNAME>汇讯试用版</ORGREFNAME>
         <ORGUNIT>研发部</ORGUNIT>
         <DESC> </DESC>
     </ORG>
     <MOBILEEXT>0</MOBILEEXT>
     <ADR>
         <HOME/>
         <STREET></STREET>
         <EXTADR> </EXTADR>
         <LOCALITY> </LOCALITY>
         <REGION> </REGION>
         <COUNTRY> </COUNTRY>
     </ADR>
     <ADR>
         <WORK/>
         <STREET>南山区科技园北区清华信息港综合楼706</STREET>
         <LOCALITY>深圳市</LOCALITY>
         <REGION>广东省</REGION>
         <PCODE>jianghai@wiseuc.com</PCODE>
     </ADR>
     <TEL>
         <WORK/>
         <CELL/>
         <NUMBER>18823780407</NUMBER>
     </TEL>
     <PHOTOHASH>eba28ceaa7326eacfcaaf3882ceba6e1f5653ded</PHOTOHASH>
     
     </vCard>
     </iq>
     **/
    /**获取Vcard资料**/
    if ([iq isResultIQ])
    {
        NSError *error = nil;
        NSString *elementId = [iq elementID];
        /**将xml转字典**/
        NSDictionary *result = [XMLReader dictionaryForXMLString:[iq XMLString] error:&error];
        /**字典取值 espectedType：预期类型**/
        NSDictionary *info = [NSObject objectForKey:@"iq"  inDictionary:result  espectedType:[NSDictionary class]];
        
        //rstrone
        if ([elementId rangeOfString:kStringXMPPElementIDRoster4One options:NSCaseInsensitiveSearch].length>0)
        {
            if([[info allKeys] containsObject:kStringXMPPIQVCard])
            {
                NSDictionary *card = [NSObject objectForKey:kStringXMPPIQVCard inDictionary:info espectedType:[NSDictionary class]];
                
                //如果不含有新版本的信息，那么vCard里只有两个元素xmlns和ver
                if(![NSObject isEmpty:card] && [card allKeys].count>2)        //vCard为空表示已经是最新版本，不需要更新
                {
                    NSMutableDictionary *someone = [[NSMutableDictionary alloc] initWithCapacity:10];
                    
                    //版本号
                    [someone setObject:[NSObject objectForKey:kStringXMPPVersion inDictionary:card] forKey:kStringXMPPRosterVCardVersion];
                    
                    NSMutableString *from = [[NSMutableString alloc] initWithString:[self valueForKey:kStringXMPPFrom inDictionary:info]];
                    [from remainBeforeString:@"/"];
                    [someone setObject:from forKey:kStringXMPPRosterJabberId];
                    
                    //性别
                    NSString *sex = [self valueForKey:kStringXMPPRosterSex inDictionary:card];
                    [someone setObject:sex forKey:kStringXMPPRosterSex];
                    
                    NSString *portrait = [self valueForKey:kStringXMPPRosterPortrait inDictionary:card];
                    if([sex rangeOfString:@"男" options:NSCaseInsensitiveSearch].length>0)
                    {
                        portrait = [NSString stringWithFormat:@"male%@", portrait];
                    }
                    else if([sex rangeOfString:@"女" options:NSCaseInsensitiveSearch].length>0)
                    {
                        portrait = [NSString stringWithFormat:@"female%@", portrait];;
                    }
                    
                    //                            如果本地有，那么不管
                    //                            if(![[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:portrait ofType:@"png"]])
                    //                            {
                    //                                if(![NSObject isEmpty:portrait])
                    //                                {
                    //                                    portrait = [[NSMutableString alloc] initWithFormat:@"http://%@:%@/headpicture/%@.jpg",[XMPPManager shareXMPPManager].xmppStream.hostName,@"14131",[self valueForKey:kStringXMPPRosterPortrait inDictionary:card]
                    //                                                ];
                    //                                };
                    //                            }
                    //                            [someone setObject:portrait forKey:kStringXMPPRosterPortrait];
                    //登录名
                    [someone setObject:[self valueForKey:kStringXMPPRosterNameLogin inDictionary:card] forKey:kStringXMPPRosterNameLogin];
                    //全名
                    NSString *fullName = [self valueForKey:kStringXMPPRosterNameFull inDictionary:card];
                    [someone setObject:fullName forKey:kStringXMPPRosterNameFull];
                    [someone setObject:fullName forKey:kStringXMPPRosterName];
                    [someone setObject:[self transferToPinYin:fullName] forKey:kStringXMPPRosterNamePinYin];
                    //                            [someone setObject:[POAPinyin convert:fullName] forKey:kStringXMPPRosterNameQuanPin];
                    //昵称
                    [someone setObject:[self valueForKey:kStringXMPPRosterNameNick inDictionary:card] forKey:kStringXMPPRosterNameNick];
                    //电子邮箱
                    [someone setObject:[self valueForKey:kStringXMPPRosterEmail inDictionary:card] forKey:kStringXMPPRosterEmail];
                    //个人主页
                    [someone setObject:[self valueForKey:kStringXMPPRosterWebpage4Personal inDictionary:card] forKey:kStringXMPPRosterWebpage4Personal];
                    //生日
                    [someone setObject:[self valueForKey:kStringXMPPRosterBirthday inDictionary:card] forKey:kStringXMPPRosterBirthday];
                    //岗位
                    [someone setObject:[self valueForKey:kStringXMPPRosterJobTitle inDictionary:card] forKey:kStringXMPPRosterJobTitle];
                    //岗位描述
                    [someone setObject:[self valueForKey:kStringXMPPRosterJobDescription inDictionary:card] forKey:kStringXMPPRosterJobDescription];
                    //企业网址
                    [someone setObject:[self valueForKey:kStringXMPPRosterWebpage4Organization inDictionary:card] forKey:kStringXMPPRosterWebpage4Organization];
                    //企业
                    {
                        NSDictionary *dOrg = [NSObject objectForKey:kStringXMPPRosterOrganization inDictionary:card espectedType:[NSDictionary class]];
                        [someone setObject:[self copiedMutableDictionaryFrom:dOrg] forKey:kStringXMPPRosterOrganization];
                    }
                    //地址
                    {
                        NSMutableArray *addresses = [[NSMutableArray alloc] initWithCapacity:10];
                        
                        id _addrs = [NSObject objectForKey:kStringXMPPRosterAddresses inDictionary:card];
                        if([_addrs isKindOfClass:[NSDictionary class]])
                        {
                            [addresses addObject:[self copiedMutableDictionaryFrom:_addrs]];
                        }
                        else if([_addrs isKindOfClass:[NSArray class]])
                        {
                            for(NSDictionary *a in _addrs)
                            {
                                [addresses addObject:[self copiedMutableDictionaryFrom:a]];
                            }
                        }
                        //[someone setObject:addresses forKey:kStringXMPPRosterAddresses];
                        for(NSDictionary *a in addresses)
                        {
                            NSArray *keys = [a allKeys];
                            if([keys containsObject:kStringXMPPRosterAddressTypeOrganization])
                            {
                                for(NSString *key in keys)
                                {
                                    [someone setObject:[self valueForKey:key inDictionary:a] forKey:key];
                                }
                            }
                        }
                    }
                    //联系方式
                    {
                        NSMutableArray *telephones = [[NSMutableArray alloc] initWithCapacity:5];
                        id _tlp = [NSObject objectForKey:kStringXMPPRosterTelephones inDictionary:card];
                        if([_tlp isKindOfClass:[NSDictionary class]])
                        {
                            [telephones addObject:[self copiedMutableDictionaryFrom:_tlp]];
                        }
                        else if([_tlp isKindOfClass:[NSArray class]])
                        {
                            for(NSDictionary *t in _tlp)
                            {
                                [telephones addObject:[self copiedMutableDictionaryFrom:t]];
                            }
                        }
                        for(NSDictionary *t in telephones)
                        {
                            NSArray *keys = [t allKeys];
                            
                            if([keys containsObject:kStringXMPPRosterTelephoneTypeWork])
                            {
                                NSString *number = [self valueForKey:kStringXMPPRosterTelephoneNumber inDictionary:t];
                                
                                for(NSString *key in keys)
                                {
                                    if([kStringXMPPRosterMobile isEqualToString:key])
                                    {
                                        [someone setObject:number forKey:kStringXMPPRosterMobile];
                                    }
                                    else if([kStringXMPPRosterTelephone isEqualToString:key])
                                    {
                                        [someone setObject:number forKey:kStringXMPPRosterTelephone];
                                    }
                                    else if([kStringXMPPRosterFax isEqualToString:key])
                                    {
                                        [someone setObject:number forKey:kStringXMPPRosterFax];
                                    }
                                    
                                }
                            }
                        }
                    }
                    //短号
                    [someone setObject:[self valueForKey:kStringXMPPRosterMobileExt inDictionary:card] forKey:kStringXMPPRosterMobileExt];
                    if (self.iq_queryInformationByJidBlock) {
                        self.iq_queryInformationByJidBlock(someone, nil);
                    }
                }
                
            }
        }
        
    }
    return NO;
}





#pragma mark - Public

//  发送授权 iq
- (void)sendAuthIqWithUserName:(NSString *)name
                      password:(NSString *)password
                      serverIP:(NSString *)serverIP
                    enableLDAP:(BOOL)enableLDAP {
    
    NSString *stringClientVer = [AppManager applicationVersion];
    NSString *stringSession_ID = [AppManager get_128Bytes_UUID];
    NSString *stringClient_IP = [AppManager deviceIPAdress];
    NSString *stringSystemVer = [AppManager getIOSVersion];
    NSString const* encodeString = @"testing123";
    
    NSXMLElement *loginname = [NSXMLElement elementWithName:@"loginname" stringValue:name];
    NSXMLElement *username = [NSXMLElement elementWithName:@"username" stringValue:name];
    NSXMLElement *ClientVer = [NSXMLElement elementWithName:@"ClientVer" stringValue:stringClientVer];
    NSXMLElement *SystemVer = [NSXMLElement elementWithName:@"SystemVer" stringValue:stringSystemVer];
    NSXMLElement *Session_ID = [NSXMLElement elementWithName:@"Session_ID" stringValue:stringSession_ID];
    NSXMLElement *Client_IP = [NSXMLElement elementWithName:@"Client_IP" stringValue:stringClient_IP];
    NSXMLElement *server = [NSXMLElement elementWithName:@"server" stringValue:serverIP];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:access:auth"];
    
    
    
    [query addChild:username];
    [query addChild:ClientVer];
    [query addChild:SystemVer];
    [query addChild:Session_ID];
    [query addChild:Client_IP];
    [query addChild:server];
    
    // FIXME:Digest
    {// LDAP
        NSString *stringDigest = nil;
        NSString *sid = nil;
        if ( YES == enableLDAP )
        {
            NSString *loginNameUTF8 = [name UTF8Encode];
            sid = [[self.aXMPPStream.rootElement attributeForName:@"id"] stringValue];
            stringDigest = [[NSString stringWithFormat:@"%@%@%@",loginNameUTF8,sid,encodeString] md5];
            NSXMLElement *ticketmode = [NSXMLElement elementWithName:@"ticketmode" stringValue:@"1"];
            [query addChild:ticketmode];
        }else{
            stringDigest = [[NSString stringWithFormat:@"%@%@",password,encodeString] md5];
        }
        NSXMLElement *digest = [NSXMLElement elementWithName:@"digest" stringValue:stringDigest];
        if (sid){
            [digest addAttributeWithName:@"sid" stringValue:sid];
        }
        [query addChild:digest];
    }
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addChild:query];
    
    NSLog(@"%@",self.aXMPPStream.myJID);
    [self.aXMPPStream sendElement:iq];
}


/**获取服务器时间**/
- (void)sendRequestServerTimeIq
{
    XMPPJID *to =  [XMPPJID jidWithString:self.aXMPPStream.myJID.domain];
    NSString *elementID = [self.aXMPPStream generateUUID];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:time"];
    [iq addChild:query];
    [self.aXMPPStream sendElement:iq];
}

/**请求头像**/
- (void)sendRequestHeaderIconURLWithJID:(NSString *)jid {
    XMPPJID *to = [XMPPJID jidWithString:jid];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:kStringXMPPElementIDGetPhotoHash];
    NSXMLElement *vCard = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
    [vCard addAttributeWithName:@"ver" intValue:0];
    NSXMLElement *PHOTO = [NSXMLElement elementWithName:@"PHOTO"];
    [vCard addChild:PHOTO];
    [iq addChild:vCard];
    [self.aXMPPStream sendElement:iq];
}

//获取个人消息
-(void)queryInformationByJid:(NSString *)aJID completed:(LTXMPPManager_iq_queryInformationByJidBlock)aBlock {
    self.iq_queryInformationByJidBlock = aBlock;
    NSString *elementID = @"rstrone";
    XMPPJID *to = [XMPPJID jidWithString:aJID];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:to elementID:elementID];
    NSXMLElement *query = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
    [query addAttributeWithName:kStringXMPPVersion stringValue:@"0"];
    [iq addChild:query];
    [self.aXMPPStream sendElement:iq];
}










#pragma mark - Private

- (NSMutableDictionary *)copiedMutableDictionaryFrom:(NSDictionary *)source {
    NSMutableDictionary *target = [[NSMutableDictionary alloc] initWithCapacity:10];
    for(NSString *key in [source allKeys])
    {
        [target setObject:[self valueForKey:key inDictionary:source] forKey:key];
    }
    return target;
}

- (NSMutableDictionary *)copiedSomeone:(NSDictionary *)from {
    //先存下来组别信息
    NSString *group = [self valueForKey: @"group" inDictionary:from];
    //复制一份在线状态，并去掉原有的组别信息字典
    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:from copyItems:YES];
    NSString *fullName = [NSObject objectForKey:@"name" inDictionary:from];
//    if([NSObject isEmpty:fullName]) //如果名字为空，那么从组织架构里取，如果组织架构里没有，再截jabberId的@之前的部分，即为名字
//    {
//        if(_delegate!=nil && [_delegate respondsToSelector:@selector(XMPPServer:valueFromCachesByProperty:jabberId:withRequestId:)])
//        {
//            fullName = [_delegate XMPPServer:self
//                   valueFromCachesByProperty:@"name"
//                                    jabberId:[NSObject objectForKey:@"jid" inDictionary:from]
//                               withRequestId: @"rosters"];
//        }
//    }
    [item setObject:fullName forKey:@"FN" ];
    [item setObject:[self transferToPinYin:fullName] forKey:@"pinYin"];
    [item removeObjectForKey:kXMLReaderTextNodeKey];
    //再把级别字符串添加进去
    [item setObject:group forKey:@"group"];
    return item;
}
- (NSString *)transferToPinYin:(NSString *)name
{
    NSMutableString *_pinYin = [NSMutableString stringWithCapacity:1];
    
    for(int j=0; j<name.length; j++)
    {
        int character = [name characterAtIndex:j];
        if(character==32)
            continue;
        
        if(character>=65 && character<=128)
        {
            if(j>0) //取首字母
            {
                int lastCharacter = [name characterAtIndex:j-1];
                if(lastCharacter==32) {
                    [_pinYin appendString:[[name substringWithRange:NSMakeRange(j, 1)] uppercaseString]];
                }
            } else {
                [_pinYin appendString:[[NSString stringWithFormat:@"%c", character] uppercaseString]];
            }
        }else{
            [_pinYin appendString:[[NSString stringWithFormat:@"%c", pinyinFirstLetter(character)] uppercaseString]];
        }
    }
    return _pinYin;
}

- (NSString *)valueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary
{
    id value = [NSObject objectForKey:key inDictionary:dictionary];
    if([value isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dValue = [NSObject objectForKey:key inDictionary:dictionary];
        value = [NSObject objectForKey:kXMLReaderTextNodeKey inDictionary:dValue];
    }
    else if(![value isKindOfClass:[NSString class]])
    {
        value = [value description];
    }
    return value;
}








@end
