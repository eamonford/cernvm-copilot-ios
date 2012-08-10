//
//  RSSGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "RSSAggregator.h"

@interface RSSGridViewController : AQGridViewController<AQGridViewDataSource, AQGridViewDelegate, RSSAggregatorDelegate>
{
    RSSAggregator *aggregator;
    BOOL displaySpinner;
}

@property (nonatomic, retain) RSSAggregator *aggregator;
@property BOOL displaySpinner;

- (void)refresh;

@end
