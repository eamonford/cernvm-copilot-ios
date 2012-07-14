//
//  ExperimentTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDelegate.h"
#import "TwitterFeed.h"
#import "ArticleTableViewCell.h"
#import "RSSAggregator.h"

@interface ExperimentTableViewController : UITableViewController<FeedDelegate, RSSAggregatorDelegate>
{
    TwitterFeed *feed;
    RSSAggregator *aggregator;
    NSArray *feedArticles;
}
@property (nonatomic, retain) TwitterFeed *feed;
@property (nonatomic, retain) RSSAggregator *aggregator;
@property (nonatomic, retain) NSArray *feedArticles;

@end
