//
//  NSObject+Additions.h
//  IEMAA
//
//  Created by Mr. Wang on 12-10-9.
//
//

#import <Foundation/Foundation.h>
void runCategoryForFramework39();
//void runCategoryForFramework(){}
@interface NSObject(Additions)

+ (id)objectForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary;

+ (id)objectForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary espectedType:(Class)clazz;

+ (BOOL)isEmpty:(id)object;

+ (id)confuse:(id)object;

+ (void)transferHtmlString:(NSMutableString *)html;

+ (NSString *)textForString:(NSString *)string;

+ (NSString *)createStringByAddingPercentEscapes4String:(NSString *)original;

@end
