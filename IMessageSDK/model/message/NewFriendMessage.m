//
//  NewFriendMessage.m
//  IMessageSDK
//
//  Created by JH on 2017/12/26.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "NewFriendMessage.h"
#import "BGFMDB.h"
#define kBGTableName_NewFriendMessage @"kBG_NewFriendMessage"  /**数据库表名**/



@implementation NewFriendMessage
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
    self.bg_tableName = kBGTableName_NewFriendMessage;
    [self bg_saveOrUpdate];
}





#pragma mark - delete

+(void)jh_deleteByCurrentOtherJID:(NSString *)aJID {
    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"currentOtherJID"),bg_sqlValue(aJID)];
    [self bg_delete:kBGTableName_NewFriendMessage where:where];
}
+(void)jh_clear {
    //[self bg_clear:kBG_TableName];
}
+(void)jh_drop {
    //[self bg_drop:kBG_TableName];
}





#pragma mark - query
/*!
 @method
 @abstract 查询数据库中所有记录的jid（去重）
 @param aCurrentMyJID 我的jid
 @result  jid数组
 */
+(NSArray *)jh_queryAllCurrentOtherJIDByCurrentMyJID:(NSString *)aCurrentMyJID {
    NSString *sql =
    [NSString stringWithFormat:@"select distinct BG_currentOtherJID from kBGTableName_NewFriendMessage Where currentMyJID = '%@'",aCurrentMyJID];
    NSArray  *arr03 = bg_executeSql(sql, kBGTableName_NewFriendMessage, [self class]);
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NewFriendMessage *msg in arr03) {
        [arrM addObject:msg.currentOtherJID];
    }
    return arr03;
}




@end
