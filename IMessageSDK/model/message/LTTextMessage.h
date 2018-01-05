//
//  LTTextMessage.h
//  IMessageSDK
//
//  Created by JH on 2018/1/4.
//  Copyright © 2018年 JiangHai. All rights reserved.
//
/**
 文本消息：
 
 <message
 xmlns="jabber:client"
 UID="b20b1a2a994b4cfb9447da57edec33db"
 
 id="ObASN-12"
 to="江海@duowin-server/IphoneIM"
 
 from="萧凡宇@duowin-server/AndroidIM"
 type="chat">
 
 <body>啊啊啊啊</body>
 <thread>2284edcd-dd18-489c-992f-54f2daf328e9</thread>
 </message>
 **/


/**
 群组消息：
 
 <message
 xmlns="jabber:client"
 UID="8282f8ad82bb4254864e082ae5d489f1"
 

 id="ObASN-19"
 to="江海@duowin-server/IphoneIM"
 
 name="萧凡宇,江海"
 SenderJID="萧凡宇@duowin-server/AndroidIM"
 
 from="fd3f752ffdfe4c5cbb26e818c6ca6f4c@conference.duowin-server/萧凡宇"
 type="groupchat"
 >
 
 <body>摸摸弄</body>
 <x xmlns="jabber:x:delay" from="fd3f752ffdfe4c5cbb26e818c6ca6f4c@conference.duowin-server" stamp="20171220T11:53:20"></x>
 </message>
 **/

#import "Message.h"

@interface LTTextMessage : Message


@end
