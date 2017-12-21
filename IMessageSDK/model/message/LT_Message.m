//
//  LT_Message.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LT_Message.h"
#define kBG_TableName @"kBG_TableName"  /**数据库表名**/
@implementation LT_Message

/** 设置唯一约束**/
//+(NSArray *)bg_uniqueKeys{
//    return @[@"name",@"age"];
//}



/** 设置不需要存储的属性*/
//+(NSArray *)bg_ignoreKeys{
//    return @[@"sex1",@"sex2"];
//}



#pragma mark - add
-(void)jh_saveOrUpdate {
    self.bg_tableName = kBG_TableName;
    [self bg_saveOrUpdate];
}








#pragma mark - delete
+(void)jh_deleteByCurrentOtherJID:(NSString *)aJID {
    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"currentOtherJID"),bg_sqlValue(aJID)];
    [self bg_delete:kBG_TableName where:where];
}
+(void)jh_clear {
    [self bg_clear:kBG_TableName];
}

+(void)jh_drop {
    [self bg_drop:kBG_TableName];
}








#pragma mark - query
+(NSArray *)jh_queryAll{
    return [self bg_findAll:kBG_TableName];
}

+(NSArray *)jh_queryByCurentOtherJID:(NSString *)aOtherJID {
    NSString* where =
    [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"currentOtherJID"),bg_sqlValue(aOtherJID)];
    NSArray* arr = [self bg_find:kBG_TableName where:where];
    return arr;
}
+(NSArray *)jh_queryByDistinctCurrentOtherJID {
    
    //NSArray* arr = bg_executeSql(@"select * from yy", kBG_TableName, [People class]);
    
//    NSArray  *arr03 = bg_executeSql(@"select * from kBG_TableName where BG_currentOtherJID = 50", kBG_TableName, [LT_Message class]);
//    select * from Test2 where ID in (select min(ID) from Test2 group by A,B)
    
    NSArray  *arr03 =
    bg_executeSql(@"select distinct BG_currentOtherJID,BG_conversationName,BG_type from kBG_TableName", kBG_TableName, [LT_Message class]);
    return arr03;
}








@end
