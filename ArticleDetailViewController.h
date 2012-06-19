//
//  ArticleDetailViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/18/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"

@interface ArticleDetailViewController : UIViewController
{
    MWFeedItem *article;   
    IBOutlet UIWebView *contentWebView;
}
@property (nonatomic, retain) MWFeedItem *article;
@property (nonatomic, retain) UIWebView *contentWebView;

@end
