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
- (void)webcastsParser:(WebcastsParser *)parser didParseRecentWebcast:(NSDictionary *)webcast;
- (void)webcastsParser:(WebcastsParser *)parser didParseUpcomingWebcast:(NSDictionary *)webcast;
- (void)webcastsParserDidFinishParsingRecentWebcasts:(WebcastsParser *)parser;
- (void)webcastsParserDidFinishParsingUpcomingWebcasts:(WebcastsParser *)parser;
- (void)webcastsParser:(WebcastsParser *)parser didDownloadThumbnailForRecentWebcastIndex:(int)index;
- (void)webcastsParser:(WebcastsParser *)parser didDownloadThumbnailForUpcomingWebcastIndex:(int)index;
- (void)webcastsParser:(WebcastsParser *)parser didFailWithError:(NSError *)error;
@end

@interface WebcastsParser : NSObject<NSURLConnectionDataDelegate, CernMediaMarcParserDelegate>
{
    NSString *_htmlString;
    NSMutableData *_asyncData;
    NSUInteger numParsersLoading;
}

@property (nonatomic, strong) id<WebcastsParserDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *recentWebcasts;
@property (nonatomic, strong) NSMutableArray *upcomingWebcasts;
@property (nonatomic, strong) NSMutableDictionary *recentWebcastThumbnails;
@property (nonatomic, strong) NSMutableDictionary *upcomingWebcastThumbnails;

@property (nonatomic, readonly) BOOL pendingRecentWebcastsParse;
@property (nonatomic, readonly) BOOL pendingUpcomingWebcastsParse;
@property (nonatomic, readonly) BOOL pendingHTMLStringLoad;

- (void)parseRecentWebcasts;
- (void)parseUpcomingWebcasts;

- (void)loadHTMLString;

@end
