//
//  SingletonManager.m
//  Foundation
//
//  Created by DarrenKong on 13-3-19.
//
//

#import "LT_Singleton.h"

@interface ISingletonFactory : NSObject

+ (ISingletonFactory*) shareFactory;

-(id)singletonForClass:(Class)cls;

@end

@interface ISingletonFactory()
@property(nonatomic)NSMutableDictionary     *singletons;
@end
@implementation ISingletonFactory
@synthesize singletons;
+ (ISingletonFactory*) shareFactory
{
    static ISingletonFactory* share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ISingletonFactory alloc] init];
        share->singletons = [[NSMutableDictionary alloc] init];
    });
    return share;
}

-(id)singletonForClass:(Class)clazz
{
    NSString* clsname = NSStringFromClass(clazz);
    @synchronized(singletons)
    {
        id shareData = [singletons objectForKey:clsname];
        if (shareData == nil) {
            shareData = [[clazz alloc] init];
            if (shareData) [singletons setObject:shareData forKey:clsname];
        }
        return shareData;
    }
    return nil;
}

id class_getSingleton(Class clazz)
{
    return [[ISingletonFactory shareFactory] singletonForClass:clazz];
}

@end
