//
//  OcCallCpp.h
//  OC-Cpp
//
//  Created by wangzhen on 15-1-14.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "blowfish.h"

@interface BLowfish_OcCallCpp : NSObject
{
    CBlowFish *blowfish;
}

- (void)set_key:(const BYTE *)key :(int)keybytes;

- (DWORD)Encrypt:(const BYTE *)pInput :(BYTE *)pOutput :(DWORD)lSize :(int)mode :(BYTE *)IV;

- (DWORD)Decrypt:(const BYTE *)pInput :(BYTE *)pOutput :(DWORD)lSize :(int)mode :(BYTE *)IV;

@end
