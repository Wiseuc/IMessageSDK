//
//  LT_XMLParserManager.m
//  XMLParser
//
//  Created by 吴林峰 on 16/4/8.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "LT_XMLParserManager.h"
#import "LT_Macros.h"
// 单拎所在部门
#define IsVisibleSingleSection  0







@implementation LT_XMLParserManager


/**获取组织架构**/
+(GDataXMLDocument *)queryOrgDocument {
    NSString *docPath = [self queryOrgFilepath];
    NSString *docStr = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
    return [[GDataXMLDocument alloc] initWithXMLString:docStr options:0 error:nil];
}

+(GDataXMLElement *)queryRootElement {
    GDataXMLDocument *doc = [self queryOrgDocument];
    return [doc rootElement];
}

+ (NSString *)queryOrgFilepath {
    return [kOrgFilePath stringByAppendingPathComponent:@"Organize.xml"];
}


@end
