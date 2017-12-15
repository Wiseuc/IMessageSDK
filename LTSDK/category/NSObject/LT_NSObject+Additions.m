//
//  NSObject+Additions.m
//  IEMAA
//
//  Created by Mr. Wang on 12-10-9.
//
//

#import "LT_NSObject+Additions.h"
#import "LT_NSMutableString+ReplacingOccurencesOfString.h"
//void runCategoryForFramework();
void runCategoryForFramework39(){}
@implementation NSObject(Additions)

+ (NSString *)textForString:(NSString *)string
{
    return [NSObject isEmpty:string]?@"":string;
}

+ (NSString *)createStringByAddingPercentEscapes4String:(NSString *)original;
{
    NSString *encoded_value = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         NULL,
                                                         (CFStringRef)original,
                                                         NULL,
                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                         kCFStringEncodingUTF8)
     autorelease];
    return encoded_value;
}

+ (id)objectForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary espectedType:(Class)clazz
{
    id obj = [NSObject objectForKey:key inDictionary:dictionary];
    
    //如果是空值，那么需要转换一下下，返回对应默认类型的空值
    if([NSObject isEmpty:obj])
    {
        obj = [NSObject defaultValueForType:clazz];
    }
    else //如果不是空值
    {
        //检验一下结果类型是不是符合
        if(![[obj class] isSubclassOfClass:clazz])
        {
            NSLog(@"[%@]需要的类型是[%@]而获取到的数据类型是[%@]，值为[%@]", key, NSStringFromClass(clazz), NSStringFromClass([obj class]), obj);
            obj = [NSObject defaultValueForType:clazz];
        }
    }
    
    return obj;
}

+ (id)defaultValueForType:(Class)clazz
{
    id obj = nil;
    
    if([[clazz class] isSubclassOfClass:[NSArray class]])
    {
        obj = [NSMutableArray arrayWithCapacity:10];
    }
    else if([[clazz class] isSubclassOfClass:[NSDictionary class]])
    {
        obj = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    else if([[clazz class] isSubclassOfClass:[NSString class]])
    {
        obj = [NSMutableString stringWithCapacity:10];
    }
    
    return obj;
}

+ (id)objectForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary
{
    //dictionary为空，则返回空字符串
    if(dictionary == nil)
        return @"";

    if(![dictionary isKindOfClass:[NSDictionary class]])
    {
        return @"";
    }
    
    //dictionary不含key键，则返回空字符串
    if(![[dictionary allKeys] containsObject:key])
        return @"";
    
    id value = [dictionary objectForKey:key];
    
    //如果key对应的值为空类型，则返回空字符串
    if([value isKindOfClass:[NSNull class]])
        return @"";
    
    if([value isKindOfClass:[NSString class]])
    {
        //如果key对应的值中含有null或nil（不区分大小写），则返回空字符串
        NSArray *nulls = [[NSArray alloc] initWithObjects:@"null", @"none", nil];
        for(NSString *null in nulls)
        {
            if([value rangeOfString:null options:NSCaseInsensitiveSearch].length==[null length])
            {
                value = @"";
                break;
            }
        }
        
        [nulls release];
    }
    
    //如果以上情况都不成立，那我们就可以得到正确的字符串类型的值了
    return value;
}

+ (BOOL)isEmpty:(id)object
{
    BOOL isEmpty = YES;
    if(object && object!=nil)
    {
        if([object isKindOfClass:[NSString class]])
        {
            if(![@"" isEqualToString:[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]])
            {
                isEmpty = NO;
            }
        }
        else if([object isKindOfClass:[NSArray class]])
        {
            if([object count]>0)
            {
                isEmpty = NO;
            }
        }
        else if([object isKindOfClass:[NSDictionary class]])
        {
            if([[object allKeys] count]>0)
            {
                isEmpty = NO;
            }
        }
        else isEmpty = NO;
    }
    
    return isEmpty;
}

+ (id)confuse:(id)object
{
    // 不解释
    if(!object || object==nil)
        return nil;
    
    //检查是否支持支持可变方法, appendString:是可变字符串的方法，removeAllObjects是可变数组的方法
    if(   [object respondsToSelector:@selector(appendString:)]
       || [object respondsToSelector:@selector(removeAllObjects)])
    {
        [object retain];
        
        [NSObject confuseMutable:object];
        
        return [object autorelease];
    }
    else
    {
        id result = nil;
        if([object isKindOfClass:[NSString class]])
        {
            result = [[NSMutableString alloc] initWithString:object];
        }
        else if([object isKindOfClass:[NSArray class]])
        {
            result = [[NSMutableArray alloc] initWithArray:object]; 
        }
        
        if(result == nil)
        {
            return nil;
        }
        else
        {
            [NSObject confuse:result];
            
            return  [result autorelease];
        }
    }
}

+ (void)confuseMutable:(id)object
{
    if([object isKindOfClass:[NSMutableArray class]])
    {
        //随机调换数据源里的数据位置
        for(int i=0; i<[object count]; i++)
        {
            int j = arc4random()%[object count];
            if(i!=j)
                [object exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    else if([object isKindOfClass:[NSMutableString class]])
    {
        int length = [object length];
        
        if(length>1)
        {
            for(int i=0; i<length; i++)
            {
                int j = arc4random()%length;
                
                if(i!=j)
                {
                    NSString *iChar = [object substringWithRange:NSMakeRange(i, 1)];
                    NSString *jChar = [object substringWithRange:NSMakeRange(j, 1)];
                    [object replaceCharactersInRange:NSMakeRange(i, 1) withString:jChar];
                    [object replaceCharactersInRange:NSMakeRange(j, 1) withString:iChar];
                }
            }
        }
    }
}

+ (void)transferHtmlString:(NSMutableString *)html
{
    [html replaceOccurrencesOfString:@"&gt;" withString:@">"];
    [html replaceOccurrencesOfString:@"&lt;" withString:@"<"];
    [html replaceOccurrencesOfString:@"&amp;" withString:@"&"];
    [html replaceOccurrencesOfString:@"&ldquo;" withString:@"“"];
    [html replaceOccurrencesOfString:@"&rdquo;" withString:@"”"];
}


@end
