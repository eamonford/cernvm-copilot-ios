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
    NSString *body = @"";
    // Give "content" a higher priority, but otherwise use "summary"
    if (article.content) {
        body = article.content;
    } else if (article.summary) {
        body = article.summary;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [formatter stringFromDate:article.date];
    
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"ArticleCSS" ofType:@"css"];
    NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<html><head><link rel='stylesheet' type='text/css' href='file://%@'></head><body><h1>%@</h1><h2>%@</h2>%@</body></html>", cssPath, article.title, dateString, body];

    self.contentString = htmlString;
    [self.contentWebView loadHTMLString:self.contentString baseURL:nil];
}

- (void)setContentForTweet:(NSDictionary *)tweet
{
    self.contentString = [[tweet objectForKey:@"text"] stringByLinkifyingURLs];
    [self.contentWebView loadHTMLString:self.contentString baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
}

@end
