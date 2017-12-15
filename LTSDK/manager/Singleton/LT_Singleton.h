//
//  Singleton.h
//  Foundation
//
//  Created by DarrenKong on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Foundation_Singleton_h
#define Foundation_Singleton_h

#undef	SINGLETON_DECLAR
#define SINGLETON_DECLAR( __class ) \
+ (__class *)shareInstance;

#undef	SINGLETON_DEFINE
#define SINGLETON_DEFINE( __class ) \
+ (__class *)shareInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}
#endif

id class_getSingleton(Class clazz);

#define singleton(clazz) class_getSingleton([clazz class])
