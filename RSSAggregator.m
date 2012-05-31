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
    }
    return self;
}

- (void)addFeedForURL:(NSURL *)url
{
    RSSFeed *feed = [[RSSFeed alloc] init];
    feed.url = url;
    feed.delegate = self;
    [feed refresh];
    
    [self.feeds addObject:feed];
}


- (void)rssFeedDidLoad:(RSSFeed *)feed
{
    if (self.delegate) {
        [self.delegate rssFeedDidLoad:feed];
    }
}

- (void)refreshAllFeeds
{
    for (RSSFeed *feed in self.feeds) {
        [feed refresh];
    }
}


@end
