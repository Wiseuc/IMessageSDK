#import "XMPPMessage.h"
void runCategoryForFramework26();
@interface XMPPMessage (XEP_0308)

- (BOOL)isMessageCorrection;

- (NSString *)correctedMessageID;

- (void)addMessageCorrectionWithID:(NSString *)messageCorrectionID;

- (XMPPMessage *)generateCorrectionMessageWithID:(NSString *)elementID;
- (XMPPMessage *)generateCorrectionMessageWithID:(NSString *)elementID body:(NSString *)body;

@end
