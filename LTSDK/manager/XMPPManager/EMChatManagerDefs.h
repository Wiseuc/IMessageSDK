/*!
 @header EMChatManagerDefs.h
 @abstract ChatManager相关宏定义
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#ifndef EaseMobClientSDK_EMChatManagerDefs_h
#define EaseMobClientSDK_EMChatManagerDefs_h

//#import "commonDefs.h"
#import "EMPushManagerDefs.h"
#import "EMGroupManagerDefs.h"

/*!
 @enum
 @brief 消息类型
 @constant eMessageBodyType_Text 文本类型
 @constant eMessageBodyType_Image 图片类型
 @constant eMessageBodyType_Video 视频类型
 @constant eMessageBodyType_Location 位置类型
 @constant eMessageBodyType_Voice 语音类型
 @constant eMessageBodyType_File 文件类型
 @constant eMessageBodyType_Command 命令类型
 @constant eMessageBodyType_Vibrate 抖动类型
 */
typedef NS_ENUM(NSInteger, MessageBodyType) {
    eMessageBodyType_Text = 1,
    eMessageBodyType_Image,
    eMessageBodyType_Video,
    eMessageBodyType_Location,
    eMessageBodyType_Voice,
    eMessageBodyType_File,
    eMessageBodyType_Command,
    eMessageBodyType_Vibrate
};

/*!
 @enum
 @brief 聊天消息发送状态
 @constant eMessageDeliveryState_Pending 待发送
 @constant eMessageDeliveryState_Delivering 正在发送
 @constant eMessageDeliveryState_Delivered 已发送, 成功
 @constant eMessageDeliveryState_Failure 已发送, 失败
 */
typedef NS_ENUM(NSInteger, MessageDeliveryState) {
    eMessageDeliveryState_Pending = 10,
    eMessageDeliveryState_Delivering, 
    eMessageDeliveryState_Delivered, 
    eMessageDeliveryState_Failure
};

/*!
 @brief 消息回执类型
 @constant eReceiptTypeRequest   回执请求
 @constant eReceiptTypeResponse  回执响应
 */
typedef NS_ENUM(NSInteger, EMReceiptType){
    eReceiptTypeRequest  = 0,
    eReceiptTypeResponse,
};

/*
@brief 会话类型
@constant eConversationTypeChat                     单聊会话
@constant eConversationTypeGroupChat                群聊会话
@constant eConversationTypeChatRoom                 聊天室会话
@constant eConversationTypeAttributeGroupChat       属性群聊会话
*/
typedef NS_ENUM(NSInteger, EMConversationType){
    eConversationTypeChat,
    eConversationTypeGroupChat,
    eConversationTypeChatRoom,
    eConversationTypeAttributeGroupChat
};

/*!
 @enum
 @brief 文件消息（发送，下载）状态
 @constant eFileMessageState_UploadPending      待发送
 @constant eFileMessageState_Uploading          正在发送
 @constant eFileMessageState_UploadSuccess      已发送, 成功
 @constant eFileMessageState_UploadFailure      已发送, 失败
 @constant eFileMessageState_DownloadPending    待下载
 @constant eFileMessageState_Downloading        正在下载
 @constant eFileMessageState_DownloadSuccess    已下载, 成功
 @constant eFileMessageState_DownloadFailure    已下载, 失败
 */

typedef NS_ENUM(NSInteger, FileMessageState) {
    eFileMessageState_UploadPending = 0,
    eFileMessageState_Uploading,
    eFileMessageState_UploadSuccess,
    eFileMessageState_UploadFailure,
    eFileMessageState_DownloadPending,
    eFileMessageState_Downloading,
    eFileMessageState_DownloadSuccess,
    eFileMessageState_DownloadFailure
};

/*!
 @enum
 @brief 文件传输方式
 @constant eFileTransferType_HTTP          HTTP
 @constant eFileTransferType_FTP           FTP
 */
typedef NS_ENUM(NSInteger, FileTransferType) {
    eFileTransferType_HTTP,
    eFileTransferType_FTP
};

/*!
 @enum
 @brief 文件传输方式
 @constant eFileLoadType_Download           下载
 @constant eFileLoadType_Upload             上传
 */
