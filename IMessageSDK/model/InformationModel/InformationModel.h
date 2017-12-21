//
//  InformationModel.h
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//
/**
 {
 BDAY = "1993-07-02";
 CELL = 18823780407;
 EMAIL = "";
 FN = "\U6c5f\U6d77";
 GENDER = "\U7537";
 
 LOCALITY = "\U6df1\U5733\U5e02";
 LOGINNAME = "\U6c5f\U6d77";
 MOBILEEXT = 0;
 NICKNAME = "";
 PCODE = "jianghai@wiseuc.com";
 
 ORG =     {
 DESC = " ";
 ORGNAME = "\U6c47\U8baf\U8bd5\U7528\U7248(\U975e\U6b63\U5f0f\U6388\U6743)";
 ORGREFNAME = "\U6c47\U8baf\U8bd5\U7528\U7248";
 ORGUNIT = "\U7814\U53d1\U90e8";
 };
 
 
 
 REGION = "\U5e7f\U4e1c\U7701";
 STREET = "\U5357\U5c71\U533a\U79d1\U6280\U56ed\U5317\U533a\U6e05\U534e\U4fe1\U606f\U6e2f\U7efc\U5408\U697c706";
 TITLE = "iOS \U5f00\U53d1\U5de5\U7a0b\U5e08";
 TITLEDESC = "";
 URL = " ";
 
 
 WORK = "";
 WORKURL = "http://www.wiseuc.com";
 jid = "\U6c5f\U6d77@duowin-server";
 name = "\U6c5f\U6d77";
 pinYin = JH;
 vcardver = 132;
 }
 
 **/
#import <Foundation/Foundation.h>

@interface InformationModel : NSObject

@property (nonatomic, strong) NSString *BDAY;
@property (nonatomic, strong) NSString *CELL;
@property (nonatomic, strong) NSString *EMAIL;
@property (nonatomic, strong) NSString *FN;
@property (nonatomic, strong) NSString *GENDER;

@property (nonatomic, strong) NSString *LOCALITY;
@property (nonatomic, strong) NSString *LOGINNAME;
@property (nonatomic, strong) NSString *MOBILEEXT;
@property (nonatomic, strong) NSString *NICKNAME;
@property (nonatomic, strong) NSString *PCODE;


@property (nonatomic, strong) NSString *REGION;
@property (nonatomic, strong) NSString *STREET;
@property (nonatomic, strong) NSString *TITLE;
@property (nonatomic, strong) NSString *TITLEDESC;
@property (nonatomic, strong) NSString *URL;

@property (nonatomic, strong) NSString *WORK;
@property (nonatomic, strong) NSString *WORKURL;
@property (nonatomic, strong) NSString *jid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pinYin;

@property (nonatomic, strong) NSString *vcardver;
//@property (nonatomic, strong) NSMutableArray  *ORG;

@end




//@interface ORGModel : NSObject
//@property (nonatomic, strong) NSString *DESC;
//@property (nonatomic, strong) NSString *ORGNAME;
//@property (nonatomic, strong) NSString *ORGREFNAME;
//@property (nonatomic, strong) NSString *ORGUNIT;
//@end


