//
//  LT_OrgModel.h
//  LTSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
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
@interface LT_OrgModel : NSObject

/**公共**/
@property (nonatomic, strong) NSString *ITEMTYPE;  /**1:SUBGROUP   2:JID**/



/**SUBGroup部分**/
@property (nonatomic, strong) NSString *subg_ID;
@property (nonatomic, strong) NSString *subg_PID;
//@property (nonatomic, strong) NSString *subg_ITEMTYPE;
@property (nonatomic, strong) NSString *subg_NAME;
@property (nonatomic, strong) NSString *subg_time;
@property (nonatomic, strong) NSString *subg_info;
@property (nonatomic, strong) NSString *subg_indexs;
@property (nonatomic, strong) NSString *subg_parentid;
//附：
@property (nonatomic, strong) NSString *subg_NAME_PINYIN; /**拼音**/


/**JID部分**/
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *LoginName;
@property (nonatomic, strong) NSString *PID;
//@property (nonatomic, strong) NSString *ITEMTYPE;  /**1:SUBGROUP   2:JID**/
@property (nonatomic, strong) NSString *NAME;

@property (nonatomic, strong) NSString *JID;
@property (nonatomic, strong) NSString *NICK;
@property (nonatomic, strong) NSString *MOBILE;
@property (nonatomic, strong) NSString *TELE;
@property (nonatomic, strong) NSString *TelExt;
@property (nonatomic, strong) NSString *MOBEXT;

@property (nonatomic, strong) NSString *EMAIL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *leader;   //是否为leader
@property (nonatomic, strong) NSString *indexs;
//附：
@property (nonatomic, strong) NSString *NAME_PINYIN; /**拼音**/




@end