typedef NS_ENUM(NSInteger, FileLoadType) {
    eFileLoadType_Download,
    eFileLoadType_Upload
};


/*!
 @enum
 @brief 文件类型
 @constant eFileType_NoFound    // 文件找不到
 @constant eFileType_Default    // 其他类型
 @constant eFileType_Text       // 文本
 @constant eFileType_Picture    // 图片
 @constant eFileType_Audio      // 影音
 */
typedef NS_ENUM(NSInteger, FileType) {
    eFileType_NoFound = -1,
    eFileType_Default,
    eFileType_Text,
    eFileType_Picture,
    eFileType_Audio,
};

/*!
 @enum
 @brief 信息来源
 @constant eXMPPMessageSourceType_AndroidIM          HTTP
 @constant XMPPMessageSourceType_iOSIM           FTP
 */
typedef NS_ENUM(NSInteger, XMPPMessageSourceType) {
     eXMPPMessageSourceType_iOSIM,
    eXMPPMessageSourceType_AndroidIM,
    eXMPPMessageSourceType_PC
};

/*!
 @enum
 @brief 添加好友处理状态
 @constant eNewFriendState_None             未处理
 @constant eNewFriendState_Agreed           已接受
 @constant eNewFriendState_Refused          已拒绝
 */
typedef NS_ENUM(NSInteger, NewFriendState) {
    eNewFriendState_None,
    eNewFriendState_Agreed,
    eNewFriendState_Refused
};

/*!
 @enum
 @brief 添加好友处理状态
 @constant eNewFriendState_None             未处理
 @constant eNewFriendState_Agreed           已接受
 @constant eNewFriendState_Refused          已拒绝
 */
typedef NS_ENUM(NSInteger, DealwithGroupRequestState) {
    eDealwithGroupRequestState_None,
    eDealwithGroupRequestState_Agreed,
    eDealwithGroupRequestState_Refused
};

/*!
 @enum
 @brief 备份消息状态
 @constant eBackupMessagesStatusNone        初始状态
 @constant eBackupMessagesStatusFormatting  格式化消息
 @constant eBackupMessagesStatusCompressing 压缩消息
 @constant eBackupMessagesStatusUploading   上传消息
 @constant eBackupMessagesStatusUpdating    更新云端备份
 @constant eBackupMessagesStatusCancelled   取消备份
 @constant eBackupMessagesStatusFailed      备份失败
 @constant eBackupMessagesStatusSucceeded   备份成功
 */
typedef NS_ENUM(NSInteger, EMBackupMessagesStatus) {
    eBackupMessagesStatusNone = 0,
    eBackupMessagesStatusFormatting,
    eBackupMessagesStatusCompressing,
    eBackupMessagesStatusUploading,
    eBackupMessagesStatusUpdating,
    eBackupMessagesStatusCancelled,
    eBackupMessagesStatusFailed,
    eBackupMessagesStatusSucceeded,
};

/*!
 @enum
 @brief 恢复备份消息状态
 @constant eRestoreBackupStatusNone             初始状态
 @constant eRestoreBackupStatusDownload         备份下载
 @constant eRestoreBackupStatusDecompressing    解压缩
 @constant eRestoreBackupStatusImporting        导入
 @constant eRestoreBackupStatusCancelled        取消恢复
 @constant eRestoreBackupStatusFailed           恢复备份失败
 @constant eRestoreBackupStatusSucceeded         恢复备份成功
 */
typedef NS_ENUM(NSInteger, EMRestoreBackupStatus) {
    eRestoreBackupStatusNone = 0,
    eRestoreBackupStatusDownloading,
    eRestoreBackupStatusDecompressing,
    eRestoreBackupStatusImporting,
    eRestoreBackupStatusCancelled,
    eRestoreBackupStatusFailed,
    eRestoreBackupStatusSucceeded,
};


/**
 阅读即焚，消息焚烧状态

 - EMessageBurnStatus_None:    未焚烧
 - EMessageBurnStatus_Burning: 正在焚烧
 - EMessageBurnStatus_Burned:  已焚烧
 */
typedef NS_ENUM(NSInteger, EMessageBurnStatus) {
    EMessageBurnStatus_None = 0,
    EMessageBurnStatus_Burning,
    EMessageBurnStatus_Burned
};

#endif
