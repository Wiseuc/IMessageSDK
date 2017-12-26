//
//  NewRosterMessage.m
//  IMessageSDK
//
//  Created by JH on 2017/12/26.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "NewRosterMessage.h"
#import "BGFMDB.h"
#define kBGTableName_NewRosterMessage @"kBGTableName_NewRosterMessage"  /**数据库表名**/






@implementation NewRosterMessage
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
    self.bg_tableName = kBGTableName_NewRosterMessage;
    [self bg_saveOrUpdate];
}













#pragma mark - delete

+(void)jh_deleteByCurrentOtherJID:(NSString *)aJID {
    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"currentOtherJID"),bg_sqlValue(aJID)];
    [self bg_delete:kBGTableName_NewRosterMessage where:where];
}
+(void)jh_clear {
    //[self bg_clear:kBG_TableName];
}
+(void)jh_drop {
    //[self bg_drop:kBG_TableName];
}
/*!
 @method
 @abstract 删除信息
 @discussion 删除好友请求，群组请求。。。
 @param aType （好友请求／群组请求）
 @param aMyJID 我的jid
 @param aOtherJID 对方jid
 */
+(void)jh_deleteMessageByType:(NSString *)aType
                 currentMyJID:(NSString *)aMyJID
               curentOtherJID:(NSString *)aOtherJID
{
    NSString* where =
    [NSString stringWithFormat:@"where %@=%@ and %@=%@ and %@=%@",
     bg_sqlKey(@"type"),bg_sqlValue(aType),
     bg_sqlKey(@"currentMyJID"),bg_sqlValue(aMyJID),
     bg_sqlKey(@"currentOtherJID"),bg_sqlValue(aOtherJID)
     ];
    [self bg_delete:kBGTableName_NewRosterMessage where:where];
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
//[NSString stringWithFormat:@"select  distinct BG_currentOtherJID,BG_currentMyJID, BG_body, BG_from, BG_type from kBGTableName_NewRosterMessage Where BG_currentMyJID = '%@';",aCurrentMyJID];
    [NSString stringWithFormat:@"select  distinct BG_currentOtherJID from kBGTableName_NewRosterMessage Where BG_currentMyJID = '%@';",aCurrentMyJID];
    NSArray  *arr03 = bg_executeSql(sql, kBGTableName_NewRosterMessage, [self class]);
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NewRosterMessage *msg in arr03) {
        [arrM addObject:msg.currentOtherJID];
    }
    return arrM;
}












#pragma mark - 监听
/**
 注册监听bg_tablename表的数据变化，唯一识别标识是@"change".
 */
+(void)settingDBOberser:(NewRosterMessageDBChangeBlock)aBlock {
    
    [self bg_registerChangeForTableName:kBGTableName_NewRosterMessage identify:@"change" block:^(bg_changeState result) {
        //        switch (result) {
        //            case bg_insert:
        //                NSLog(@"有数据插入");
        //                break;
        //            case bg_update:
        //                NSLog(@"有数据更新");
        //                break;
        //            case bg_delete:
        //                NSLog(@"有数据删删除");
        //                break;
        //            case bg_drop:
        //                NSLog(@"有表删除");
        //                break;
        //            default:
        //                break;
        //        }
        
        if (aBlock) {
            aBlock();
        }
    }];
}

/**
 移除bg_tablename表数据变化的监听，唯一识别标识是@"change".
 */
+(void)unsettingDBOberser{
    [self bg_removeChangeForTableName:kBGTableName_NewRosterMessage identify:@"change"];
}




@end
