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

@property (nonatomic, strong) RSSAggregator *aggregator;
- (void)refresh;

@end
