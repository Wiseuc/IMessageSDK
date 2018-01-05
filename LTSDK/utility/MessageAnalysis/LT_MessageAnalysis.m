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
    //第一组
    //xmlns
    NSString *UID  = [xmlMessage attributeForName:@"UID"].stringValue;
    
    
    //第二组
    //id
    NSString *to   = [xmlMessage attributeForName:@"to"].stringValue;
    
    
    //第三组
    NSString *from = [xmlMessage attributeForName:@"from"].stringValue;
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
        
        //第四组
        /**会话室name**/
        NSString *name = [xmlMessage attributeForName:@"name"].stringValue;
        [dict setValue:name forKey:@"conversationName"];
        
        /**发送者jid**/
        NSString *SenderJID  = [xmlMessage attributeForName:@"SenderJID"].stringValue;
        SenderJID = [SenderJID componentsSeparatedByString:@"/"].firstObject;
        [dict setValue:SenderJID forKey:@"SenderJID"];
    }
    
    
    //所有消息都有
    NSString *body = [xmlMessage elementForName:@"body"].stringValue;
    [dict setValue:body forKey:@"body"];
    
    
    //声音
    if ( [xmlMessage elementForName:@"voice"] )
    {
        NSString *duration = [[xmlMessage elementForName:@"duration"] stringValue];
        [dict setObject:duration forKey:@"duration"];
        [dict setObject:@"voice" forKey:@"bodyType"];
        //音频文件地址，由xxx+body拼接而成
        
        
    }
    //位置
    else if ([xmlMessage elementForName:@"location"])
    {
        [dict setObject:@"location" forKey:@"bodyType"];
    }
    //文件
    else if ( [xmlMessage elementForName:@"offlinedir"] )
    {
        [dict setObject:@"file" forKey:@"bodyType"];
    }
    else
    {
        //图片
        if ([body hasPrefix:@"<i@"] && [body hasSuffix:@">"] && ![body hasSuffix:@"gif>"])
        {
            [dict setObject:@"image" forKey:@"bodyType"];
        }
        //震动^SOS
        else if ([body containsString:@"^SOS"])
        {
             [dict setObject:@"vibrate" forKey:@"bodyType"];
        }
        //普通文本和表情😊（在XMFaceManager中有方法将文本转face）
        else
        {
            [dict setObject:@"text" forKey:@"bodyType"];
        }
    }
    
    
    
    
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



#pragma mark - Private

// 离线消息时间：20160522T13:34:36
+ (long long)formatOfflineTimeStampWithTimeString:(NSString *)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd'T'HH:mm:ss";
    return (long long)[[dateFormatter dateFromString:timeString] timeIntervalSince1970] * 1000 + arc4random_uniform(500);
}

// 是否为图片内容
//+ (BOOL)isKindOfPictureMessage:(NSString *)bodyStr
//{
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
//    NSArray *arr = [bodyStr componentsSeparatedByCharactersInSet:set];
//
//    return [bodyStr hasPrefix:@"<i@"] && [bodyStr hasSuffix:@">"] && ![XMFaceManager hasEmotionStrWithString:bodyStr] && arr.count < 4;
//}



@end
