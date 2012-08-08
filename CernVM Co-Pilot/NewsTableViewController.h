//
//  GeneralNewsTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSTableViewController.h"
#import "ArticleDetailViewController.h"

@interface NewsTableViewController : RSSTableViewController
{
    IBOutlet ArticleDetailViewController *detailView;
    NSRange rangeOfArticlesToShow;
}

@property (nonatomic, retain) ArticleDetailViewController *detailView;
@property NSRange rangeOfArticlesToShow;

@end
