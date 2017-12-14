#import "XMPPMessage.h"
@class XMPPJID;
void runCategoryForFramework24();
@interface XMPPMessage (XEP_0280)

- (NSXMLElement *)receivedMessageCarbon;
- (NSXMLElement *)sentMessageCarbon;

- (BOOL)isMessageCarbon;
- (BOOL)isReceivedMessageCarbon;
- (BOOL)isSentMessageCarbon;
- (BOOL)isTrustedMessageCarbon;
- (BOOL)isTrustedMessageCarbonForMyJID:(XMPPJID *)jid;

- (XMPPMessage *)messageCarbonForwardedMessage;

- (void)addPrivateMessageCarbons;

@end
