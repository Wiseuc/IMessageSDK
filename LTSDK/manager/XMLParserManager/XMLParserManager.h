//
//  XMLParserManager.h
//  XMLParser
//
//  Created by 吴林峰 on 16/4/8.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT_GDataXMLNode.h"
#import "OrgModel.h"
#import "LT_Singleton.h"


@interface XMLParserManager : NSObject
@property (nonatomic, copy) NSString *xmlFilePath;
@property (nonatomic, strong) GDataXMLDocument *XMLDocument;
@property (nonatomic, strong, readonly) GDataXMLElement *rootXMLElement;
@property (nonatomic, copy, readonly) NSString *rootXMLElementID;
@property (nonatomic, copy, readonly) NSString *rootXMLElementName;
@property (nonatomic, copy, readonly) NSString *documentRootElementVersion;
@property (nonatomic, strong, readonly) NSArray *visibleArray;      //!< 可视范围（初始数据）
@property (nonatomic, strong) NSMutableDictionary *visibleDict;     //!< 可视范围字典 （处理后得到的数据，value:YES表示可见，NO表示补全，不可见人员）

/**
 *  组织架构 -- 向下查询
 *  @param model 当前组织架构层模型
 *  @return 下一层组织架构数据
 */
- (NSArray *)nextOrgDatasForOrgModel:(OrgModel *)model;




/**
 *  组织架构 -- 向上查询
 *  @param model 当前组织架构层模型
 *  @return 上一层组织架构数据
 */
- (NSArray *)lastOrgDatasForOrgModel:(OrgModel *)model;


/**
 *  通过 JID 查询组织架构
 *  @param jid 待查询JID
 *  @return 查询组织架构数据
 */
+ (OrgModel *)getPersonInfoByJid:(NSString *)jid;



/**
 *  通过indexs、NAME、状态排序
 *  @param sourceArray 待排序数组
 *  @return 已排序数组
 */
+ (NSArray *)sortedArray:(NSArray *)sourceArray;



/**
 *  在线状态排序
 *  @param sourceArray 待排序数组
 *  @return 已排序数组
 */
+ (NSArray *)sortedArrayWithOnlineSatus:(NSArray *)sourceArray;

@end
