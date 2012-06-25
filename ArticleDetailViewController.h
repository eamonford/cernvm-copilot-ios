//
//  ArticleDetailViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/18/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"

@interface ArticleDetailViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *contentWebView;
    
    @private
    NSString *contentString;
}
@property (nonatomic, retain) UIWebView *contentWebView;
@property (nonatomic, retain) NSString *contentString;

- (void)setContentForArticle:(MWFeedItem *)article;
- (void)setContentForTweet:(NSDictionary *)tweet;

@end
