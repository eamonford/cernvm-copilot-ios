//
//  VideosTableViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/3/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CernMediaMARCParser.h"
#import "ArticleDetailViewController.h"

@interface VideosTableViewController : UITableViewController<CernMediaMarcParserDelegate>
{
    CernMediaMARCParser *parser;
    NSOperationQueue *queue;
    UIView *loadingView;
    NSMutableArray *videoMetadata;
    NSMutableDictionary *videoThumbnails;
    ArticleDetailViewController *detailView;
}
@property (nonatomic, retain) NSMutableArray *videoMetadata;
@property (nonatomic, retain) NSMutableDictionary *videoThumbnails;
@property (nonatomic, retain) ArticleDetailViewController *detailView;

- (IBAction)close:(id)sender;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
