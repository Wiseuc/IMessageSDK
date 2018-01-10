//
//  LTMessage.m
//  LTSDK
//
//  Created by JH on 2017/12/20.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "LTMessage.h"
#import "LTXMPPManager+message.h"
@interface LTMessage ()
@property (nonatomic, strong) LTMessage_queryMessageBlock queryMessageBlock;
@end




@implementation LTMessage

+ (instancetype)share {
    static LTMessage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LTMessage alloc] init];
    });
    return instance;
}


/*!
 @method
 @abstract 请求服务器消息
 @discussion 监听服务器消息，回调返回消息
 */
-(void)queryMesageCompleted:(LTMessage_queryMessageBlock)aBlock {
    _queryMessageBlock = aBlock;
    
    __weak typeof(self) weakself = self;
    [LTXMPPManager.share sendRequestMessageCompleted:^(NSDictionary *dict, LTError *error) {
        
        NSMutableDictionary *dictM = [dict mutableCopy];
        //根据信息类型（语音、文件、图片），赋予不同的远程下载地址，和本地地址
        NSString *bodyType = dict[@"bodyType"];
        NSString *body = dict[@"body"];
        
        if ([bodyType isEqualToString:@"text"])
        {
            
        }
        else if ([bodyType isEqualToString:@"voice"])
        {
            NSString *remotePath =
            [weakself queryDownloadRemotePathWithMessageType:(LTMessageType_Voice) fileName:body];
            [dictM setObject:remotePath forKey:@"remotePath"];
            //传过来的语音没有本地地址
            //[dictM setObject:nil forKey:@"localPath"];
        }
        else if ([bodyType isEqualToString:@"file"])
        {

            
            
        }
        
        else if ([bodyType isEqualToString:@"image"])
        {
            NSString *remotePath =
            [weakself queryDownloadRemotePathWithMessageType:(LTMessageType_Image) fileName:body];
            [dictM setObject:remotePath forKey:@"remotePath"];
            //传过来的图片没有本地地址
            //[dictM setObject:nil forKey:@"localPath"];
        }
        else if ([bodyType isEqualToString:@"vibrate"])
        {
            
        }
        else if ([bodyType isEqualToString:@"video"])
        {
            
        }
        else if ([bodyType isEqualToString:@"location"])
        {
            
        }
        if (weakself.queryMessageBlock) {
            weakself.queryMessageBlock(dictM, error);
        }
    }];
}











/*!
 @method
 @abstract 发送Text信息
 @discussion 备注
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（Text）
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendTextWithSenderJID:(NSString *)aSenderJID
                              otherJID:(NSString *)aOtherJID
                      conversationName:(NSString *)aConversationName
                      conversationType:(LTConversationType)aConversationType
                           messageType:(LTMessageType)aMessageType
                                  body:(NSString *)aBody {
    return [LTXMPPManager.share sendTextWithSenderJID:aSenderJID
                                             otherJID:aOtherJID
                                     conversationName:(NSString *)aConversationName
                                     conversationType:aConversationType
                                          messageType:aMessageType
                                                 body:aBody];
}




/*!
 @method
 @abstract 发送Voice信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（voice）
 @param aLocalPath voice本地路径
 @param aDuration voice时长
 @param aBody 信息
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendVoiceWithSenderJID:(NSString *)aSenderJID
                               otherJID:(NSString *)aOtherJID
                       conversationName:(NSString *)aConversationName
                       conversationType:(LTConversationType)aConversationType
                            messageType:(LTMessageType)aMessageType
                              localPath:(NSString *)aLocalPath
                               duration:(NSString *)aDuration
                                   body:(NSString *)aBody {
    //voice远程路径
    NSString *aRemotePath = [self queryUploadFileRemotePathWithMessageType:aMessageType];
    return [LTXMPPManager.share sendVoiceWithSenderJID:aSenderJID
                                              otherJID:aOtherJID
                                      conversationName:aConversationName
                                      conversationType:aConversationType
                                           messageType:aMessageType
                                             localPath:aLocalPath
                                            remotePath:aRemotePath
                                              duration:aDuration
                                                  body:aBody];
}


/*!
 @method
 @abstract 发送image信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（voice）
 @param aBody image信息名字：例如45485454456456456.png
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendImageWithSenderJID:(NSString *)aSenderJID
                               otherJID:(NSString *)aOtherJID
                       conversationName:(NSString *)aConversationName
                       conversationType:(LTConversationType)aConversationType
                            messageType:(LTMessageType)aMessageType
                              localPath:(NSString *)aLocalPath
                                   body:(NSString *)aBody {
    //voice远程路径
    NSString *aRemotePath = [self queryUploadFileRemotePathWithMessageType:aMessageType];
    return [LTXMPPManager.share sendImageWithSenderJID:aSenderJID
                                              otherJID:aOtherJID
                                      conversationName:aConversationName
                                      conversationType:aConversationType
                                           messageType:aMessageType
                                             localPath:aLocalPath
                                            remotePath:aRemotePath
                                                  body:aBody];
}

/*!
 @method
 @abstract 发送file信息
 @discussion <#备注#>
 @param aSenderJID 发送者JID
 @param aOtherJID 接收者JID
 @param aConversationType 会话类型
 @param aMessageType 信息类型（file）
 @param aBody file信息名字：例如45485454456456456.rar
 @result  返回消息字典Dict
 */
