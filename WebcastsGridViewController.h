//
//  WebcastsGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/16/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "WebcastsParser.h"


typedef enum {
    WebcastModeRecent,
    WebcastModeUpcoming
} WebcastMode;

@interface WebcastsGridViewController : AQGridViewController<WebcastsParserDelegate>

@property (nonatomic, strong) WebcastsParser *parser;
@property WebcastMode mode;

- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender;

@end
