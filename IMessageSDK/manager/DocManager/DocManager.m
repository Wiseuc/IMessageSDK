//
//  DocManager.m
//  IMessageSDK
//
//  Created by JH on 2017/12/18.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "DocManager.h"

@interface DocManager ()
@property (nonatomic, strong) GDataXMLDocument *doc;
@end




@implementation DocManager

+ (instancetype)share {
    static DocManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DocManager alloc] init];
    });
    return instance;
}




-(void)updateDocument:(GDataXMLDocument *)doc {
    self.doc = doc;
}

- (GDataXMLDocument *)queryDocument {
    return self.doc;
}

- (GDataXMLElement *)queryRootElement {
    return [self.doc rootElement];
}


/**
 <ORG
 ID='0'
 NAME='汇讯试用版'
 name_ext='汇讯试用版'
 url='http://www.wiseuc.com'
 time='2007-08-08 00:00:00'
 
 industry='通信邮政 计算机 网络'
 subindustry='互联网信息及技术服务'
 country='中国'
 province='广东省'
 city='深圳市'
 
 district='南山区'
 addr='南山区科技园北区清华信息港综合楼706'
 remark='深圳市励拓软件有限公司成立于2007年8月致力于帮助客户在组织管理领域成就梦想：让沟通更简单、让组织更高效。'
 Version='1505795389'
 PID='0'
 >
 
 **/

- (NSDictionary *)queryDocumentDescribe {
    
    GDataXMLElement *root = [self queryRootElement];
    
    NSString *ID = [[root attributeForName:@"ID"] stringValue];
    NSString *NAME = [[root attributeForName:@"NAME"] stringValue];
    NSString *name_ext = [[root attributeForName:@"name_ext"] stringValue];
    NSString *url = [[root attributeForName:@"url"] stringValue];
    NSString *time = [[root attributeForName:@"time"] stringValue];
    
    NSString *industry = [[root attributeForName:@"industry"] stringValue];
    NSString *subindustry = [[root attributeForName:@"subindustry"] stringValue];
    NSString *country = [[root attributeForName:@"country"] stringValue];
    NSString *province = [[root attributeForName:@"province"] stringValue];
    NSString *city = [[root attributeForName:@"city"] stringValue];
    
    NSString *district = [[root attributeForName:@"district"] stringValue];
    NSString *addr = [[root attributeForName:@"addr"] stringValue];
    NSString *remark = [[root attributeForName:@"remark"] stringValue];
    NSString *Version = [[root attributeForName:@"Version"] stringValue];
    NSString *PID = [[root attributeForName:@"PID"] stringValue];
    
    NSDictionary *dict = @{
                           @"ID":ID,
                           @"NAME":NAME,
                           @"name_ext":name_ext,
                           @"url":url,
                           @"time":time,
                           
                           @"industry":industry,
                           @"subindustry":subindustry,
                           @"country":country,
                           @"province":province,
                           @"city":city,
                           
                           @"district":district,
                           @"addr":addr,
                           @"remark":remark,
                           @"Version":Version,
                           @"PID":PID
                           };
    return dict;
}








/**查询所有JID**/
- (NSArray<OrgModel *> *)queryAllJID {
    
    GDataXMLDocument *doc = [self queryDocument];
    
    //匹配所有JID，不管它们位置
    NSString *xpathString = [NSString stringWithFormat:@"//JID"];
    
    NSArray *eles = [doc nodesForXPath:xpathString error:nil];
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    if ( eles.count > 0 )
    {
        for ( GDataXMLElement *element in eles )
        {
            OrgModel *model   = [[OrgModel alloc] init];
            model.ITEMTYPE    = [[element attributeForName:@"ITEMTYPE"] stringValue];
            model.ID          = [[element attributeForName:@"ID"] stringValue];
            model.NAME        = [[element attributeForName:@"NAME"] stringValue];
            model.PID         = [[element attributeForName:@"PID"] stringValue];
            model.indexs      = [[element attributeForName:@"indexs"] stringValue];
            model.NAME_PINYIN = [self transformToPinyin:model.NAME];
            
            if ( [[[element attributeForName:@"ITEMTYPE"] stringValue] isEqualToString:@"2"] )
            {
                model.JID     = [[element attributeForName:@"JID"] stringValue];
                model.NICK    = [[element attributeForName:@"NICK"] stringValue];
                model.MOBILE  = [[element attributeForName:@"MOBILE"] stringValue];
                model.TELE    = [[element attributeForName:@"TELE"] stringValue];
                model.TelExt  = [[element attributeForName:@"TelExt"] stringValue];
                model.MOBEXT  = [[element attributeForName:@"MOBEXT"] stringValue];
                
                model.EMAIL   = [[element attributeForName:@"EMAIL"] stringValue];
                model.title   = [[element attributeForName:@"title"] stringValue];
                model.sex     = [[element attributeForName:@"sex"] stringValue];
                model.leader  = [[element attributeForName:@"leader"] stringValue];
            }
            [mArray addObject:model];
        }
    }
    return mArray;
}


