//
//  LTMessageDef.h
//  LTSDK
//
//  Created by JH on 2018/1/4.
//  Copyright © 2018年 JiangHai. All rights reserved.
//



/*
 @brief 会话类型
 @constant LTConversationTypeChat                     单聊会话
 @constant LTConversationTypeGroupChat                群聊会话
 @constant LTConversationTypeChatRoom                 聊天室会话
 @constant LTConversationTypeAttributeGroupChat       属性群聊会话
 */
typedef NS_ENUM(NSInteger, LTConversationType){
    LTConversationTypeChat,
    LTConversationTypeGroupChat,
    LTConversationTypeChatRoom,
    LTConversationTypeAttributeGroupChat
};



/*!
 @enum
 @brief 消息类型
 @constant LTMessageType_Text 文本类型
 @constant LTMessageType_Image 图片类型
 @constant LTMessageType_Video 视频类型
 @constant LTMessageType_Location 位置类型
 @constant LTMessageType_Voice 语音类型
 @constant LTMessageType_File 文件类型
 @constant LTMessageType_Command 命令类型
 @constant LTMessageType_Vibrate 抖动类型
 */
typedef NS_ENUM(NSInteger, LTMessageType) {
    LTMessageType_Text = 1,
    LTMessageType_Image,
    LTMessageType_Video,
    LTMessageType_Location,
    
    LTMessageType_Voice = 5,
    LTMessageType_File,
    LTMessageType_Command,
    LTMessageType_Vibrate
};






/*!
 @enum
 @brief 文件类型
 @constant LTFileType_NoFound    // 文件找不到
 @constant LTFileType_Default    // 其他类型
 @constant LTFileType_Text       // 文本
 @constant LTFileType_Picture    // 图片
 @constant LTFileType_Audio      // 影音
 */
typedef NS_ENUM(NSInteger, LTFileType) {
    LTFileType_NoFound = -1,
    LTFileType_Default,
    LTFileType_Text,
    LTFileType_Picture,
    LTFileType_Audio,
};







