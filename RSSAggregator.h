//
//  RSSAggregator.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSFeed.h"

@interface RSSAggregator : NSObject
{
    NSMutableArray *feeds;
    id<RSSFeedDelegate> delegate;

}
@property (nonatomic, retain) NSMutableArray *feeds;
@property (nonatomic, strong) id<RSSFeedDelegate> delegate;

- (void)addFeedForURL:(NSURL *)url;
- (void)refreshAllFeeds;

@end
