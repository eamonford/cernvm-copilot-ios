//
//  RSSAggregator.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSAggregator.h"

@implementation RSSAggregator
@synthesize feeds, delegate;


- (id)init
{
    self = [super init];
    if (self) {
        self.feeds = [NSMutableArray array];
        feedLoadCount = 0;
    }
    return self;
}

- (void)addFeed:(RSSFeed *)feed
{
    feed.aggregator = self;
    [self.feeds addObject:feed];
}

- (void)addFeedForURL:(NSURL *)url
{
    RSSFeed *feed = [[RSSFeed alloc] initWithFeedURL:url];
    [self addFeed:feed];
}

- (NSArray *)aggregate
{
    NSMutableArray *aggregation = [NSMutableArray array];
    for (RSSFeed *feed in self.feeds) {
        [aggregation addObjectsFromArray:feed.articles];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortedAggregation = [aggregation sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return sortedAggregation;
}

- (void)refreshAllFeeds
{
    // Only refresh all feeds if we are not already in the middle of a refresh
    if (feedLoadCount == 0) {
        feedLoadCount = self.feeds.count;
        for (RSSFeed *feed in self.feeds) {
            [feed refresh];
        }
    }
}

- (RSSFeed *)feedForArticle:(MWFeedItem *)article
{
    for (RSSFeed *feed in self.feeds) {
        if ([feed.articles containsObject:article]) {
            return feed;
        }
    }
    return nil;
}

- (void)feedDidLoad:(id)feed
{
    // Keep track of how many feeds have loaded after refreshAllFeeds was called, and after all feeds have loaded, inform the delegate.
    if (--feedLoadCount == 0) {
        if (self.delegate) {
            [delegate allFeedsDidLoadForAggregator:self];
        }
    }
}

@end
