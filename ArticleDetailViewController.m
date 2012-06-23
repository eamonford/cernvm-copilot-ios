//
//  ArticleDetailViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/18/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "NSString+HTML.h"

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController
@synthesize contentWebView, contentString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.contentString)
        [self.contentWebView loadHTMLString:self.contentString baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setContentForArticle:(MWFeedItem *)article
{
    NSMutableString *body = [NSMutableString stringWithFormat:@"<h1>%@</h1>", article.title];
    if (article.content) {
        [body appendString:article.content];
    } else {
        [body appendString:article.summary];
    }
    self.contentString = body;
    [self.contentWebView loadHTMLString:self.contentString baseURL:nil];
}

- (void)setContentForTweet:(NSDictionary *)tweet
{
    self.contentString = [[tweet objectForKey:@"text"] stringByLinkifyingURLs];
    [self.contentWebView loadHTMLString:self.contentString baseURL:nil];
}

@end
