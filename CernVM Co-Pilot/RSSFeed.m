//
//  RSSFeed.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/28/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSFeed.h"
#import "RSSArticle.h"

//@interface RSSFeed (ReadOnlyProperties)
//
//@property (nonatomic, retain) MWFeedParser *parser;
//@property (nonatomic, retain) MWFeedInfo *info;
//@property (nonatomic, retain) NSMutableArray *articles;
//
//@end

@implementation RSSFeed
@synthesize /*title, description, url,*/ parser, info, articles, aggregator, delegate;

- (id)initWithFeedURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.parser = [[MWFeedParser alloc] initWithFeedURL:url];
        self.parser.feedParseType = ParseTypeFull;
        self.parser.connectionType = ConnectionTypeAsynchronously;
        self.parser.delegate = self;
        self.articles = [NSMutableArray array];
    }
    return self;
}

- (void)refresh
{
    self.articles = [NSMutableArray array];
    [self.parser parse];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)feedInfo
{
    self.info = feedInfo;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    [self.articles addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    if (aggregator)
        [aggregator feedDidLoad:self];
    if (delegate)
        [delegate feedDidLoad:self];
}

@end
