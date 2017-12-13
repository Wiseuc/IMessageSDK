//
//  XMPPManager+receipt.m
//  WiseUC
//
//  Created by 吴林峰 on 16/5/25.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "XMPPManager+receipt.h"
#import "NSData+CRC32.h"
#import "Macros.h"

@implementation XMPPManager (Receipt)

+ (BOOL)messageReceipt:(XMPPMessage *)xmlMessage
{
    NSString *uid = [[xmlMessage attributeForName:kStringXMPPUID] stringValue];
    NSString *packetId = [[xmlMessage attributeForName:kStringXMPPID] stringValue];
    NSString *type = [[xmlMessage attributeForName:kStringXMPPMessageType] stringValue];
    
    if ([type isEqualToString:kStringXMPPMessageConfirm]) {
        return NO;
    }
    
    int32_t _crc32 = 0;
    if ( uid ) {
        _crc32 = [self CRC32:uid];
    }
    else if ( packetId ) {
        _crc32 = [self CRC32:packetId];
    }
    if ( _crc32 == 0 )
    {
        return NO;
    }
    
    NSXMLElement *msg = [NSXMLElement elementWithName:kStringXMPPMessage];
    [msg addAttributeWithName:kStringXMPPMessageType stringValue:kStringXMPPMessageConfirm];
    [msg addAttributeWithName:kStringXMPPMessageHashid stringValue:[NSString stringWithFormat:@"%u",_crc32]];
    [[XMPPManager shareXMPPManager].xmppStream sendElement:msg];
    
    return YES;
}

+ (int32_t)CRC32:(NSString *)sourceString
{
    const char *sourceCString = [sourceString UTF8String];
    NSData *data = [NSData dataWithBytes:sourceCString length:strlen(sourceCString)];
    return [data crc32];
}

@end
