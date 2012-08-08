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
#import "Constants.h"

#define THUMBNAIL_SIZE 75.0
@interface NewsTableViewController ()

@end

@implementation NewsTableViewController
@synthesize detailView, rangeOfArticlesToShow;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.rangeOfArticlesToShow = NSMakeRange(0, 0);
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

// Pass article data into the article detail view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowArticleDetails"])
    {
        ArticleDetailViewController *detailViewController = [segue destinationViewController];
        
        NSIndexPath *articleIndexPath = [self.tableView indexPathForSelectedRow];
//        MWFeedItem *article = [self.feedArticles objectAtIndex:[articleIndexPath row]];
        MWFeedItem *article = [self.aggregator.allArticles objectAtIndex:[articleIndexPath row]];
        [detailViewController setContentForArticle:article];
    }
}

- (void)reloadTableCellAtIndex:(NSNumber *)index
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index.intValue inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - RSSAggregator delegate methods

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
//    self.feedArticles = [sender aggregate];
    [self.tableView reloadData];
    //[self loadAllArticleThumbnails];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    [super allFeedsDidLoadForAggregator:sender];
}

- (void)aggregator:(RSSAggregator *)aggregator didDownloadFirstImage:(UIImage *)image forArticle:(MWFeedItem *)article
{
//    NSNumber *articleIndex = [NSNumber numberWithInt:[self.aggregator.allArticles indexOfObject:article]];
    int index = [self.aggregator.allArticles indexOfObject:article];

    //[self performSelectorOnMainThread:@selector(reloadTableCellAtIndex:) withObject:articleIndex waitUntilDone:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

/*- (void)loadAllArticleThumbnails
{
//    for (int i=0; i<self.feedArticles.count; i++) {
    for (int i=0; i<self.aggregator.allArticles.count; i++) {
        [self performSelectorInBackground:@selector(loadThumbnailForArticleAtIndex:) withObject:[NSNumber numberWithInt:i]];
    }
}

- (void)loadThumbnailForArticleAtIndex:(NSNumber *)number
{
    int index = number.intValue;
//    MWFeedItem *article = [self.feedArticles objectAtIndex:index];
    MWFeedItem *article = [self.aggregator.allArticles objectAtIndex:index];
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
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.rangeOfArticlesToShow.length)
        return self.rangeOfArticlesToShow.length;
    else
        return self.aggregator.allArticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"articleTableViewCell";
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.aggregator.allArticles.count == 1) {
        cell.position = ShadowedCellPositionSingle;
    } else if (indexPath.row == 0) {
        cell.position = ShadowedCellPositionTop;
    } else if (indexPath.row == self.aggregator.allArticles.count-1) {
        cell.position = ShadowedCellPositionBottom;
    } else {
        cell.position = ShadowedCellPositionMiddle;
    }
    
    cell.cornerRadius = 5.0;
    cell.shadowSize = 2.0;
    cell.fillColor = [UIColor whiteColor];
    cell.shadowColor = [UIColor darkGrayColor];

    // Set the article title label
    MWFeedItem *feedItem = [self.aggregator.allArticles objectAtIndex:[indexPath row]+self.rangeOfArticlesToShow.location];
    cell.titleLabel.text = [feedItem.title stringByConvertingHTMLToPlainText];

    // Create the feed name label
    NSString *feedName = [self.aggregator feedForArticle:feedItem].info.title;
    cell.detailLabel1.text = feedName;

    // Create the article date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *articleDate = [dateFormatter stringFromDate:feedItem.date];
    cell.detailLabel2.text = articleDate;
    
    // Set the thumbnail image
    UIImage *image = [self.aggregator firstImageForArticle:feedItem];
    // We only want the image if it's at least as big as our thumbnail size
    if (image && image.size.width >= THUMBNAIL_SIZE && image.size.height >= THUMBNAIL_SIZE) {
        image = [UIImage squareImageWithDimension:THUMBNAIL_SIZE fromImage:image];
        cell.thumbnailImageView.image = image;
    } else {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"thumbnailPlaceholder"];
    }
    
    return cell;
}

#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MWFeedItem *feedItem = [self.feedArticles objectAtIndex:[indexPath row]];
    MWFeedItem *feedItem = [self.aggregator.allArticles objectAtIndex:[indexPath row]+self.rangeOfArticlesToShow.location];
    NSString *text = feedItem.title;
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:CGSizeMake(189.0, CGFLOAT_MAX)];
    
    return MAX(THUMBNAIL_SIZE+20.0, size.height+70.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MWFeedItem *article = [self.feedArticles objectAtIndex:indexPath.row];
    MWFeedItem *article = [self.aggregator.allArticles objectAtIndex:indexPath.row+self.rangeOfArticlesToShow.location];
   // NSLog(@"about to show article %d with title %@", indexPath.row+self.rangeOfArticlesToShow.location, article.title);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (!self.detailView) {
            self.detailView = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:kArticleDetailViewIdentifier];
        }
        [self.navigationController pushViewController:self.detailView animated:YES];

    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (!self.detailView) {
            self.detailView = [self.splitViewController.viewControllers objectAtIndex:1];
        }
    }
    [self.detailView setContentForArticle:article];
}

@end