/**查询所有SUBGROUP**/
- (NSArray<OrgModel *> *)queryAllSUBGROUP {
    
    GDataXMLDocument *doc = [self queryDocument];
    
    //匹配所有JID，不管它们位置
    NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP"];
    
    NSArray *eles = [doc nodesForXPath:xpathString error:nil];
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    if ( eles.count > 0 )
    {
        for ( GDataXMLElement *element in eles )
        {
            OrgModel *model   = [[OrgModel alloc] init];
            model.ITEMTYPE    = [[element attributeForName:@"ITEMTYPE"] stringValue];
            model.ID          = [[element attributeForName:@"ID"] stringValue];
            model.NAME        = [[element attributeForName:@"NAME"] stringValue];
            model.PID         = [[element attributeForName:@"PID"] stringValue];
            model.indexs      = [[element attributeForName:@"indexs"] stringValue];
            model.NAME_PINYIN = [self transformToPinyin:model.NAME];
            
            /**1:SUBGROUP  2:JID **/
            if ( [[[element attributeForName:@"ITEMTYPE"] stringValue] isEqualToString:@"1"] )
            {
                model.time     = [[element attributeForName:@"time"] stringValue];
                model.info     = [[element attributeForName:@"info"] stringValue];
                model.parentid = [[element attributeForName:@"parentid"] stringValue];
            }
            [mArray addObject:model];
        }
    }
    return mArray;
}









/**向下查询**/ 
- (NSArray<OrgModel *> *)queryNextOrgData:(OrgModel *)model{
    GDataXMLElement *ele = nil;
    if (model == nil)
    {
        ele = [self queryRootElement];
    }else {
        GDataXMLDocument *doc = [self queryDocument];
        NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=%@]",model.ID];
        ele = [doc nodesForXPath:xpathString error:nil][0];
    }
    return [self queryOrgDataWithElement:ele orgModel:model];;
}





/**
 查询组织架构数据

 @param aElement 节点
 @param aOrgModel org模型
 @return 组织架构数组
 */
- (NSArray<OrgModel *> *)queryOrgDataWithElement:(GDataXMLElement *)aElement
                            orgModel:(OrgModel *)aOrgModel {
    
    NSMutableArray *mArray = [NSMutableArray array];
    NSArray *childrenElements = aElement.children;
    
    if ( childrenElements.count > 0 )
    {
        for ( GDataXMLElement *element in childrenElements )
        {
            OrgModel *model   = [[OrgModel alloc] init];
            model.ITEMTYPE    = [[element attributeForName:@"ITEMTYPE"] stringValue];
            model.ID          = [[element attributeForName:@"ID"] stringValue];
            model.NAME        = [[element attributeForName:@"NAME"] stringValue];
            model.PID         = [[element attributeForName:@"PID"] stringValue];
            model.indexs      = [[element attributeForName:@"indexs"] stringValue];
            model.NAME_PINYIN = [self transformToPinyin:model.NAME];
            
            /**1:SUBGROUP  2:JID **/
            if ( [[[element attributeForName:@"ITEMTYPE"] stringValue] isEqualToString:@"1"] )
            {
                model.time     = [[element attributeForName:@"time"] stringValue];
                model.info     = [[element attributeForName:@"info"] stringValue];
                model.parentid = [[element attributeForName:@"parentid"] stringValue];
            }
            else if ( [[[element attributeForName:@"ITEMTYPE"] stringValue] isEqualToString:@"2"] )
            {
                model.JID     = [[element attributeForName:@"JID"] stringValue];
                model.NICK    = [[element attributeForName:@"NICK"] stringValue];
                model.MOBILE  = [[element attributeForName:@"MOBILE"] stringValue];
                model.TELE    = [[element attributeForName:@"TELE"] stringValue];
                model.TelExt  = [[element attributeForName:@"TelExt"] stringValue];
                model.MOBEXT  = [[element attributeForName:@"MOBEXT"] stringValue];
                
                model.EMAIL   = [[element attributeForName:@"EMAIL"] stringValue];
                model.title   = [[element attributeForName:@"title"] stringValue];
                model.sex     = [[element attributeForName:@"sex"] stringValue];
                model.leader  = [[element attributeForName:@"leader"] stringValue];
            }
            
            [mArray addObject:model];
        }
    }
    
    return mArray;
}















#pragma mark - tools

/**
 汉字转拼音
 */
- (NSString *)transformToPinyin:(NSString *)name {
    NSMutableString *mutableString = [NSMutableString stringWithString:name];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin,false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}





@end
