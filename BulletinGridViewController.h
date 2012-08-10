//
//  BulletinGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "RSSAggregator.h"
#import "RSSGridViewController.h"

@interface BulletinGridViewController : RSSGridViewController
{
    NSArray *rangesOfArticlesSeparatedByWeek;
}
@property (nonatomic, retain) NSArray *rangesOfArticlesSeparatedByWeek;

- (NSArray *)calculateRangesOfArticlesSeparatedByWeek:(NSArray *)feedArticles;

@end
