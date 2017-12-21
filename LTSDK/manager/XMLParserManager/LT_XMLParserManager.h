//
//  LT_XMLParserManager.h
//  XMLParser
//
//  Created by 吴林峰 on 16/4/8.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT_GDataXMLNode.h"



@interface LT_XMLParserManager : NSObject

/**获取组织架构**/
+ (GDataXMLDocument *)queryOrgDocument;

@end
