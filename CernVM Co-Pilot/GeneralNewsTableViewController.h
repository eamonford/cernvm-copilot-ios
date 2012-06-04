//
//  GeneralNewsTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSAggregator.h"

@interface GeneralNewsTableViewController : UITableViewController <RSSAggregatorDelegate>
{
    RSSAggregator *aggregator;
    NSArray *feedArticles;
}
@property (nonatomic, strong) RSSAggregator *aggregator;
@property (atomic) NSArray *feedArticles;

@end
