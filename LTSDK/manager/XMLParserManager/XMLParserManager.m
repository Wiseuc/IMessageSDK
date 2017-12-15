//
//  XMLParserManager.m
//  XMLParser
//
//  Created by 吴林峰 on 16/4/8.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMLParserManager.h"
#import "LT_Macros.h"
#import "LT_POAPinyin.h"
#import "LTXMPPManager+presence.h"
// 单拎所在部门
#define IsVisibleSingleSection  0







@implementation XMLParserManager

#pragma mark - public

//  组织架构 -- 向下查询
- (NSArray *)nextOrgDatasForOrgModel:(OrgModel *)model {
    if ( model == nil ) {
        //解析第一层
        return [self orgModelsForElement:self.rootXMLElement withModel:model ];
    }else {
        NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=%@]",model.ID];
        GDataXMLElement *element = [_XMLDocument nodesForXPath:xpathString error:nil][0];
        return [self orgModelsForElement:element withModel:model];
    }
}


//  组织架构 -- 向上查询
- (NSArray *)lastOrgDatasForOrgModel:(OrgModel *)model {    
    NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=%@]",model.parentid];
    NSArray *elements = [_XMLDocument nodesForXPath:xpathString error:nil];
    if ( elements.count > 0 ) {
        if ( elements.count > 0 ) {
            return [self orgModelsForElement:elements[0] withModel:model];
        }
    }
    return [self orgModelsForElement:_XMLDocument.rootElement withModel:model];;
}


