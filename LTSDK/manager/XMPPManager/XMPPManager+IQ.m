//
//  XMPPManager+IQ.m
//  WiseUC
//
//  Created by wj on 16/1/19.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager+IQ.h"
@implementation XMPPManager (IQ)




//- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq;
//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message;
//- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence;



#pragma mark - 代理XMPPIQ

-(void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq {

}

//接收的消息
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    /**用户名或密码输入有误**/
//    BOOL isIqError = [[[iq attributeForName:kStringXMPPIQType] stringValue] isEqualToString:kStringXMPPIQTypeError];
//    if ( isIqError ) {
//        [self xmppIqLoginCheck:iq];
//    }

    // 服务器时间
//    NSXMLElement *query = [iq elementForName:@"query" xmlns:@"jabber:iq:time"];
//    if ( query ) {
//        NSString *utc_Str = [[query elementForName:@"utc"] stringValue];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyyMMdd'T'HH:mm:ss";
//        NSDate *serverDate = [dateFormatter dateFromString:utc_Str];
//        NSDate *localTime = [NSDate date];
//        long long timeOffset = (long long)[localTime timeIntervalSinceDate:serverDate];
//        _timeOffset_localLeadToServer = timeOffset;
//    }

//    if ([iq isResultIQ]) {
//        NSArray *query = [iq elementsForName:@"query"];
//        if ([iq attributeForName:@"from"].stringValue && query.count == 0) {
//            if (self.msgReceiverdelegate && [self.msgReceiverdelegate respondsToSelector:@selector(XMPPServer:didReceiveSuccessCreateGroup:from:)]) {
//                [self.msgReceiverdelegate XMPPServer:self didReceiveSuccessCreateGroup:YES from:[iq attributeForName:@"from"].stringValue];
//                return YES;
//            }
//        }
//    }
    
    

    //登录Auth
    if ( [iq isResultIQ] ) {
        NSXMLElement *query = [iq elementForName:@"query"];
        NSXMLElement *Message = [query elementForName:@"Message"];
        if (Message != nil) { //防止接收iq消息时result类型时再次登录
            NSString *JID = [[Message elementForName:@"JID"] stringValue];
            NSString *IMPwd = [[Message elementForName:@"IMPwd"] stringValue];
            NSString *resource = @"IphoneIM";

//            _userModel.PID = [[Message elementForName:@"PID"] stringValue];
//            _userModel.AccountID = [[Message elementForName:@"AccountID"] stringValue];
//            _userModel.AccountName = [[Message elementForName:@"AccountName"] stringValue];
//
//
//            [[XMPPManager shareXMPPManager] loginWithJID:JID password:IMPwd resource:resource];
            return YES;
        }
    }


    //获取Digest，内部实现发送send,内部实现了
//    if ( [iq isResultIQ] ) {
//        NSXMLElement *query = [iq elementForName:@"query" xmlns:@"jabber:iq:auth"];
//        if (query) {
//            //登录页面登录有数据： 自动登录时为nil
//            NSString *username = LoginManager.shareHelper.loginName;
//            NSString *password = LoginManager.shareHelper.loginPassword;
//
//            if (username == nil || password == nil) {
//                NSDictionary *userInfo = [NSUserDefaults.standardUserDefaults objectForKey:kUSERDEFAULT_USER];
//                username = userInfo[@"username"];
//                password = userInfo[@"password"];
//            }
//
//            self.xmppStream.loginname = username;
//            self.xmppStream.password = password;
//             [_xmppStream authenticateWithPassword:_userModel.password error:nil];
//        }
//    }





//    //获取头像
//    if ( [iq isResultIQ] ) {
//        NSString *elementId = [iq elementID];
//        if ([elementId isEqualToString:kStringXMPPElementIDGetPhotoHash]) {
//            NSXMLElement *vCard = [iq elementForName:@"vCard"];
//            NSXMLElement *PHOTO = [vCard elementForName:@"PHOTO"];
//            NSString *from = [[[iq attributeForName:@"from"] stringValue] componentsSeparatedByString:@"/"][0];
//            if ( nil != vCard ) {
//
//                [XMPPManager parseIQ_PhotoHash:vCard withJID:from];
//                return YES;
//            }
//            else
//            {
//                [XMPPManager saveDefaultHeadImageByJID:from];
//                return YES;
//            }
//        }
//    }
    
    
    

//    //获取Pid
//    if ( [iq isResultIQ] ) {
//
//        NSString *fromstr = iq.fromStr;
//        NSString *tostr   = iq.toStr;
//        NSString *elementId = [iq elementID];
//
//        if ([elementId isEqualToString:kStringXMPPElementIDRequestPid])
//        {
//            NSXMLElement *pidEle = [iq elementForName:@"pid"];
//
//            //如果包含，则说明是查找自己的PID
//            if ([tostr containsSubstring:fromstr])
//            {
//                NSLog(@"自己PID: %@",pidEle.stringValue);
//                AppDelegateInstance.pidToken = pidEle.stringValue;
//                [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_Linphone_GetUserPid object:nil userInfo:nil];
//
//            }else{
//                NSLog(@"对方PID: %@",pidEle.stringValue);
//                UserManager.shareInstance.chatterPid = pidEle.stringValue;
//                [[NSNotificationCenter defaultCenter] postNotificationName:Wiseuc_Notification_Linphone_GetOtherUserPid object:nil userInfo:nil];
//            }
//        }
//    }



    //NSLog(@"XMPP服务接收到IQ数据:\n%@", [iq XMLString]);
//    NSError *error = nil;
//    NSDictionary *result = [XMLReader dictionaryForXMLString:[iq XMLString] error:&error];
//    NSDictionary *info = [NSObject objectForKey:@"iq"  inDictionary:result  espectedType:[NSDictionary class]];
//
//    NSString *elementId = [iq elementID];
//    NSString *type = [iq type];
    
    
    
    
    

//    if ([kStringXMPPIQTypeResult isEqualToString:type]) {
//
////        if ( [elementId rangeOfString:kStringXMPPElementIDRoster4One].location != NSNotFound )
////        {
////            if([[info allKeys] containsObject:kStringXMPPIQVCard])  //个人信息
////            {
////                NSDictionary *card = [NSObject objectForKey:kStringXMPPIQVCard inDictionary:info espectedType:[NSDictionary class]];
////                [XMPPManager parseVCardForPhotoHash:card withJID:info[@"from"]];
////            }
////        }
//
//        if (_delegate != nil) {
//
//           // if ([elementId rangeOfString:kStringXMPPElementIDGroups options:NSCaseInsensitiveSearch].length>0)//如果获取到的是群组信息
//            /// 获取群组列表
//            if ([elementId isEqualToString:kStringXMPPElementIDGroups])
//            {
//
//                NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:10];
//                id _itms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:info];
//                if([_itms isKindOfClass:[NSDictionary class]])
//                {
//                    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:5];
//                    NSString *name = [NSObject objectForKey:kStringXMPPRosterName inDictionary:_itms];
//                    NSString *xmlns = [NSObject objectForKey:kStringXMPPRosterXmlns inDictionary:_itms];
//                    NSString *jid = [NSObject objectForKey:kStringXMPPRosterJabberId inDictionary:_itms];
//                    NSString *category = [NSObject objectForKey:kStringXMPPRosterCategory inDictionary:_itms];
//                    [item setObject:name forKey:kStringXMPPRosterNameFull];
//                    [item setObject:name forKey:kStringXMPPRosterName];
//                    [item setObject:xmlns forKey:kStringXMPPRosterXmlns];
//                    [item setObject:jid forKey:kStringXMPPRosterJabberId];
//                    [item setObject:category forKey:kStringXMPPRosterCategory];
//
//                    NSMutableArray *subItems = [[NSMutableArray alloc] initWithCapacity:5];
//                    id _subitms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:_itms];
//                    if([_subitms isKindOfClass:[NSDictionary class]])
//                    {
//                        NSMutableDictionary *subItem = [self copiedMutableDictionaryFrom:_subitms];
//                        [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:subItem] forKey:kStringXMPPRosterNameFull];
//
//                        [subItems addObject:subItem];
//                    }
//                    else if([_subitms isKindOfClass:[NSArray class]])
//                    {
//                        for(NSDictionary *_subitm in _subitms)
//                        {
//                            NSMutableDictionary *subItem = [self copiedMutableDictionaryFrom:_subitm];
//                            [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:subItem] forKey:kStringXMPPRosterNameFull];
//
//                            [subItems addObject:subItem];
//                        }
//                    }
//
//                    [item setObject:subItems forKey:kStringXMPPRosterItem];
//
//                    [items addObject:item];
//                }
//                else if([_itms isKindOfClass:[NSArray class]])
//                {
//                    NSMutableArray *subItems = [[NSMutableArray alloc] initWithCapacity:5];
//
//                    id _subitms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:_itms];
//                    if([_subitms isKindOfClass:[NSDictionary class]])
//                    {
//                        NSMutableDictionary *subItem = [[NSMutableDictionary alloc] initWithDictionary:_subitms];
//                        [subItems addObject:subItem];
//                    }
//                    else if([_subitms isKindOfClass:[NSArray class]])
//                    {
//                        [subItems addObjectsFromArray:_subitms];
//                    }
//
//                    [items addObjectsFromArray:subItems];
//                }
//
//                if ( _delegate && [_delegate respondsToSelector:@selector(XMPPServer:didReceiveGroups:)] ) {
//                    [_delegate XMPPServer:self didReceiveGroups:items];
//                }
//
//            }
//            /// 获取好友列表
//            else if ([elementId rangeOfString:kStringXMPPElementIDRoster options:NSCaseInsensitiveSearch].length > 0)
//            {
//                NSDictionary *query = [NSObject objectForKey:kStringXMPPIQQuery inDictionary:info espectedType:[NSDictionary class]];
//                id _items = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:query];
//                NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:10];
//                if([_items isKindOfClass:[NSDictionary class]])
//                {
//                    [items addObject:[self copiedSomeone:_items]];
//                }
//                else if([_items isKindOfClass:[NSArray class]])
//                {
//                    for(NSDictionary *_item in _items)
//                    {
//                        [items addObject:[self copiedSomeone:_item]];
//                    }
//                }
//
//                NSString *version = [NSObject objectForKey:kStringXMPPVersion inDictionary:query];
//
//                [self setUserFriends:items];
//
//
//                if ( _delegate && [_delegate respondsToSelector:@selector(XMPPServer:didReceiveRoster:withVersion:)] ) {
//                    [_delegate XMPPServer:self didReceiveRoster:items withVersion:version];
//
//                }
//            }
//            /// 获取个人信息
//            else if ([elementId rangeOfString:kStringXMPPElementIDRoster4One options:NSCaseInsensitiveSearch].length>0)
//            {
//                if([[info allKeys] containsObject:kStringXMPPIQVCard])  //个人信息
//                {
//                        NSDictionary *card = [NSObject objectForKey:kStringXMPPIQVCard inDictionary:info espectedType:[NSDictionary class]];
//
//                        //如果不含有新版本的信息，那么vCard里只有两个元素xmlns和ver
//                        if(![NSObject isEmpty:card] && [card allKeys].count>2)        //vCard为空表示已经是最新版本，不需要更新
//                        {
//
//                            NSMutableDictionary *someone = [[NSMutableDictionary alloc] initWithCapacity:10];
//
//                            //版本号
//                            [someone setObject:[NSObject objectForKey:kStringXMPPVersion inDictionary:card] forKey:kStringXMPPRosterVCardVersion];
//
//                            NSMutableString *from = [[NSMutableString alloc] initWithString:[self valueForKey:kStringXMPPFrom inDictionary:info]];
//                            [from remainBeforeString:@"/"];
//                            [someone setObject:from forKey:kStringXMPPRosterJabberId];
//
//                            //性别
//                            NSString *sex = [self valueForKey:kStringXMPPRosterSex inDictionary:card];
//                            [someone setObject:sex forKey:kStringXMPPRosterSex];
//
//                            NSString *portrait = [self valueForKey:kStringXMPPRosterPortrait inDictionary:card];
//                            if([sex rangeOfString:@"男" options:NSCaseInsensitiveSearch].length>0)
//                            {
//                                portrait = [NSString stringWithFormat:@"male%@", portrait];
//                            }
//                            else if([sex rangeOfString:@"女" options:NSCaseInsensitiveSearch].length>0)
//                            {
//                                portrait = [NSString stringWithFormat:@"female%@", portrait];;
//                            }
//
////                            如果本地有，那么不管
////                            if(![[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:portrait ofType:@"png"]])
////                            {
////                                if(![NSObject isEmpty:portrait])
////                                {
////                                    portrait = [[NSMutableString alloc] initWithFormat:@"http://%@:%@/headpicture/%@.jpg",[XMPPManager shareXMPPManager].xmppStream.hostName,@"14131",[self valueForKey:kStringXMPPRosterPortrait inDictionary:card]
////                                                ];
////                                };
////                            }
////                            [someone setObject:portrait forKey:kStringXMPPRosterPortrait];
//                            //登录名
//                            [someone setObject:[self valueForKey:kStringXMPPRosterNameLogin inDictionary:card] forKey:kStringXMPPRosterNameLogin];
//                            //全名
//                            NSString *fullName = [self valueForKey:kStringXMPPRosterNameFull inDictionary:card];
//                            [someone setObject:fullName forKey:kStringXMPPRosterNameFull];
//                            [someone setObject:fullName forKey:kStringXMPPRosterName];
//                            [someone setObject:[self transferToPinYin:fullName] forKey:kStringXMPPRosterNamePinYin];
//                            //                            [someone setObject:[POAPinyin convert:fullName] forKey:kStringXMPPRosterNameQuanPin];
//                            //昵称
//                            [someone setObject:[self valueForKey:kStringXMPPRosterNameNick inDictionary:card] forKey:kStringXMPPRosterNameNick];
//                            //电子邮箱
//                            [someone setObject:[self valueForKey:kStringXMPPRosterEmail inDictionary:card] forKey:kStringXMPPRosterEmail];
//                            //个人主页
//                            [someone setObject:[self valueForKey:kStringXMPPRosterWebpage4Personal inDictionary:card] forKey:kStringXMPPRosterWebpage4Personal];
//                            //生日
//                            [someone setObject:[self valueForKey:kStringXMPPRosterBirthday inDictionary:card] forKey:kStringXMPPRosterBirthday];
//                            //岗位
//                            [someone setObject:[self valueForKey:kStringXMPPRosterJobTitle inDictionary:card] forKey:kStringXMPPRosterJobTitle];
//                            //岗位描述
//                            [someone setObject:[self valueForKey:kStringXMPPRosterJobDescription inDictionary:card] forKey:kStringXMPPRosterJobDescription];
//                            //企业网址
//                            [someone setObject:[self valueForKey:kStringXMPPRosterWebpage4Organization inDictionary:card] forKey:kStringXMPPRosterWebpage4Organization];
//                            //企业
//                            {
//                                NSDictionary *dOrg = [NSObject objectForKey:kStringXMPPRosterOrganization inDictionary:card espectedType:[NSDictionary class]];
//                                [someone setObject:[self copiedMutableDictionaryFrom:dOrg] forKey:kStringXMPPRosterOrganization];
//                            }
//                            //地址
//                            {
//                                NSMutableArray *addresses = [[NSMutableArray alloc] initWithCapacity:10];
//
//                                id _addrs = [NSObject objectForKey:kStringXMPPRosterAddresses inDictionary:card];
//                                if([_addrs isKindOfClass:[NSDictionary class]])
//                                {
//                                    [addresses addObject:[self copiedMutableDictionaryFrom:_addrs]];
//                                }
//                                else if([_addrs isKindOfClass:[NSArray class]])
//                                {
//                                    for(NSDictionary *a in _addrs)
//                                    {
//                                        [addresses addObject:[self copiedMutableDictionaryFrom:a]];
//                                    }
//                                }
//                                //[someone setObject:addresses forKey:kStringXMPPRosterAddresses];
//                                for(NSDictionary *a in addresses)
//                                {
//                                    NSArray *keys = [a allKeys];
//                                    if([keys containsObject:kStringXMPPRosterAddressTypeOrganization])
//                                    {
//                                        for(NSString *key in keys)
//                                        {
//                                            [someone setObject:[self valueForKey:key inDictionary:a] forKey:key];
//                                        }
//                                    }
//                                }
//                            }
//
//                            //联系方式
//                            {
//                                NSMutableArray *telephones = [[NSMutableArray alloc] initWithCapacity:5];
//
//                                id _tlp = [NSObject objectForKey:kStringXMPPRosterTelephones inDictionary:card];
//                                if([_tlp isKindOfClass:[NSDictionary class]])
//                                {
//                                    [telephones addObject:[self copiedMutableDictionaryFrom:_tlp]];
//                                }
//                                else if([_tlp isKindOfClass:[NSArray class]])
//                                {
//                                    for(NSDictionary *t in _tlp)
//                                    {
//                                        [telephones addObject:[self copiedMutableDictionaryFrom:t]];
//                                    }
//                                }
//                              for(NSDictionary *t in telephones)
//                                {
//                                    NSArray *keys = [t allKeys];
//
//                                    if([keys containsObject:kStringXMPPRosterTelephoneTypeWork])
//                                    {
//                                        NSString *number = [self valueForKey:kStringXMPPRosterTelephoneNumber inDictionary:t];
//
//                                        for(NSString *key in keys)
//                                        {
//                                            if([kStringXMPPRosterMobile isEqualToString:key])
//                                            {
//                                                [someone setObject:number forKey:kStringXMPPRosterMobile];
//                                            }
//                                            else if([kStringXMPPRosterTelephone isEqualToString:key])
//                                            {
//                                                [someone setObject:number forKey:kStringXMPPRosterTelephone];
//                                            }
//                                            else if([kStringXMPPRosterFax isEqualToString:key])
//                                            {
//                                                [someone setObject:number forKey:kStringXMPPRosterFax];
//                                            }
//
//                                        }
//                                    }
//                                }
//                            }
//
//                            //短号
//                            [someone setObject:[self valueForKey:kStringXMPPRosterMobileExt inDictionary:card] forKey:kStringXMPPRosterMobileExt];
//
//                            if ( _delegate && [_delegate respondsToSelector:@selector(XMPPServer:didReceiveInformationForSomeone:)]) {
//                                [_delegate XMPPServer:self didReceiveInformationForSomeone:someone];
//                            }
//                        }
//
//                }
//                else if ([[info allKeys] containsObject:kStringXMPPIQQuery])  //群组信息
//                {
//                    NSDictionary *query = [NSObject objectForKey:kStringXMPPIQQuery inDictionary:info espectedType:[NSDictionary class]];
//                    NSString *xmlns = [NSObject objectForKey:kStringXMPPXmlns inDictionary:query];
//                    if([kStringXMPPXmlnsGroup isEqualToString:xmlns])   //检查xmlns是否是群组相关的请求域
//                    {
//                        {
//                            //应用需要的群组信息
//                            NSMutableDictionary *group = [[NSMutableDictionary alloc] initWithCapacity:10];
//                            [group setObject:[NSObject objectForKey:kStringXMPPFrom inDictionary:info] forKey:kStringXMPPRosterJabberId];
//
//                            //群组名称
//                            NSDictionary *identity = [NSObject objectForKey:kStringXMPPRosterGroupIdentity inDictionary:query espectedType:[NSDictionary class]];
//
//                            NSString *fullName = [NSObject objectForKey:kStringXMPPRosterGroupName inDictionary:identity];
//                            [group setObject:fullName forKey:kStringXMPPRosterNameFull];
//                            [group setObject:[self transferToPinYin:fullName] forKey:kStringXMPPRosterNamePinYin];
//                            //                            [group setObject:[POAPinyin convert:fullName] forKey:kStringXMPPRosterNameQuanPin];
//
//                            //群组其它字段
//                            //x和identity平级
//                            NSDictionary *x = [NSObject  objectForKey:kStringXMPPX inDictionary:query espectedType:[NSDictionary class]];
//
//                            id f = [NSObject objectForKey:kStringXMPPRosterGroupField inDictionary:x];
//
//                            NSMutableArray *fields = [NSMutableArray arrayWithCapacity:10];
//                            if([f isKindOfClass:[NSDictionary class]])
//                            {
//                                [fields addObject:f];
//                            }
//                            else if([f isKindOfClass:[NSArray class]])
//                            {
//                                [fields addObjectsFromArray:f];
//                            }
//
//                            for(NSDictionary *field in fields)
//                            {
//                                NSString *k = [NSObject objectForKey:kStringXMPPRosterGroupFieldLabel inDictionary:field];
//                                if(![NSObject isEmpty:k])
//                                {
//                                    NSString *v = [self valueForKey:kStringXMPPRosterGroupFieldValue inDictionary:field];
//
//                                    //复制字段，群简介
//                                    if([kStringXMPPRosterGroupDescription isEqualToString:k])
//                                    {
//                                        [group setObject:v forKey:kStringXMPPRosterDescription];
//                                    }
//
//                                    //群公告
//                                    if([kStringXMPPRosterBulletin isEqualToString:k])
//                                    {
//                                        [group setObject:v forKey:kStringXMPPRosterBulletin];
//                                    }
//
//                                    if([kStringXMPPRosterCreatedTime isEqualToString:k])
//                                    {
//                                        if(![NSObject isEmpty:v])
//                                        {
//                                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[v doubleValue]];
//                                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                                            dateFormatter.dateFormat = @"yyyy-M-d";
//                                            v = [dateFormatter stringFromDate:date];
//                                        }
//                                    }
//
//                                    [group setObject:v forKey:k];
//                                }
//                            }
//
//                            if ( _delegate && [_delegate respondsToSelector:@selector(XMPPServer:didReceiveGroup:)]) {
//                                [_delegate XMPPServer:self didReceiveGroup:group];
//                            }
//                        }
//                    }
//                }
//            }
//            else if ([kStringXMPPElementIDMembers isEqualToString:elementId])
//            {
//                    NSString *group = [NSObject objectForKey:kStringXMPPFrom inDictionary:info];
//                    // 解析群组成员信息组成列表
//                    NSMutableArray *members = [[NSMutableArray alloc] initWithCapacity:10];
//
//                    //query节点
//                    NSDictionary *query = [NSObject objectForKey:kStringXMPPIQQuery inDictionary:info espectedType:[NSDictionary class]];
//
//                    //query以下的就是成员列表
//                    id _itmz = [NSObject objectForKey:kStringXMPPIQItem inDictionary:query];
//                    if([_itmz isKindOfClass:[NSDictionary class]])
//                    {
//                        [members addObject:_itmz];
//                    }
//                    else if([_itmz isKindOfClass:[NSArray class]])
//                    {
//                        [members addObjectsFromArray:_itmz];
//                    }
//                if ( _delegate && [_delegate respondsToSelector:@selector(XMPPServer:didReceiveMembers:forGroup:)] ) {
//                    [_delegate XMPPServer:self didReceiveMembers:members forGroup:group];
//                }
//            }
//            //获取到的搜索所求群组信息
//            else if ([elementId isEqualToString:kStringXMPPElementIDSearchAllGroups])
//            {
//                NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:10];
//                id _itms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:info];
//                if([_itms isKindOfClass:[NSDictionary class]])
//                {
//                    NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:5];
//                    NSString *name = [NSObject objectForKey:kStringXMPPRosterName inDictionary:_itms];
//                    NSString *xmlns = [NSObject objectForKey:kStringXMPPRosterXmlns inDictionary:_itms];
//                    NSString *jid = [NSObject objectForKey:kStringXMPPRosterJabberId inDictionary:_itms];
//                    NSString *category = [NSObject objectForKey:kStringXMPPRosterCategory inDictionary:_itms];
//                    [item setObject:name forKey:kStringXMPPRosterNameFull];
//                    [item setObject:name forKey:kStringXMPPRosterName];
//                    [item setObject:xmlns forKey:kStringXMPPRosterXmlns];
//                    [item setObject:jid forKey:kStringXMPPRosterJabberId];
//                    [item setObject:category forKey:kStringXMPPRosterCategory];
//
//                    NSMutableArray *subItems = [[NSMutableArray alloc] initWithCapacity:5];
//                    id _subitms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:_itms];
//                    if([_subitms isKindOfClass:[NSDictionary class]])
//                    {
//                      //  NSMutableDictionary *subItem = [self copiedMutableDictionaryFrom:_subitms];
//                      //  [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:subItem] forKey:kStringXMPPRosterNameFull];
//                        NSMutableDictionary *subItem = (NSMutableDictionary *)_subitms;
//                        [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:_subitms] forKey:kStringXMPPRosterNameFull];
//                        [subItems addObject:subItem];
//                    }
//                    else if([_subitms isKindOfClass:[NSArray class]])
//                    {
//                        for(NSDictionary *_subitm in _subitms)
//                        {
//                           // NSMutableDictionary *subItem = [self copiedMutableDictionaryFrom:_subitm];
//                         //   [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:subItem] forKey:kStringXMPPRosterNameFull];
//                            NSMutableDictionary *subItem = (NSMutableDictionary *)_subitm;
//                            [subItem setObject:[NSObject objectForKey:kStringXMPPRosterName inDictionary:_subitm] forKey:kStringXMPPRosterNameFull];
//                            [subItems addObject:subItem];
//                        }
//                    }
//
//                    [item setObject:subItems forKey:kStringXMPPRosterItem];
//
//                    [items addObject:item];
//                }
//                else if([_itms isKindOfClass:[NSArray class]])
//                {
//                    NSMutableArray *subItems = [[NSMutableArray alloc] initWithCapacity:5];
//
//                    id _subitms = [NSObject objectForKey:kStringXMPPRosterItem inDictionary:_itms];
//                    if([_subitms isKindOfClass:[NSDictionary class]])
//                    {
//                        NSMutableDictionary *subItem = [[NSMutableDictionary alloc] initWithDictionary:_subitms];
//                        [subItems addObject:subItem];
//                    }
//                    else if([_subitms isKindOfClass:[NSArray class]])
//                    {
//                        [subItems addObjectsFromArray:_subitms];
//                    }
//
//                    [items addObjectsFromArray:subItems];
//                }
//
//                if ( _delegate && [_delegate respondsToSelector:@selector(XMPPServer:didReceiveAllGroupsBySearch:)] ) {
//                    [_delegate XMPPServer:self didReceiveAllGroupsBySearch:items];
//                }
//            }
//        }
//    }
    return YES;
}



