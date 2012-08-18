//
//  WebcastsGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/16/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "WebcastsParser.h"
#import "MBProgressHUD.h"

typedef enum {
    WebcastModeRecent,
    WebcastModeUpcoming
} WebcastMode;

@interface WebcastsGridViewController : AQGridViewController<WebcastsParserDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *_noConnectionHUD;
}
@property (nonatomic, strong) WebcastsParser *parser;
@property WebcastMode mode;

- (void)refresh;
- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender;

@end
