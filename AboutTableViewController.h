//
//  AboutTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/18/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewController : UITableViewController
{
    NSObject *currentElement;
}
@property(nonatomic, retain) NSObject *currentElement;

@end
