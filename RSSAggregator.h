//
//  RSSAggregator.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSFeed.h"
#import "FeedDelegate.h"

@class RSSAggregator;
@protocol RSSAggregatorDelegate <NSObject>

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)aggregator;

@end

@interface RSSAggregator : NSObject<FeedDelegate>
{
    NSMutableArray *feeds;
    id<RSSAggregatorDelegate> delegate;
}
@property (atomic) NSMutableArray *feeds;
@property (nonatomic, strong) id<RSSAggregatorDelegate> delegate;

- (void)addFeed:(RSSFeed *)feed;
- (void)addFeedForURL:(NSURL *)url;
- (void)refreshAllFeeds;
- (NSArray *)aggregate;
- (RSSFeed *)feedForArticle:(MWFeedItem *)article;

@end