+ (OrgModel *)getPersonInfoByJid:(NSString *)userJid {
    if ( userJid == nil ) {
        return nil;
    }
    //  登录的用户真正的jid是通过当前的登录名去查找，再存储，替换原来[UserManager shareInstance].currentUser.jid
    NSString *orgXmlFilePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.xml"];
    NSString *dataString = [NSString stringWithContentsOfFile:orgXmlFilePath encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:dataString options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    
    
    NSString *xpath = [NSString stringWithFormat:@"//JID[translate(@JID,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='%@']",[userJid lowercaseString]];
    NSArray *eleArray = [xmlEle nodesForXPath:xpath error:nil];

    if ( eleArray.count > 0 ) {
        
        /**
         GDataXMLElement 0x1c0452de0: {type:1 name:JID xml:"
         
         <JID
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
         title="iOS 开发工程师"
         sex="男"
         leader="0"
         indexs="674"
         />"}
         **/
        xmlEle = eleArray[0];
        OrgModel *orgModel = [[OrgModel alloc] init];
        orgModel.NAME = [[xmlEle attributeForName:kNAME] stringValue];
        orgModel.position = [[xmlEle attributeForName:kTitle] stringValue];
        orgModel.JID = [[xmlEle attributeForName:kJID] stringValue];
        orgModel.PID = [[xmlEle attributeForName:kPID] stringValue];
        orgModel.LoginName = [[xmlEle attributeForName:kLoginName] stringValue];
        orgModel.pinyin = [POAPinyin convert:orgModel.NAME];
        
        return orgModel;
    }
    
    return nil;
}




/**
 排序

 @param sourceArray <#sourceArray description#>
 @return <#return value description#>
 */
+ (NSArray *)sortedArray:(NSArray *)sourceArray {
    NSMutableArray *personIndexCompareArray = [NSMutableArray array];
    NSMutableArray *personNameCompareArray = [NSMutableArray array];
    NSMutableArray *subGroupIndexArray = [NSMutableArray array];
    NSMutableArray *subGroupNameArray = [NSMutableArray array];
    for ( OrgModel *orgModel in sourceArray ) {
        if ( orgModel.orgItemType == OrgItemType_JID ) {
            if ( orgModel.indexs.length > 0 ) {
                [personIndexCompareArray addObject:orgModel];
            }
            else {
                [personNameCompareArray addObject:orgModel];
            }
        }
        else {
            if ( orgModel.indexs.length > 0 ) {
                [subGroupIndexArray addObject:orgModel];
            }
            else {
                [subGroupNameArray addObject:orgModel];
            }
        }
    }
    
    // indexs、NAME排序
    NSArray *personIndexCompareResultArray = [self sortedArray:personIndexCompareArray type:YES];
    NSArray *personNameCompareResultArray = [self sortedArray:personNameCompareArray type:NO];
    NSArray *subGroupIndexResultArray = [self sortedArray:subGroupIndexArray type:YES];
    NSArray *subGroupNameResultArray = [self sortedArray:subGroupNameArray type:NO];
    NSMutableArray *allDatas = [NSMutableArray array];
        NSMutableArray *personCompareResultArray = [NSMutableArray array];
        [personCompareResultArray addObjectsFromArray:personIndexCompareResultArray];
        [personCompareResultArray addObjectsFromArray:personNameCompareResultArray];
        NSArray *presenceSortedArray = [self sortedArrayWithOnlineSatus:personCompareResultArray];
        [allDatas addObjectsFromArray:presenceSortedArray];
//    if ( [UserManager shareInstance].isOrgSortedByPresence ) {
//    }else {
//        [allDatas addObjectsFromArray:personIndexCompareResultArray];
//        [allDatas addObjectsFromArray:personNameCompareResultArray];
//    }
    [allDatas addObjectsFromArray:subGroupIndexResultArray];
    [allDatas addObjectsFromArray:subGroupNameResultArray];
    return allDatas;
}



#pragma mark - private

- (NSArray *)orgModelsForElement:(GDataXMLElement *)currentElement withModel:(OrgModel *)orgModel{
    // 该部门人员是否可见
    BOOL isPIDVisibleForNext = YES;
    if ( YES == [self hasOrgVisible] ) {
        NSString *eleID = [[currentElement attributeForName:kID] stringValue];
        if ( NO == [self isPIDVisibleForNext:eleID] ) {
            isPIDVisibleForNext = NO;
        }
    }
    NSMutableArray *mArray = [NSMutableArray array];
    NSArray *elements = currentElement.children;
    if ( elements.count > 0 ) {
        for ( GDataXMLElement *element in elements ) {
            OrgModel *model = [[OrgModel alloc] init];
            if ( [[[element attributeForName:kITEMTYPE] stringValue] isEqualToString:@"1"] )
            {
                if ( YES == [self hasOrgVisible] )
                {
                    NSString *eleID = [[element attributeForName:kID] stringValue];
                    if ( NO == [self isVisibleForID:eleID] ) {
                        continue;
                    }
                }
                model.parentid = [[element attributeForName:kParentid] stringValue];
                model.itemCount = element.childCount;
            }
            else if ( [[[element attributeForName:kITEMTYPE] stringValue] isEqualToString:@"2"] )
            {
                if ( NO == isPIDVisibleForNext ) {
                    continue;
                }
                model.JID = [[element attributeForName:kJID] stringValue];
                model.LoginName = [[element attributeForName:kLoginName] stringValue];
                model.position = [[element attributeForName:kTitle] stringValue];
            }
            model.ITEMTYPE = [[element attributeForName:kITEMTYPE] stringValue];
            model.NAME = [[element attributeForName:kNAME] stringValue];
            model.ID = [[element attributeForName:kID] stringValue];
            model.PID = [[element attributeForName:kPID] stringValue];
            model.indexs = [[element attributeForName:kIndexs] stringValue];
            model.pinyin = [self transformToPinyin:model.NAME];
         
            if (orgModel) {
                NSMutableArray *parenter = [model.parent mutableCopy];
                [parenter insertObject:orgModel atIndex:0];
                model.parent = [parenter copy];
            }
            [mArray addObject:model];
        }
        return mArray;
    }
    return nil;
}






/**
 汉字转拼音

 @param name <#name description#>
 @return <#return value description#>
 */
- (NSString *)transformToPinyin:(NSString *)name
{
    NSMutableString *mutableString = [NSMutableString stringWithString:name];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin,false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}


/**
 部门节点是否可视

 @param eleID <#eleID description#>
 @return <#return value description#>
 */
- (BOOL)isVisibleForID:(NSString *)eleID {
    if ( YES == [[self.visibleDict allKeys] containsObject:eleID] ) {
        return YES;
    }
    return NO;
}


/**
 该部门节点下的可视状态

 @param eleID <#eleID description#>
 @return <#return value description#>
 */
- (BOOL)isPIDVisibleForNext:(NSString *)eleID {
    NSString *visibleStatus = [self.visibleDict valueForKey:eleID];
    if ( visibleStatus && ([visibleStatus boolValue] == YES)) {
        return YES;
    }
    return NO;
}



// 组织架构可视状态 ( YES:限制可视范围, NO:全部可见 )
- (BOOL)hasOrgVisible {
    if ( self.visibleArray.count > 0 ) {
        return YES;
    }
    return NO;
}

/*
// 限制可视范围组织架构的根节点
- (NSString *)rootElementForVisibleArray {
    if ( [self hasOrgVisible] ) {
        NSMutableArray *eleLevelCountArray = [NSMutableArray array];
        
        for ( NSString *visibleEleID in [self visibleArray] ) {
            
            NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=%@]",visibleEleID];
            NSArray *eleArray = [_XMLDocument nodesForXPath:xpathString error:nil];
            if ( eleArray.count < 1 ) {
                [eleLevelCountArray addObject:@(1000)];
                continue;
            }
            GDataXMLElement *element = eleArray[0];
            xpathString = @"ancestor-or-self::SUBGROUP";
            NSArray *levelArray = [element nodesForXPath:xpathString error:nil];
            // +1 是因为还有根节点ORG
            [eleLevelCountArray addObject:@(levelArray.count + 1)];
        }
        
        NSNumber *min = [eleLevelCountArray valueForKeyPath:@"@min.intValue"];
        if ( [min integerValue] == 1000 )
        {
            return nil;
        }
        
        // 最小层级数的节点有多个，则应该以他们的共同的父节点来做为根节点
        NSArray * minlist = [eleLevelCountArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@",min]];
        NSInteger minIndex = [eleLevelCountArray indexOfObject:min];
        NSInteger minCount = [minlist count];

        if ( minCount > 1 ) {
            NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=%@]",[self visibleArray][minIndex]];
            GDataXMLElement *element = [_XMLDocument nodesForXPath:xpathString error:nil][0];
            NSString *parentid = [[element attributeForName:kParentid] stringValue];
            if ( [parentid isEqualToString:[self documentRootElementID]] ) {
                return parentid;
            }
            
            xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=%@]",parentid];
            element = [_XMLDocument nodesForXPath:xpathString error:nil][0];
            return [[element attributeForName:kID] stringValue];
        }
        
        return [self visibleArray][minIndex];
    }
    return nil;
}
 */

- (NSArray *)getSubgroupParentItem:(NSString *)item {
    NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@PID='%@']/ancestor::*",item];
    NSArray *eleArray = [self.XMLDocument nodesForXPath:xpathString error:nil];
    return eleArray;
}



