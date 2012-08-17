//
//  WebcastsParser.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/16/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CernMediaMARCParser.h"

@class WebcastsParser;

@protocol WebcastsParserDelegate <NSObject>
@optional
- (void)webcastsParser:(WebcastsParser *)parser didParseRecentItem:(NSDictionary *)item;
- (void)webcastsParserDidFinishParsingParsingRecentWebcasts:(WebcastsParser *)parser;
- (void)webcastsParser:(WebcastsParser *)parser didDownloadThumbnailForIndex:(int)index;
@end

@interface WebcastsParser : NSObject<NSURLConnectionDataDelegate, CernMediaMarcParserDelegate>
{
    NSURLConnection *_recentsConnection;
    NSMutableData *_recentsData;
    NSUInteger numParsersLoading;
}
@property (nonatomic, strong) id<WebcastsParserDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *recentWebcasts;
@property (nonatomic, strong) NSMutableDictionary *recentWebcastThumbnails;
- (void)parseRecent;

@end
