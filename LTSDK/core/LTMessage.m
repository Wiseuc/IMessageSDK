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



-(void)queryMesageCompleted:(LTMessage_queryMessageBlock)aBlock {
    _queryMessageBlock = aBlock;
    
    __weak typeof(self) weakself = self;
    [LTXMPPManager.share sendRequestMessageCompleted:^(NSDictionary *dict, LTError *error) {
        if (weakself.queryMessageBlock) {
            weakself.queryMessageBlock(dict, error);
        }
    }];
}


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








@end
