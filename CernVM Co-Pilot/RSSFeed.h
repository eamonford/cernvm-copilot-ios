//
//  RSSFeed.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/28/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"
#import "FeedDelegate.h"

@class RSSFeed;

@interface RSSFeed : NSObject <NSURLConnectionDelegate, MWFeedParserDelegate>
{    
    MWFeedParser *parser;
    MWFeedInfo *info;
    NSMutableArray *articles;
    id<FeedDelegate> aggregator;
    id<FeedDelegate> delegate;
}
@property (nonatomic, strong) MWFeedParser *parser;
@property (nonatomic) MWFeedInfo *info;
@property (nonatomic) NSMutableArray *articles;
@property (nonatomic, strong) id aggregator;
@property (nonatomic, strong) id delegate;

- (id)initWithFeedURL:(NSURL *)url;
- (void)refresh;

@end
