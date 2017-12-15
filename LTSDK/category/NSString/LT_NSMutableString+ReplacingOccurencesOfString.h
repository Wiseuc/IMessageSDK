//
//  NSMutableString+ReplacingOccurencesOfString.h
//  VIPClub
//
//  Created by Mr. Wang on 11-10-20.
//  Copyright 2011 七星螵虫北京专卖店. All rights reserved.
//

#import <Foundation/Foundation.h>
void runCategoryForFramework38();
//void runCategoryForFramework(){}

@interface NSMutableString(ReplacingOccurencesOfString)

- (void)replaceOccurrencesOfString:(NSString *)source withString:(NSString *)replacement;

- (void)deleteOccurencesOfString:(NSString *)string;

//!!!: 
- (void)deleteBeforeString:(NSString *)string;

- (void)deleteAfterString:(NSString *)string;

- (void)deleteFromString:(NSString *)string;

- (void)deleteToString:(NSString *)string;

//!!!:
- (void)remainAfterString:(NSString *)string;

- (void)remainBeforeString:(NSString *)string;

- (void)remainFromString:(NSString *)string;

- (void)remainToString:(NSString *)string;

- (void)remainCharactersToIndex:(NSUInteger)to;

- (void)deleteCharactersFromIndex:(NSUInteger)from;

- (void)insertString:(NSString *)insert afterOccurencesOfString:(NSString *)string;

- (void)insertString:(NSString *)insert beforeOccurencesOfString:(NSString *)string;

@end