/**
 indexs,NAME排序

 @param sourceArray <#sourceArray description#>
 @param forIndexs <#forIndexs description#>
 @return <#return value description#>
 */
+ (NSArray *)sortedArray:(NSArray *)sourceArray type:(BOOL)forIndexs {
    if ( sourceArray.count < 2 )
    {
        return sourceArray;
    }
    else
    {
        if ( forIndexs )
        {
            return [sourceArray sortedArrayUsingComparator:^(OrgModel *obj1, OrgModel *obj2) {
                if ([obj1.indexs doubleValue] < [obj2.indexs doubleValue]){
                    return NSOrderedAscending;
                }else if ([obj1.indexs doubleValue] > [obj2.indexs doubleValue]) {
                    return NSOrderedDescending;
                }
                return [obj1.pinyin compare:obj2.pinyin];
            }];
        }
        else
        {
            return [sourceArray sortedArrayUsingComparator:^(OrgModel *obj1, OrgModel *obj2) {
                NSString *name1 = [POAPinyin convert:obj1.NAME];
                NSString *name2 = [POAPinyin convert:obj2.NAME];
                return [name1 compare:name2];
            }];
        }
    }
    return sourceArray;
}





/**
 在线状态排序

 @param sourceArray <#sourceArray description#>
 @return <#return value description#>
 */
