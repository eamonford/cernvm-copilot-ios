//
//  VideosTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/3/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CernMediaMARCParser.h"
@interface VideosTableViewController : UITableViewController<CernMediaMarcParserDelegate>
{
    CernMediaMARCParser *parser;
    NSOperationQueue *queue;
}

- (IBAction)close:(id)sender;

@end
