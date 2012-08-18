//
//  RSSGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "RSSAggregator.h"
#import "MBProgressHUD.h"

@interface RSSGridViewController : AQGridViewController<AQGridViewDataSource, AQGridViewDelegate, RSSAggregatorDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *_noConnectionHUD;
}
@property (nonatomic, strong) RSSAggregator *aggregator;
- (void)refresh;

@end
