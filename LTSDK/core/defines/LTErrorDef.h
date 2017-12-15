//
//  LTErrorDef.h
//  WiseUC
//
//  Created by JH on 2017/12/6.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

/*!
 @enum
 @abstract 枚举值
 @constant LTErrorUnknownError              未知错误(严重)
 @constant LTErrorGeneral                   一般错误
 @constant LTErrorNetworkUnavailable        网络不可用
 @constant LTErrorInvalidAppkey             Appkey无效
 @constant LTErrorInvalidUsername           用户名无效
 @constant LTErrorInvalidPassword           密码无效
 @constant LTErrorInvalidURL                URL无效
 
 
 
 @constant LTErrorLogin_InfDownloadFailure    inf文件下载失败
 
 
 @constant LTErrorUserAlreadyLogin          用户已登录
 @constant LTErrorUserNotLogin              用户未登录
 @constant LTErrorUserAuthenticationFailed  密码验证失败
 @constant LTErrorUserAlreadyExist          用户已存在
 @constant LTErrorUserNotFound              用户不存在
 @constant LTErrorUserIllegalArgument       参数不合法
 @constant LTErrorUserLoginOnAnotherDevice  当前用户在另一台设备上登录
 
 @constant LTErrorUserRLToved               当前用户从服务器端被删掉
 @constant LTErrorUserRegisterFailed        用户注册失败
 @constant LTErrorUpdateApnsConfigsFailed   更新推送设置失败
 @constant LTErrorUserPermissionDenied      用户没有权限做该操作
 @constant LTErrorFetchLoginConfig          登录配置获取失败
 @constant LTErrorLoginTimeOut              登录超时
 @constant LTErrorServerNotReachable        服务器未连接
 
 @constant LTErrorServerTimeout             服务器超时
 @constant LTErrorServerBusy                服务器忙碌
 @constant LTErrorServerUnknownError        未知服务器错误
 @constant LTErrorServerGetDNSConfigFailed  获取DNS设置失败
 @constant LTErrorFileNotFound              文件没有找到
 @constant LTErrorFileInvalid               文件无效
 @constant LTErrorFileUploadFailed          上传文件失败
 
 @constant LTErrorFileDownloadFailed        下载文件失败
 @constant LTErrorMessageInvalid            消息无效
 @constant LTErrorMessageIncludeIllegalContent  消息内容包含不合法信息
 @constant LTErrorMessageTrafficLimit       单位时间发送消息超过上限
 @constant LTErrorMessageEncryption         加密错误
 @constant LTErrorGroupInvalidId            群组ID无效
 @constant LTErrorGroupAlreadyJoined        已加入群组
 
 @constant LTErrorGroupNotJoined            未加入群组
 @constant LTErrorGroupPermissionDenied     没有权限进行群组该操作
 @constant LTErrorGroupMLTbersFull          群成员个数已达到上限
 @constant LTErrorGroupNotExist             群组不存在
 @constant LTErrorChatroomInvalidId         聊天室ID无效
 @constant LTErrorChatroomAlreadyJoined     已加入聊天室
 @constant LTErrorChatroomNotJoined         未加入聊天室
 
 @constant LTErrorChatroomPermissionDenied  没有权限进行该操作
 @constant LTErrorChatroomMLTbersFull       聊天室成员个数达到上限
 @constant LTErrorChatroomNotExist          聊天室不存在
 @constant LTErrorCallInvalidId             实时通话ID无效
 @constant LTErrorCallBusy                  已经在进行实时通话了
 @constant LTErrorCallRLToteOffline         对方不在线
 @constant LTErrorCallConnectFailed         实时通话建立连接失败
 */
typedef enum{
    
    LTErrorUnknownError = -1,         /**未知错误**/
    LTErrorGeneral = 1,               /**一般错误**/
    LTErrorNetworkUnknow,             /**网络未知**/
    
    
    LTErrorInvalidAppkey = 100,       /**Appkey无效**/
    LTErrorInvalidUsername,           /**用户名无效**/
    LTErrorInvalidPassword,           /**密码无效**/
    
    LTErrorLogin_loginGeneralFailure, /**登录一般错误**/
    LTErrorLogin_InfDownloadFailure,  /**inf文件下载失败**/
    LTErrorLogin_loginTimeOut,        /**登录超时**/
    LTErrorLogin_connectFailure,      /**连接失败**/
    LTErrorLogin_connectRefused,      /**连接被拒绝**/
    LTErrorLogin_InvalidUsername,     /**用户名错误**/
    LTErrorLogin_InvalidPassword,     /**密码错误**/
    LTErrorLogin_InvalidIp,           /**服务器地址错误**/
    LTErrorLogin_InvalidPort,         /**服务器地址错误**/
    LTErrorLogin_OrgDownloadFailure,  /**组织架构下载失败**/
    
    
    
    LTErrorUserAlreadyLogin = 200,    /**已经登陆**/
    LTErrorUserNotLogin,              /**未登陆**/
    LTErrorUserAuthenticationFailed,  /**授权失败**/
    LTErrorUserAlreadyExist,          /**用户已存在**/
    LTErrorUserNotFound,              /**用户不存在**/
    LTErrorUserIllegalArgument,       /**参数不合法**/
    LTErrorUserLoginOnAnotherDevice,  /**当前用户在另一台设备上登录**/
    LTErrorUserRLToved,
    LTErrorUserRegisterFailed,
    LTErrorUpdateApnsConfigsFailed,
    LTErrorUserPermissionDenied,
    LTErrorFetchLoginConfig,
    LTErrorLoginTimeOut,
    
    
    
    LTErrorServerNotReachable = 300,
    LTErrorServerTimeout,
    LTErrorServerBusy,
    LTErrorServerUnknownError,
    LTErrorServerGetDNSConfigFailed,
    
    
    LTErrorFileNotFound = 400,
    LTErrorFileInvalid,
    LTErrorFileUploadFailed,
    LTErrorFileDownloadFailed,
    
    
    LTErrorMessageInvalid = 500,
    LTErrorMessageIncludeIllegalContent,
    LTErrorMessageTrafficLimit,
    LTErrorMessageEncryption,
    
    
    LTErrorGroupInvalidId = 600,
    LTErrorGroupAlreadyJoined,
    LTErrorGroupNotJoined,
    LTErrorGroupPermissionDenied,
    LTErrorGroupMLTbersFull,
    LTErrorGroupNotExist,
    
    
    LTErrorChatroomInvalidId = 700,
    LTErrorChatroomAlreadyJoined,
    LTErrorChatroomNotJoined,
    LTErrorChatroomPermissionDenied,
    LTErrorChatroomMLTbersFull,
    LTErrorChatroomNotExist,
    
    
    LTErrorCallInvalidId = 800,
    LTErrorCallBusy,
    LTErrorCallRLToteOffline,
    LTErrorCallConnectFailed,
    
} LTErrorCode;

