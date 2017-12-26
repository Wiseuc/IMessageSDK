//
//  Message.m
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "Message.h"
#define kBG_TableName @"kBG_TableName"  /**数据库表名**/
@interface Message ()

@property (nonatomic, strong) MessageDBChangeBlock aMessageDBChangeBlock;
@end



@implementation Message





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

/*!
 @method
 @abstract 清空表数据
 */
+(void)jh_clear {
    //[self bg_clear:kBG_TableName];
}

/*!
 @method
 @abstract 删除表
 */
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
 @param aOtherName 对方名字
 */
+(void)jh_deleteMessageByType:(NSString *)aType
                 currentMyJID:(NSString *)aMyJID
               curentOtherJID:(NSString *)aOtherJID
             currentOtherName:(NSString *)aOtherName
{
    NSString* where =
    [NSString stringWithFormat:@"where %@=%@ and %@=%@ and %@=%@ and %@=%@",
     bg_sqlKey(@"type"),bg_sqlValue(aType),
     bg_sqlKey(@"currentMyJID"),bg_sqlValue(aMyJID),
     bg_sqlKey(@"currentOtherJID"),bg_sqlValue(aOtherJID),
     bg_sqlKey(@"from"),bg_sqlValue(aOtherName)
     ];
    [self bg_delete:kBG_TableName where:where];
}


/*!
 @method
 @abstract 删除记录
 @discussion 备注
 @param aCurrentMyJID 我的jid
 @param aCurrentOtherJID 对方jid
 */
+(void)jh_deleteDataByCurrentMyJID:(NSString *)aCurrentMyJID
                   currentOtherJID:(NSString *)aCurrentOtherJID
{
    NSString* where =
    [NSString stringWithFormat:@"where %@=%@ and %@=%@",
     bg_sqlKey(@"currentMyJID"),bg_sqlValue(aCurrentMyJID),
     bg_sqlKey(@"currentOtherJID"),bg_sqlValue(aCurrentOtherJID)
     ];
    [self bg_delete:kBG_TableName where:where];
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


+(NSArray *)jh_queryCurrentOtherJIDByMyJID:(NSString *)aMyJID {
    NSString *sql =
    [NSString stringWithFormat:@"select distinct BG_conversationName from kBG_TableName Where BG_currentMyJID = '%@'",aMyJID];
    NSArray  *arr03 = bg_executeSql(sql, kBG_TableName, [self class]);
    return arr03;
}


+(NSArray *)jh_queryByConversationName:(NSString *)aConversationName {
    
    NSString *sql =
    [NSString stringWithFormat:@"select * From kBG_TableName WHERE BG_conversationName = '%@' ORDER BY BG_stamp ASC;",aConversationName ];
    NSArray  *arr03 = bg_executeSql(sql, kBG_TableName, [self class]);
    return arr03;
}


+(NSArray *)jh_queryByConversationName:(NSString *)aConversationName currentMyJID:(NSString *)aCurrentMyJID {
    NSString *sql =
    [NSString stringWithFormat:@"select * From kBG_TableName WHERE BG_currentMyJID = '%@' and BG_conversationName = '%@' ORDER BY BG_stamp ASC;",aCurrentMyJID, aConversationName];
    NSArray  *arr03 = bg_executeSql(sql, kBG_TableName, [self class]);
    return arr03;
}


+(NSString *)jh_queryConversationNameByJID:(NSString *)aJID myJID:(NSString *)aMyJID {
    NSString *conversationName = nil;
    NSArray *arr = [self jh_queryByCurentOtherJID:aJID];
    
    if (arr.count>0) {
        for (Message *model in arr) {
            if ([model.currentOtherJID isEqualToString:aJID]) {
                conversationName = model.conversationName;
            }
        }
    }
    return conversationName;
}













#pragma mark - 监听
/**
 注册监听bg_tablename表的数据变化，唯一识别标识是@"change".
 */
+(void)settingDBOberser:(MessageDBChangeBlock)aBlock {
    
    [self bg_registerChangeForTableName:kBG_TableName identify:@"change" block:^(bg_changeState result) {
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
    [self bg_removeChangeForTableName:kBG_TableName identify:@"change"];
}





@end
