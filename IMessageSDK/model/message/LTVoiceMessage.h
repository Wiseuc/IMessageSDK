//
//  LTVoiceMessage.h
//  IMessageSDK
//
//  Created by JH on 2018/1/4.
//  Copyright © 2018年 JiangHai. All rights reserved.
//
/**
 chat：
 
 <message
 xmlns="jabber:client"
 UID="E954B3B064DA4C2CB708B071C232F078"
 
 id="86313F56A4254E8787ACF2CF1FD7F9AA"
 to="江海@duowin-server/IphoneIM"
 
 from="萧凡宇@duowin-server/IphoneIM"
 type="chat"
 >
 
 <body>151505714678853.mp3</body>
 <voice>151505714678853.mp3</voice>
 <duration>3</duration>
 </message>
 
 
 groupchat：
 
 <message
 xmlns="jabber:client"
 UID="A19C4CD80F094F139FAE5D4B50D6C3D1"
 
 id="944F0CB633C54017B1880402DAEBF8D5"
 to="江海@duowin-server/IphoneIM"
 
 SenderJID="萧凡宇@duowin-server/IphoneIM"
 name="秘密哦"
 
 from="82eb16e3b6c141ee968c7528cf7ab493@conference.duowin-server/萧凡宇"
 type="groupchat"
 >
 
 
 <body>151505746632075.mp3</body>
 <voice>151505746632075.mp3</voice>
 <duration>4</duration>
 
 <x xmlns="jabber:x:delay" from="82eb16e3b6c141ee968c7528cf7ab493@conference.duowin-server" stamp="20180104T17:17:51"></x>
 </message>

 **/
#import "Message.h"

@interface LTVoiceMessage : Message

//duration
//@property (nonatomic, strong) NSString  *duration;  /**语音时长**/











@end
