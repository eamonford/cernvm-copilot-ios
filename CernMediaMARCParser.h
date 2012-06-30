//
//  CernMediaMODSParser.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/25/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ImageSizeEnum {
    IMAGE_SIZE_ICON,
    IMAGE_SIZE_MEDIUM,
    IMAGE_SIZE_LARGE
} ImageSize;

typedef  enum SubfieldCodeEnum {
    SUBFIELD_CODE_X,
    SUBFIELD_CODE_U
} SubfieldCode;

@class CernMediaMARCParser;

@protocol CernMediaMarcParserDelegate <NSObject>

- (void)parser:(CernMediaMARCParser *)parser didParseMediaItems:(NSArray *)mediaItems;

@end

@interface CernMediaMARCParser : NSObject<NSURLConnectionDelegate, NSXMLParserDelegate>
{
    NSURL *url;
    NSArray *resourceTypes;
    id<CernMediaMarcParserDelegate> delegate;
    
    @private
    
    NSMutableArray *mediaItems;
    NSMutableData *asyncData;
    NSString *currentResourceType;
    NSMutableDictionary *currentMediaItem;
    NSMutableString *currentUValue;
    SubfieldCode currentSubfieldCode;
    ImageSize currentImageSize;
    BOOL foundSubfield;
    BOOL foundX;
    BOOL foundU;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSArray *resourceTypes;
@property (nonatomic, strong) id<CernMediaMarcParserDelegate> delegate;

- (void)parse;

@end