/*

#pragma mark -================= Private
// 登录iq检测
- (void)xmppIqLoginCheck:(XMPPIQ *)iq
{
    NSArray *queryArr = [iq elementsForName:kStringXMPPIQQuery];
    if ( queryArr.count > 0 ) {
        NSXMLElement * query = queryArr[0];
        if ( [[query xmlns] isEqualToString:kStringXMPPIQAccessAuth] ) {

            NSArray *errorArr = [iq elementsForName:kStringXMPPIQTypeError];
            if ( errorArr.count > 0 ) {
                NSXMLElement * errorElement = errorArr[0];
                NSString *errorInfo = [errorElement stringValue];

                //[SVProgressHUD showErrorWithStatus:@"登录失败0043" withDelay:1];
//                if ( _xmpp ) {
//                    NSError *error = [NSError errorWithDomain:errorInfo code:-10 userInfo:@{kStringXMPPIQAccessAuth:errorInfo}];
//                    _completeBlock(nil,error);
//                    return;
//                }
            }

            NSArray *messageArr = [query elementsForName:@"Message"];
            if ( messageArr.count > 0 ) {
                NSXMLElement * message = messageArr[0];
                NSArray *Error_InfoArr = [message elementsForName:@"Error_Info"];
                if ( Error_InfoArr.count > 0 ) {
                    NSXMLElement *Error_Info = Error_InfoArr[0];
                    NSString *errorInfo = [Error_Info stringValue];

                    //[SVProgressHUD showErrorWithStatus:@"登录失败0044" withDelay:1];
//                    if ( _completeBlock ) {
//                        NSError *error = [NSError errorWithDomain:errorInfo code:-10 userInfo:@{kStringXMPPIQAccessAuth:errorInfo}];
//                        _completeBlock(nil,error);
//                    }
                }
            }
        }
    }
}


*/


@end
