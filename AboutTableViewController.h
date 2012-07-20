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
    NSArray *tableDataSource;
    NSString *currentTitle;
    NSInteger currentLevel;
}
@property (nonatomic, retain) NSArray *tableDataSource;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, readwrite) NSInteger currentLevel;

@end