+ (NSArray *)sortedArrayWithOnlineSatus:(NSArray *)sourceArray {
    if ( sourceArray.count < 2 ) {
        return sourceArray;
    }
    NSMutableArray *sortedArray = [NSMutableArray array];
    NSInteger lastOnlineIndex = 0;
    for (NSInteger i = 0; i < sourceArray.count; i++) {
        OrgModel *orgModel = sourceArray[i];
        LTPresenceType orgModelPresence = [LTXMPPManager presenceStatuForJID:orgModel.JID];
        
        if ( orgModelPresence != PresenceType_Offline ) {
            [sortedArray insertObject:orgModel atIndex:lastOnlineIndex];
            lastOnlineIndex++;
        }else {
            [sortedArray addObject:orgModel];
        }
    }
    return sortedArray;
}





#pragma mark - getter

- (GDataXMLElement *)rootXMLElement {

#if IsVisibleSingleSection
    // 单拎
    NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=1]"];
    NSArray *elements = [self.XMLDocument nodesForXPath:xpathString error:nil];
    if ( elements.count > 0 ) {
        return elements[0];
    }
    return nil;
#else
    
    // 常规可视范围
    return self.XMLDocument.rootElement;
#endif
    /*
    if ( NO == [self hasOrgVisible] ) {
        return self.XMLDocument.rootElement;
    }
    
    // 组织架构从根节点开始
    NSString *orgRootID = [self documentRootElementID];
    NSArray * eleIDCount = [self.visibleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self == %@",orgRootID]];
    if ( eleIDCount.count > 0 ) {
        return self.XMLDocument.rootElement;
    }
    
    NSString *rootID = [self rootElementForVisibleArray];
    if ( [rootID isEqualToString:orgRootID] ) {
        return self.XMLDocument.rootElement;
    }
    
    NSString *xpathString = [NSString stringWithFormat:@"//SUBGROUP[@ID=%@]",rootID];
    NSArray *eleArray = [self.XMLDocument nodesForXPath:xpathString error:nil];
    if ( eleArray.count > 0 ) {
        return eleArray[0];
    }
    
    return nil;
     */
}

- (GDataXMLDocument *)XMLDocument {
    if ( _XMLDocument == nil ) {
        NSString *dataString = [NSString stringWithContentsOfFile:self.xmlFilePath encoding:NSUTF8StringEncoding error:nil];
        _XMLDocument = [[GDataXMLDocument alloc] initWithXMLString:dataString options:0 error:nil];
    }
    return _XMLDocument;
}

- (NSString *)documentRootElementID {
    return [[self.XMLDocument.rootElement attributeForName:kID] stringValue];
}

- (NSString *)documentRootElementVersion {
    return [[self.XMLDocument.rootElement attributeForName:@"Version"] stringValue];
}

- (NSString *)rootXMLElementName {
    NSString *orgName = [[self.rootXMLElement attributeForName:@"name_ext"] stringValue];
    return orgName;
}

- (NSString *)rootXMLElementID {
    return[[self.rootXMLElement attributeForName:kID] stringValue];
}

- (NSArray *)visibleArray {
    return  @[];//[UserManager shareInstance].currentUser.orgVisibleRangeArray;
}

- (NSMutableDictionary *)visibleDict {
    if ( _visibleDict == nil ) {
        _visibleDict = [NSMutableDictionary dictionary];
        NSArray *visibleArray = [self.visibleArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
        NSMutableArray *filterVisibleArray = [NSMutableArray array];
        for ( id pidObj in visibleArray ) {
            if ( [pidObj isKindOfClass:[NSString class]] ) {
                [filterVisibleArray addObject:pidObj];
            }
        }
        for (NSString *PID in filterVisibleArray) {
            [_visibleDict setObject:@(YES) forKey:PID];
            if ( [PID isEqualToString:@"0"] ) {
                continue;
            }
            NSArray *eleArray = [self getSubgroupParentItem:PID];
            for ( GDataXMLElement *element in eleArray ) {
                NSString *PID = [[element attributeForName:@"PID"] stringValue];
                if ( [PID isEqualToString:@"0"] || [visibleArray containsObject:PID] ) {
                    continue;
                }
                [_visibleDict setObject:@(NO) forKey:[[element attributeForName:@"PID"] stringValue]];
            }
        }
    }
    return _visibleDict;
}



@end
