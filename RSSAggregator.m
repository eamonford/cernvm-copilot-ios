//
//  RSSAggregator.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSAggregator.h"

@implementation RSSAggregator
//@synthesize feeds, allArticles, delegate;


- (id)init
{
    self = [super init];
    if (self) {
        self.firstImages = [NSMutableDictionary dictionary];
        self.allArticles = [NSArray array];
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

- (void)refreshAllFeeds
{
    // Only refresh all feeds if we are not already in the middle of a refresh
    if (feedLoadCount == 0) {
        self.allArticles = [NSArray array];
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
        self.allArticles = [self aggregate];
        if (self.delegate && [self.delegate respondsToSelector:@selector(allFeedsDidLoadForAggregator:)]) {
            [self.delegate allFeedsDidLoadForAggregator:self];
        }
        [self downloadAllFirstImages];
    }
}

- (UIImage *)firstImageForArticle:(MWFeedItem *)article
{
    NSNumber *articleIndex = [NSNumber numberWithInt:[self.allArticles indexOfObject:article]];
    return [self.firstImages objectForKey:articleIndex];
}

#pragma mark - Private helper methods

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

- (void)downloadAllFirstImages
{
    for (MWFeedItem *article in self.allArticles) {
        [self performSelectorInBackground:@selector(downloadFirstImageForArticle:) withObject:article];
    }
}

- (void)downloadFirstImageForArticle:(MWFeedItem *)article
{
    NSString *body = article.content;
    if (!body) {
        body = article.summary;
    }
    NSURL *imageURL = [self firstImageURLFromHTMLString:body];
    if (imageURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            NSNumber *articleIndex = [NSNumber numberWithInt:[self.allArticles indexOfObject:article]];
            [self.firstImages setObject:image forKey:articleIndex];
        } else {
            [self downloadFirstImageForArticle:article];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(aggregator:didDownloadFirstImage:forArticle:)]) {
            [self.delegate aggregator:self didDownloadFirstImage:image forArticle:article];
        }
    }
}

- (NSURL *)firstImageURLFromHTMLString:(NSString *)htmlString
{
    NSString *urlString;
    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
    // find start of IMG tag
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&urlString];
        // "url" now contains the URL of the img
        
        return [NSURL URLWithString:urlString];
    }
    // if no img url was found, return nil
    return nil;
}

@end
