#import <Foundation/Foundation.h>
#import "XMPPMessage.h"
void runCategoryForFramework21();

@interface XMPPMessage (XEP_0184)

- (BOOL)hasReceiptRequest;
- (BOOL)hasReceiptResponse;
- (NSString *)receiptResponseID;
- (XMPPMessage *)generateReceiptResponse;

- (void)addReceiptRequest;

@end
