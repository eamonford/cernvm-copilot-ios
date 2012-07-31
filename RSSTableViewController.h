//
//  RSSTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSAggregator.h"

@interface RSSTableViewController : UITableViewController <RSSAggregatorDelegate>
{
    RSSAggregator *aggregator;
    UIView *loadingView;
}
@property (nonatomic, retain) RSSAggregator *aggregator;

- (void)refresh;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
