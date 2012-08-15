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
@property (nonatomic, strong) UIWebView *contentWebView;
@property (nonatomic, strong) NSString *contentString;

- (void)setContentForArticle:(MWFeedItem *)article;
- (void)setContentForVideoMetadata:(NSDictionary *)videoMetadata;
- (void)setContentForTweet:(NSDictionary *)tweet;

@end
