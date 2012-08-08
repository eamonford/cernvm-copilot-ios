//
//  NewsGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/7/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "RSSAggregator.h"

@interface NewsGridViewController : AQGridViewController<AQGridViewDataSource, AQGridViewDelegate, RSSAggregatorDelegate>
{
    RSSAggregator *aggregator;
    BOOL displaySpinner;
    NSRange rangeOfArticlesToShow;
}
@property (nonatomic, retain) RSSAggregator *aggregator;
@property NSRange rangeOfArticlesToShow;

- (void)refresh;

@end
