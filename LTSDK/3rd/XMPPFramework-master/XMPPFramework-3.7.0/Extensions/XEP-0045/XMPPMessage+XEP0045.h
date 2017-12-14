#import <Foundation/Foundation.h>
#import "XMPPMessage.h"
void runCategoryForFramework11();

@interface XMPPMessage(XEP0045)

- (BOOL)isGroupChatMessage;
- (BOOL)isGroupChatMessageWithBody;
- (BOOL)isGroupChatMessageWithSubject;

@end
