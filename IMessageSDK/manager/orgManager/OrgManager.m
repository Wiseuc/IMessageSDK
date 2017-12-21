//
//  OrgManager.m
//  IMessageSDK
//
//  Created by JH on 2017/12/18.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "OrgManager.h"

@interface OrgManager ()
@property (nonatomic, strong) GDataXMLDocument *doc;
@end


@implementation OrgManager

+ (instancetype)share {
    static OrgManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OrgManager alloc] init];
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

-(NSDictionary *)queryDocumentDescribe {
    
    NSString *ID = [[[self queryRootElement] attributeForName:@"ID"] stringValue];
    NSString *NAME = [[[self queryRootElement] attributeForName:@"NAME"] stringValue];
    NSString *name_ext = [[[self queryRootElement] attributeForName:@"name_ext"] stringValue];
    NSString *url = [[[self queryRootElement] attributeForName:@"url"] stringValue];
    NSString *time = [[[self queryRootElement] attributeForName:@"time"] stringValue];
    
    NSString *industry = [[[self queryRootElement] attributeForName:@"industry"] stringValue];
    NSString *subindustry = [[[self queryRootElement] attributeForName:@"subindustry"] stringValue];
    NSString *country = [[[self queryRootElement] attributeForName:@"country"] stringValue];
    NSString *province = [[[self queryRootElement] attributeForName:@"province"] stringValue];
    NSString *city = [[[self queryRootElement] attributeForName:@"city"] stringValue];
    
    NSString *district = [[[self queryRootElement] attributeForName:@"district"] stringValue];
    NSString *addr = [[[self queryRootElement] attributeForName:@"addr"] stringValue];
    NSString *remark = [[[self queryRootElement] attributeForName:@"remark"] stringValue];
    NSString *Version = [[[self queryRootElement] attributeForName:@"Version"] stringValue];
    NSString *PID = [[[self queryRootElement] attributeForName:@"PID"] stringValue];

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

@end
