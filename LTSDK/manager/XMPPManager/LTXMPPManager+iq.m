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
                 NSString *errorInfo = [errorElement stringValue];
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
            NSString *JID = userDict[@"JID"];
            NSString *IMPwd = userDict[@"IMPwd"];
            [self.aXMPPStream setLoginname:UserName];
            [self.aXMPPStream setPassword:IMPwd];
            /**验证密码**/
            [self loginAuthWithPassword:IMPwd];
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


@end
