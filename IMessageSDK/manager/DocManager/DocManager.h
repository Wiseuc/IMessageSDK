//
//  DocManager.h
//  IMessageSDK
//
//  Created by JH on 2017/12/18.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT_GDataXMLNode.h"
#import "OrgModel.h"
@interface DocManager : NSObject


/*!
 @method
 @abstract 初始化
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 更新Document
 @discussion null
 */
- (void)updateDocument:(GDataXMLDocument *)doc;


/*!
 @method
 @abstract 获取Doc
 */
- (GDataXMLDocument *)queryDocument;


/*!
 @method
 @abstract 获取rootEle
 @discussion null
 @result  返回xml
 */
- (GDataXMLElement *)queryRootElement;





/*!
 @method
 @abstract 获取DOc的基本信息
 @discussion null
 @result  字典
 
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
 remark='深圳市励拓软件有限公司成立于2007年8月帮助客户在组织管理领域成就梦想：让沟通更简单、让组织更高效。'
 Version='1505795389'
 PID='0'
 */
- (NSDictionary *)queryDocumentDescribe;

/**向下查询**/
- (NSArray *)queryNextOrgData:(OrgModel *)model;

/**查询所有JID**/
- (NSArray<OrgModel *> *)queryAllJID;

/**查询所有SUBGROUP**/
- (NSArray<OrgModel *> *)queryAllSUBGROUP;








@end
