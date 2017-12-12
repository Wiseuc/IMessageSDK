//
//  OcCallCpp.m
//  OC-Cpp
//
//  Created by wangzhen on 15-1-14.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "BLowfish_OcCallCpp.h"

@implementation BLowfish_OcCallCpp

- (instancetype)init
{
//    NSLog(@"OcCallCpp init");
    self = [super init];
    if (self) {
        self->blowfish = new CBlowFish();
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"oc call cpp dealloc");
    if (self->blowfish != NULL) {
        delete self->blowfish;
        self->blowfish = NULL;
    }
}

- (void)set_key:(const BYTE *)key :(int)keybytes
{
    self->blowfish->set_key(key, keybytes);
}

- (DWORD)Encrypt:(const BYTE *)pInput :(BYTE *)pOutput :(DWORD)lSize :(int)mode :(BYTE *)IV
{
    return self->blowfish->Encrypt(pInput, pOutput, lSize, BF_CBC|BF_PKCS5,IV);
}

- (DWORD)Decrypt:(const BYTE *)pInput :(BYTE *)pOutput :(DWORD)lSize :(int)mode :(BYTE *)IV
{
    return self->blowfish->Decrypt(pInput, pOutput, lSize, BF_CBC|BF_PKCS5,IV);
}


@end
