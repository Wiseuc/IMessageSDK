//
//  OrgModel.h
//  XMLParser
//
//  Created by 吴林峰 on 16/4/8.
//  Copyright © 2016年 WiseUC. All rights reserved.
//
/*
 
 <OrgSUBGROUP
 
 ID='14'
 PID='14'
 ITEMTYPE='1'
 NAME='总经办'
 time='2007-08-08 00:00:00'
 info=''
 indexs='24'
 parentid='0'
 
 >
 
 
 
 <JID
 
 ID='0'
 LoginName='张代军'
 PID='13'
 ITEMTYPE='2'
 NAME='张代军'
 
 JID='张代军@duowin-server'
 NICK='张代军'
 MOBILE='18607553411'
 TELE='88832321'
 TelExt=''
 MOBEXT='8009'
 
 EMAIL='175249221@qq.com'
 title='总经理'
 sex='男'
 leader='0'
 indexs='13'>
 
 </JID>
 */




#import <Foundation/Foundation.h>

#define kSUBGROUP   @"SUBGROUP"
#define kJID        @"JID"

#define kID         @"ID"
#define kPID        @"PID"
#define kITEMTYPE   @"ITEMTYPE"
#define kNAME       @"NAME"
#define kParentid   @"parentid"
#define kLoginName  @"LoginName"
#define kTitle      @"title"
#define kIndexs     @"indexs"


typedef enum {
    OrgItemType_Subgroup = 1,
    OrgItemType_JID = 2
} OrgItemType;

@interface OrgModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *PID;
@property (nonatomic, copy) NSString *ITEMTYPE;
@property (nonatomic, copy) NSString *NAME;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *parentid;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *indexs;
@property (nonatomic, copy) NSString *LoginName;
@property (nonatomic, copy) NSString *JID;

@property (nonatomic, strong) NSArray *parent;
@property (nonatomic, strong) NSArray *children;

@property (nonatomic, assign) BOOL parentIsChoose;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic, assign) NSInteger lever;

@property (nonatomic, assign) OrgItemType orgItemType; //!< 1 代表:SUBGROUP, 2 代表:JID
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong, readonly) NSAttributedString *subgroupAttributedString;

@property (nonatomic, assign) NSInteger orgMenuIndex;

- (void)addChild:(id)child;

@end
