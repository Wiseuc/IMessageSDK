//
//  LTOrg.m
//  WiseUC
//
//  Created by JH on 2017/12/6.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "LTOrg.h"
#import "OrgManager.h"
#define kLTOrg_orgKey @"kLTOrg_orgKey"


@interface LTOrg ()

/**
 ID="58"
 LoginName="江海"
 PID="10874"
 ITEMTYPE="2"
 NAME="江海"
 
 JID="江海@duowin-server"
 NICK=""
 MOBILE="18823780407"
 TELE=""
 TelExt=""
 
 MOBEXT="0"
 EMAIL=""
 title="iOS开发工程师"
 sex="男"
 leader="0"
 
 indexs="674">

 **/

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *LoginName;
@property (nonatomic, copy) NSString *PID;
@property (nonatomic, copy) NSString *ITEMTYPE;
@property (nonatomic, copy) NSString *NAME;

@property (nonatomic, copy) NSString *JID;
@property (nonatomic, copy) NSString *NICK;
@property (nonatomic, copy) NSString *MOBILE;
@property (nonatomic, copy) NSString *TELE;
@property (nonatomic, copy) NSString *TelExt;

@property (nonatomic, copy) NSString *MOBEXT;
@property (nonatomic, copy) NSString *EMAIL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *leader;

@property (nonatomic, copy) NSString *indexs;
@end




@implementation LTOrg

+ (instancetype)share {
    static LTOrg *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTOrg alloc] init];
    });
    return instance;
}


#pragma mark -================= 服务器返回的用户真实信息

-(void)updateOrgWithID:(NSString *)ID
             LoginName:(NSString *)LoginName
                   PID:(NSString *)PID
              ITEMTYPE:(NSString *)ITEMTYPE
                  NAME:(NSString *)NAME

                   JID:(NSString *)JID
                  NICK:(NSString *)NICK
                MOBILE:(NSString *)MOBILE
                  TELE:(NSString *)TELE
                TelExt:(NSString *)TelExt

                MOBEXT:(NSString *)MOBEXT
                 EMAIL:(NSString *)EMAIL
                 title:(NSString *)title
                   sex:(NSString *)sex
                leader:(NSString *)leader
                indexs:(NSString *)indexs
{
    
    NSDictionary *dict = @{
                           @"ID":ID,
                           @"LoginName":LoginName,
                           @"PID":PID,
                           @"ITEMTYPE":ITEMTYPE,
                           @"NAME":NAME,
                           
                           @"JID":JID,
                           @"NICK":NICK,
                           @"MOBILE":MOBILE,
                           @"TELE":TELE,
                           @"TelExt":TelExt,
                           
                           @"MOBEXT":MOBEXT,
                           @"EMAIL":EMAIL,
                           @"title":title,
                           @"sex":sex,
                           @"leader":leader,
                           
                           @"indexs":indexs,
                           };
    [NSUserDefaults.standardUserDefaults
     setObject:dict
     forKey:kLTOrg_orgKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    
}


- (NSDictionary *)queryOrg {
    NSDictionary *dict =
    [NSUserDefaults.standardUserDefaults
     objectForKey:kLTOrg_orgKey];
    return dict;
}

- (void)deleteOrg {
    [NSUserDefaults.standardUserDefaults
     setObject:nil forKey:kLTOrg_orgKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}





/**获取组织架构可见范围**/
- (NSArray *)queryOrgVisibleRange {
    __block NSArray *retArr = nil;
    [OrgManager getOrgVisibleRange:^(BOOL hasOrgVisible, NSArray *visibleRangeArray) {
        retArr =  visibleRangeArray;
    }];
    return retArr;
}

@end
