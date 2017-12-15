//
//  NSMutableString+ReplacingOccurencesOfString.m
//  VIPClub
//
//  Created by Mr. Wang on 11-10-20.
//  Copyright 2011 七星螵虫北京专卖店. All rights reserved.
//

#import "LT_NSMutableString+ReplacingOccurencesOfString.h"
void runCategoryForFramework38(){}
@implementation NSMutableString(ReplacingOccurencesOfString)

- (void)replaceOccurrencesOfString:(NSString *)source withString:(NSString *)replacement
{
	NSRange range = [self rangeOfString:source];
	
	while(range.length == [source length])
	{
		[self replaceCharactersInRange:range withString:replacement];
		range = [self rangeOfString:source];
	}
}

- (void)deleteOccurencesOfString:(NSString *)string
{
	[self replaceOccurrencesOfString:string withString:@""];
}

- (void)deleteBeforeString:(NSString *)string
{
	[self remainFromString:string];
}

- (void)deleteToString:(NSString *)string
{
	[self remainAfterString:string];
}

- (void)deleteAfterString:(NSString *)string
{
	[self remainToString:string];
}

- (void)deleteFromString:(NSString *)string
{
	[self remainBeforeString:string];
}

- (void)remainAfterString:(NSString *)string
{
	NSRange range = [self rangeOfString:string];
	
	if(range.length == [string length]) 
	{	
		NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=0,length=%d}", range.length+range.location];
		[self deleteCharactersInRange:NSRangeFromString(rangeString)];
		[rangeString release];
	}
}

- (void)remainBeforeString:(NSString *)string
{
	NSRange range = [self rangeOfString:string];
	
	if(range.length == [string length]) 
		[self deleteCharactersFromIndex:range.location];
}

- (void)remainFromString:(NSString *)string
{
	NSRange range = [self rangeOfString:string];
	
	if(range.length == [string length])
	{
		NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=0,length=%d}", range.location];
		[self deleteCharactersInRange:NSRangeFromString(rangeString)];
		[rangeString release];
	}
}

- (void)remainToString:(NSString *)string
{
	NSRange range = [self rangeOfString:string];
	
	if(range.length == [string length]) 
		[self deleteCharactersFromIndex:range.location+range.length];
}

- (void)remainCharactersToIndex:(NSUInteger)to
{
	if(to<=[self length]-1)
	{
		NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=0,length=%d}", to+1];
		[self replaceCharactersInRange:NSRangeFromString(rangeString) withString:@""];
		[rangeString release];
	}
	else 
	{
		NSLog(@"[NSMutableString(Replacing...) remainCharactersToIndex:%d]超范围截取[0...%d]！", to, [self length]);
	}
}

- (void)deleteCharactersFromIndex:(NSUInteger)from
{
	if(from<=[self length]-1)
	{
		NSString *rangeString = [[NSString alloc] initWithFormat:@"{location=%d,length=%d}", from, [self length]-from];
		[self deleteCharactersInRange:NSRangeFromString(rangeString)];
		[rangeString release];
	}
	else 
	{
		NSLog(@"[NSMutableString(Replacing...) deleteCharactersFromIndex:%d]超范围截取[0...%d]！", from, [self length]);
	}
}

- (void)insertString:(NSString *)insert afterOccurencesOfString:(NSString *)string
{
	NSString *target = [[NSString alloc] initWithFormat:@"%@%@", string, insert];
	[self replaceOccurrencesOfString:string withString:target options:0 range:[self rangeOfString:self]];
	[target release];
}

- (void)insertString:(NSString *)insert beforeOccurencesOfString:(NSString *)string
{
	NSString *target = [[NSString alloc] initWithFormat:@"%@%@", insert, string];
	[self replaceOccurrencesOfString:string withString:target options:0 range:[self rangeOfString:self]];
	[target release];
}

@end
