//
//  GeneralNewsTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NSString+HTML.h"
#import "ArticleDetailViewController.h"
#import "ArticleTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define THUMBNAIL_SIZE 75.0
@interface NewsTableViewController ()

@end

@implementation NewsTableViewController
@synthesize aggregator, feedArticles, thumbnailImages;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.thumbnailImages = [NSMutableDictionary dictionary];
        self.feedArticles = [NSArray array];
        self.aggregator = [[RSSAggregator alloc] init];
        self.aggregator.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grayTexture.png"]];
    self.tableView.backgroundView = backgroundView;
    
    [self showLoadingView];
    [self.aggregator refreshAllFeeds];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Pass article data into the article detail view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowArticleDetails"])
    {
        ArticleDetailViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *articleIndexPath = [self.tableView indexPathForSelectedRow];
        MWFeedItem *article = [self.feedArticles objectAtIndex:[articleIndexPath row]];
        [detailViewController setContentForArticle:article];
    }
}

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
    self.feedArticles = [sender aggregate];
    [self.tableView reloadData];
    [self hideLoadingView];
    
    for (int i=0; i<self.feedArticles.count; i++) {
        [self performSelectorInBackground:@selector(loadThumbnailForArticleAtIndex:) withObject:[NSNumber numberWithInt:i]];
    }
}

- (void)loadThumbnailForArticleAtIndex:(NSNumber *)number
{
    int index = number.intValue;
    MWFeedItem *article = [self.feedArticles objectAtIndex:index];
    NSString *body = article.content;
    if (!body) {
        body = article.summary;
    }
    NSURL *imageURL = [self imageURLFromHTMLString:body];
    if (imageURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        UIImage *image = [UIImage imageWithData:imageData];
        image = [self squareImageWithDimension:THUMBNAIL_SIZE fromImage:image];
        
        [self.thumbnailImages setObject:image forKey:number];
        [self performSelectorOnMainThread:@selector(reloadTableCell:) withObject:number waitUntilDone:YES];
    }
}

- (void)reloadTableCell:(NSNumber *)indexNumber
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexNumber.intValue inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

}

- (UIImage *)squareImageWithDimension:(float)dimension fromImage:(UIImage *)originalImage
{
    CGImageRef imageRef = originalImage.CGImage;
    CGFloat width = originalImage.size.width;
    CGFloat height = originalImage.size.height;
    CGFloat minDimension = width<height ? width : height;
    
    CGRect cropRect = CGRectMake(0.0, 0.0, minDimension, minDimension);
    
    imageRef = CGImageCreateWithImageInRect(imageRef, cropRect);
    
    float scaleFactor = dimension/originalImage.size.width;
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scaleFactor orientation:UIImageOrientationUp];
    
    return image;
}

- (NSURL *)imageURLFromHTMLString:(NSString *)htmlString
{
    NSString *urlString;
    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
    // find start of IMG tag
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&urlString];
        // "url" now contains the URL of the img
        
        return [NSURL URLWithString:urlString];
    }
    // if no img url was found, return nil
    return nil;
}

#pragma mark - UI methods

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showLoadingView
{
    if (!loadingView) {
        loadingView = [[UIView alloc] init];
        loadingView.frame = self.tableView.bounds;    
        UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect frame = loadingView.frame;
        ac.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [loadingView addSubview:ac];
        [ac startAnimating];
        loadingView.backgroundColor = [UIColor whiteColor];
    }
    [self.tableView addSubview:loadingView];
}

- (void)hideLoadingView
{    
    [loadingView removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.feedArticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"articleTableViewCell";
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.cornerRadius = 5.0;
    cell.shadowSize = 2.0;
    cell.fillColor = [UIColor whiteColor];
    cell.shadowColor = [UIColor darkGrayColor];

    // Set the article title label
    MWFeedItem *feedItem = [self.feedArticles objectAtIndex:[indexPath row]];
    cell.titleLabel.text = [feedItem.title stringByConvertingHTMLToPlainText];

    // Create the feed name label
    NSString *feedName = [self.aggregator feedForArticle:feedItem].info.title;
    cell.feedLabel.text = feedName;

    // Create the article date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *articleDate = [dateFormatter stringFromDate:feedItem.date];
    cell.dateLabel.text = articleDate;
    
    UIImage *thumbnailImage = [self.thumbnailImages objectForKey:[NSNumber numberWithInt:indexPath.row]];
    if (thumbnailImage) {
        cell.thumbnailImageView.image = thumbnailImage;
        NSLog(@"setting thumbnail for cell %d", indexPath.row);
    }
    
    return cell;
}

#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWFeedItem *feedItem = [self.feedArticles objectAtIndex:[indexPath row]];
    NSString *text = feedItem.title;
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:CGSizeMake(260.0, CGFLOAT_MAX)];
    
    return MAX(THUMBNAIL_SIZE+20.0, size.height+55.0);
}



@end
