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

@optional
- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)aggregator;
- (void)aggregator:(RSSAggregator *)aggregator didDownloadFirstImage:(UIImage *)image forArticle:(MWFeedItem *)article;

@end

@interface RSSAggregator : NSObject<FeedDelegate>
{
    NSMutableArray *feeds;
    NSArray *allArticles;
    id<RSSAggregatorDelegate> delegate;
    
    @private
    int feedLoadCount;
    NSMutableDictionary *firstImages;
}

@property (atomic) NSMutableArray *feeds;
@property (nonatomic, strong) id<RSSAggregatorDelegate> delegate;
@property (nonatomic, retain) NSArray *allArticles;

- (void)addFeed:(RSSFeed *)feed;
- (void)addFeedForURL:(NSURL *)url;
- (void)refreshAllFeeds;
- (UIImage *)firstImageForArticle:(MWFeedItem *)article;
- (RSSFeed *)feedForArticle:(MWFeedItem *)article;

@end