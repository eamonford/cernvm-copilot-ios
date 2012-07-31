//
//  BulletinViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/30/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "NewsTableViewController.h"
#import "RSSTableViewController.h"

@interface BulletinViewController : RSSTableViewController
{
    NSArray *issues;
}
@property (nonatomic, retain) NSArray *issues;

- (NSArray *)feedArticlesSeparatedByWeek:(NSArray *)feedArticles;

@end
