//
//  GeneralNewsTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSTableViewController.h"

@interface NewsTableViewController : RSSTableViewController
{
    NSArray *feedArticles;
    NSMutableDictionary *thumbnailImages;
}
@property (nonatomic, retain) NSMutableDictionary *thumbnailImages;
@property (atomic) NSArray *feedArticles;

- (void)loadAllArticleThumbnails;
- (void)loadThumbnailForArticleAtIndex:(NSNumber *)number;

@end
