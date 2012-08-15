//
//  CernMediaMODSParser.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/25/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum SubfieldCodeEnum {
    SUBFIELD_CODE_X,
    SUBFIELD_CODE_U
} SubfieldCode;

@class CernMediaMARCParser;

@protocol CernMediaMarcParserDelegate <NSObject>

@optional

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)record;
- (void)parserDidFinish:(CernMediaMARCParser *)parser;

@end

@interface CernMediaMARCParser : NSObject<NSURLConnectionDelegate, NSXMLParserDelegate>
{
    NSURL *url;
    NSMutableArray *resourceTypes;
    id<CernMediaMarcParserDelegate> delegate;
    BOOL isFinishedParsing;
    
    @private
    
    NSMutableData *asyncData;
    NSString *currentResourceType;
    //NSMutableDictionary *currentMediaItem;
    NSMutableDictionary *currentRecord;
    NSMutableString *currentUValue;
    NSString *currentDatafieldTag;
    NSString *currentSubfieldCode;
    BOOL foundSubfield;
    BOOL foundX;
    BOOL foundU;
}

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *resourceTypes;
@property (nonatomic, strong) id<CernMediaMarcParserDelegate> delegate;
@property BOOL isFinishedParsing;
- (void)parse;

@end
