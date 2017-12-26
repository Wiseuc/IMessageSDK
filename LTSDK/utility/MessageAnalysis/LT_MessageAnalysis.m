//
//  LT_MessageAnalysis.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LT_MessageAnalysis.h"

@implementation LT_MessageAnalysis



+ (NSDictionary *)analysisXMPPMessage:(XMPPMessage *)xmlMessage {


    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *UID  = [xmlMessage attributeForName:@"UID"].stringValue;
    NSString *from = [xmlMessage attributeForName:@"from"].stringValue;
    NSString *to   = [xmlMessage attributeForName:@"to"].stringValue;
    NSString *type = [xmlMessage attributeForName:@"type"].stringValue;
    
    from        = [from componentsSeparatedByString:@"/"].firstObject;
    to          = [to componentsSeparatedByString:@"/"].firstObject;

    [dict setValue:UID forKey:@"UID"];
    [dict setValue:from forKey:@"from"];
    [dict setValue:to forKey:@"to"];
    [dict setValue:type forKey:@"type"];
   
    
    /**我的jid**/
    NSDictionary *userDict = [LTUser.share queryUser];
    NSString *myJID = userDict[@"JID"];  /**江海@duowin-server**/
    [dict setValue:myJID forKey:@"currentMyJID"];
    
    /**对方jid**/
    [dict setValue:from forKey:@"currentOtherJID"];
    
    /**单聊**/
    if ([type isEqualToString:@"chat"])
    {
        //通过jid组织架构获取信息
        NSDictionary *dict02 = [LT_OrgManager queryInformationByJid:from];
        [dict setValue:dict02[@"NAME"] forKey:@"conversationName"];
    }
    /**群聊**/
    else if ([type isEqualToString:@"groupchat"])
    {
        /**发送者jid**/
        NSString *SenderJID  = [xmlMessage attributeForName:@"SenderJID"].stringValue;
        SenderJID = [SenderJID componentsSeparatedByString:@"/"].firstObject;
        [dict setValue:SenderJID forKey:@"SenderJID"];

        /**会话室name**/
        NSString *name = [xmlMessage attributeForName:@"name"].stringValue;
        [dict setValue:name forKey:@"conversationName"];
    }
    
    
    
    
    NSString *body = [xmlMessage elementForName:@"body"].stringValue;
    /**判断文本类型**/
    
    if ( [xmlMessage elementForName:@"voice"] ) {
        return nil;
    }
    if ( [xmlMessage elementForName:@"location"] ) {
        return nil;
    }
    if ( [xmlMessage elementForName:@"offlinedir"] ) {
        return nil;
    }
    if ([body isEqualToString:@""] || body == nil) {
        return nil;
    }
    
    [dict setValue:body forKey:@"body"];
    [dict setValue:@"bodyType_Text" forKey:@"bodyType"];
    
        
    
    // 如果是离线消息，那么需要加上时间，以防止系统自已生成时间
    /**时间戳**/
//    DDXMLElement *_x = [xmlMessage elementForName:@"x"];
//    if([xmlMessage wasDelayed])
//    {
//        [xmlMessage delayedDeliveryDate];
//        NSString *stamp = [_x attributeForName:@"stamp"].stringValue;
//        long long timestamp = [self formatOfflineTimeStampWithTimeString:stamp];
//        [dict setValue:@(timestamp) forKey:@"stamp"];
//    }else{
//        [dict setValue:@([LTXMPPManager.share queryServerTimeStamp]) forKey:@"stamp"];
//    }
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    [dict setValue:dateTime forKey:@"stamp"];
    
    
    
    
    return dict;
}


// 离线消息时间：20160522T13:34:36
+ (long long)formatOfflineTimeStampWithTimeString:(NSString *)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd'T'HH:mm:ss";
    return (long long)[[dateFormatter dateFromString:timeString] timeIntervalSince1970] * 1000 + arc4random_uniform(500);
}

@end
