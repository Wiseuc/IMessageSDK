//
//  XMLReader.h
//
//  Created by Troy on 9/18/10.
//  Copyright 2010 Troy Brant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kXMLReaderTextNodeKey                   @"text"


@protocol XMLReaderDelegate;

@interface XMLReader : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
    
    id<XMLReaderDelegate> delegate;
}

@property (nonatomic, assign) id<XMLReaderDelegate> delegate;

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

- (NSDictionary *)parseXMLString:(NSString *)string error:(NSError **)error;

@end





@protocol XMLReaderDelegate <NSObject>

- (void)xmlReader:(XMLReader *)reader didReceiveInformation:(id)information parentInformation:(id)parentInformation elementName:(NSString *)elementName;

- (void)xmlReaderDidFinishReading:(XMLReader *)reader;

@end