-(NSDictionary *)sendFileWithSenderJID:(NSString *)aSenderJID
                              otherJID:(NSString *)aOtherJID
                      conversationName:(NSString *)aConversationName
                      conversationType:(LTConversationType)aConversationType
                           messageType:(LTMessageType)aMessageType
                             localPath:(NSString *)aLocalPath
                                  size:(NSString *)aSize
                                  body:(NSString *)aBody {
    
    //voice远程路径
    NSString *aRemotePath = [self queryUploadFileRemotePathWithMessageType:aMessageType];
    return [LTXMPPManager.share sendFileWithSenderJID:aSenderJID
                                             otherJID:aOtherJID
                                     conversationName:aConversationName
                                     conversationType:aConversationType
                                          messageType:aMessageType
                                            localPath:aLocalPath
                                           remotePath:aRemotePath
                                                 size:aSize
                                                 body:aBody];
    
    
    
    
}












#pragma mark - Private

/*!
 @method
 @abstract
 @discussion 获取上传文件的远程地址
 @param aMessageType 根据信息的类型（Image、Voice、File）
 @result  上传地址
 */
- (NSString *)queryUploadFileRemotePathWithMessageType:(LTMessageType)aMessageType {
    NSDictionary *loginDict = [LTLogin.share queryLastLoginUser];
    NSString *aIP = loginDict[@"aIP"];
    
    NSString *remotePath = nil;
    NSString *serverIP = aIP;
    NSString *port = @"14131";
    switch ( aMessageType ) {
        case LTMessageType_Image:
            remotePath = [NSString stringWithFormat:@"http://%@:%@/uppicture.php",serverIP,port];
            break;
            
        case LTMessageType_Voice:
            remotePath = [NSString stringWithFormat:@"http://%@:%@/upvoice.php",serverIP,port];
            break;
            
        case LTMessageType_File:
            remotePath = [NSString stringWithFormat:@"http://%@:%@/uploadOfflineFile.php",serverIP,port];
            break;
            
        default:
            break;
    }
    return remotePath;
}


/*!
 @method
 @abstract 获取文件的下载地址
 @discussion 根据信息的类型和文件名字
 @param aMessageType 信息类型
 @param aFileName 文件名
 @result  下载地址
 */
- (NSString *)queryDownloadRemotePathWithMessageType:(LTMessageType)aMessageType
                                            fileName:(NSString *)aFileName
{
    NSDictionary *loginDict = [LTLogin.share queryLastLoginUser];
    NSString *aIP = loginDict[@"aIP"];
    
    NSString *remotePath = nil;
    NSString *serverIP = aIP;
    NSString *port = @"14131";
    NSString *fileName = aFileName;
    switch ( aMessageType ) {
        case LTMessageType_Image:
            remotePath = [NSString stringWithFormat:@"http://%@:%@/roompicture/%@",serverIP,port,fileName];
            break;
            
        case LTMessageType_Voice:
            remotePath = [NSString stringWithFormat:@"http://%@:%@/roomvoice/%@",serverIP,port,fileName];
            break;
            
        case LTMessageType_File:
            //为应对外网是由内网映射的情况，将下载路径改为相对路径
            //remotePath = [NSString stringWithFormat:@"http://%@:%@/offlinefile/%@",serverIP,port,fileName];
            remotePath = [NSString stringWithFormat:@"offlinefile/%@",fileName];
            break;
            
        default:
            break;
    }
    return remotePath;
}


@end
