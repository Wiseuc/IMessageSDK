





#import "LTUser.h"
#import "LTXMPPManager+iq.h"
#define kLTUser_UserKey @"kLTUser_UserKey"
#define kLTUser_SignatureKey @"kLTUser_SignatureKey"

@interface LTUser ()
@property (nonatomic, strong) LTUser_queryInformationByJIDBlock queryInformationByJIDBlock;


@property (nonatomic, copy) NSString *PID;
@property (nonatomic, copy) NSString *AccountID;
@property (nonatomic, copy) NSString *JID;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *IsAdmin;

@property (nonatomic, copy) NSString *IMPwd;
@property (nonatomic, copy) NSString *AccountName;
@property (nonatomic, copy) NSString *Domain;
@property (nonatomic, copy) NSString *AssistantURL;
@property (nonatomic, copy) NSString *Host;

@property (nonatomic, copy) NSString *FirstChanel;
@property (nonatomic, copy) NSString *VisableChanels;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *Code_Type;
@property (nonatomic, copy) NSString *Session_ID;

@property (nonatomic, copy) NSString *PushOrgState;
@property (nonatomic, copy) NSString *ServerVer;
@property (nonatomic, copy) NSString *HasAdvert;

/**iq请求**/
@property (nonatomic, copy) NSString *Signature;  /**个性签名**/


/**
 <PID>10805</PID>
 <AccountID>131785</AccountID>
 <JID>萧凡宇@duowin-server</JID>
 <UserName>萧凡宇</UserName>
 <IsAdmin>0</IsAdmin>
 
 <IMPwd>666666</IMPwd>
 <AccountName>汇讯试用版(非正式授权)</AccountName>
 <Domain>duowin-server</Domain>
 <AssistantURL></AssistantURL>
 <Host>192.168.1.200</Host>
 
 <FirstChanel>0</FirstChanel>
 <VisableChanels>0</VisableChanels>
 <Email>xiaofanyu@wiseuc.com</Email>
 <Code_Type>1</Code_Type>
 <Session_ID>2A4975BDF9DA42F58A51CF77FD8A526E</Session_ID>
 
 <PushOrgState>1</PushOrgState>
 <ServerVer>2.1.3</ServerVer>
 <HasAdvert>1</HasAdvert>
 **/

@end



@implementation LTUser

+ (instancetype)share {
    static LTUser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTUser alloc] init];
    });
    return instance;
}




#pragma mark -================= 服务器返回的用户真实信息

-(void)updateUserWithPID:(NSString *)PID
               AccountID:(NSString *)AccountID
                UserName:(NSString *)UserName
                 IsAdmin:(NSString *)IsAdmin
                     JID:(NSString *)JID

                   IMPwd:(NSString *)IMPwd
             AccountName:(NSString *)AccountName
                  Domain:(NSString *)Domain
            AssistantURL:(NSString *)AssistantURL
                    Host:(NSString *)Host

             FirstChanel:(NSString *)FirstChanel
          VisableChanels:(NSString *)VisableChanels
                   Email:(NSString *)Email
               Code_Type:(NSString *)Code_Type
              Session_ID:(NSString *)Session_ID

            PushOrgState:(NSString *)PushOrgState
               ServerVer:(NSString *)ServerVer
               HasAdvert:(NSString *)HasAdvert
{
    
        NSDictionary *dict = @{
                               @"PID":PID,
                               @"AccountID":AccountID,
                               @"UserName":UserName,
                               @"IsAdmin":IsAdmin,
                               @"JID":JID,
                               
                               @"IMPwd":IMPwd,
                               @"AccountName":AccountName,
                               @"Domain":Domain,
                               @"AssistantURL":AssistantURL,
                               @"Host":Host,
                               
                               @"FirstChanel":FirstChanel,
                               @"VisableChanels":VisableChanels,
                               @"Email":Email,
                               @"Code_Type":Code_Type,
                               @"Session_ID":Session_ID,
                               
                               @"PushOrgState":PushOrgState,
                               @"ServerVer":ServerVer,
                               @"HasAdvert":HasAdvert,
                               };
        [NSUserDefaults.standardUserDefaults
         setObject:dict
         forKey:kLTUser_UserKey];
        [NSUserDefaults.standardUserDefaults synchronize];

}


- (NSDictionary *)queryUser {
    NSDictionary *dict =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kLTUser_UserKey];
    return dict;
}

- (void)deleteUser {
    [NSUserDefaults.standardUserDefaults
     setObject:nil forKey:kLTUser_UserKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}




#pragma mark -================= signature

-(void)updateUserWithSignature:(NSString *)Signature
{
    [NSUserDefaults.standardUserDefaults
     setObject:Signature
     forKey:kLTUser_SignatureKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)querySignature{
    NSString *ret =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kLTUser_SignatureKey];
    return ret;
}

- (void)deleteSignature {
    [NSUserDefaults.standardUserDefaults
     setObject:nil forKey:kLTUser_SignatureKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}



-(void)queryInformationByJID:(NSString *)aJID
                   completed:(LTUser_queryInformationByJIDBlock)aBlock {
    _queryInformationByJIDBlock = aBlock;
    [LTXMPPManager.share queryInformationByJid:aJID
                                     completed:^(NSDictionary *dict, LTError *error) {
                                         if (_queryInformationByJIDBlock) {
                                             _queryInformationByJIDBlock(dict);
                                         }
                                     }];
}










@end
