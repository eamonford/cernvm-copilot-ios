//
//  GeneralNewsTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSAggregator.h"

@interface NewsTableViewController : UITableViewController <RSSAggregatorDelegate>
{
    RSSAggregator *aggregator;
    NSArray *feedArticles;
    UIView *loadingView;
}
@property (nonatomic, retain) RSSAggregator *aggregator;
@property (atomic) NSArray *feedArticles;

- (IBAction)close:(id)sender;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
