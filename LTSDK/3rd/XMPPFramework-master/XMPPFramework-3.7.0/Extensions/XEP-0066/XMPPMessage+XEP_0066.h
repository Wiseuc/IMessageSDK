#import "XMPPMessage.h"
void runCategoryForFramework15();
@interface XMPPMessage (XEP_0066)

- (void)addOutOfBandURL:(NSURL *)URL desc:(NSString *)desc;
- (void)addOutOfBandURI:(NSString *)URI desc:(NSString *)desc;

- (BOOL)hasOutOfBandData;

- (NSURL *)outOfBandURL;
- (NSString *)outOfBandURI;
- (NSString *)outOfBandDesc;

@end
