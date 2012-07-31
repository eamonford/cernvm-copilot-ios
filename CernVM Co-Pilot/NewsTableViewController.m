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
#import "UIImage+SquareScaledImage.h"
#import <QuartzCore/QuartzCore.h>

#define THUMBNAIL_SIZE 75.0
@interface NewsTableViewController ()

@end

@implementation NewsTableViewController
@synthesize feedArticles, thumbnailImages;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.thumbnailImages = [NSMutableDictionary dictionary];
        self.feedArticles = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grayTexture.png"]];
    self.tableView.backgroundView = backgroundView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    
    [self loadAllArticleThumbnails];
    
    [super allFeedsDidLoadForAggregator:sender];
}

#pragma mark - Loading thumbnails

- (void)loadAllArticleThumbnails
{
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
        // We only want the image if it's at least as big as our thumbnail size
        if (image.size.width >= THUMBNAIL_SIZE && image.size.height >= THUMBNAIL_SIZE) {
            image = [UIImage squareImageWithDimension:THUMBNAIL_SIZE fromImage:image];
            [self.thumbnailImages setObject:image forKey:number];
            [self performSelectorOnMainThread:@selector(reloadTableCell:) withObject:number waitUntilDone:YES];
        }
    }
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

- (void)reloadTableCell:(NSNumber *)indexNumber
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexNumber.intValue inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
    
    if (self.feedArticles.count == 1) {
        cell.position = ShadowedCellPositionSingle;
    } else if (indexPath.row == 0) {
        cell.position = ShadowedCellPositionTop;
    } else if (indexPath.row == self.feedArticles.count-1) {
        cell.position = ShadowedCellPositionBottom;
    } else {
        cell.position = ShadowedCellPositionMiddle;
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
    } else {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"thumbnailPlaceholder"];
    }
    
    return cell;
}

#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWFeedItem *feedItem = [self.feedArticles objectAtIndex:[indexPath row]];
    NSString *text = feedItem.title;
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:CGSizeMake(189.0, CGFLOAT_MAX)];
    
    return MAX(THUMBNAIL_SIZE+20.0, size.height+70.0);
}



@end
