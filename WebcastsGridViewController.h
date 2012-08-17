//
//  WebcastsGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/16/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "WebcastsParser.h"

@interface WebcastsGridViewController : AQGridViewController<WebcastsParserDelegate>

@property (nonatomic, strong) WebcastsParser *parser;

@end
