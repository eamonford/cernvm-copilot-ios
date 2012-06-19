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
@synthesize article, contentWebView;

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
    
    NSMutableString *body = [NSMutableString stringWithFormat:@"<h1>%@</h1>", self.article.title];
    if (self.article.content) {
        NSLog(@"Using content");
        [body appendString:self.article.content];
    } else {
        NSLog(@"Using summary");
        [body appendString:self.article.summary];
    }
    
    [self.contentWebView loadHTMLString:body baseURL:nil];
    NSLog(@"%@", body);

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

@end
