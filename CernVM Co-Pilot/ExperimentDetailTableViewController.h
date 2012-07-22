//
//  ExperimentDetailTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExperimentsViewController.h"

@interface ExperimentDetailTableViewController : UITableViewController
{
    ExperimentType experiment;
}
@property ExperimentType experiment;

@end
