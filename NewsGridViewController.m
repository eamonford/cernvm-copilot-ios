//
//  NewsGridViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/7/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "NewsGridViewController.h"
#import "NewsGridViewCell.h"
#import "ArticleDetailViewController.h"

@interface NewsGridViewController ()

@end

@implementation NewsGridViewController
@synthesize rangeOfArticlesToShow;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.gridView.resizesCellWidthToFit = NO;
        self.gridView.backgroundColor = [UIColor whiteColor];
        self.gridView.allowsSelection = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ArticleDetailViewController *viewController = (ArticleDetailViewController *)segue.destinationViewController;
    [viewController setContentForArticle:[self.aggregator.allArticles objectAtIndex:[self.gridView indexOfSelectedItem]]];
}

#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    if (displaySpinner) {
        return 1;
    } else {
        if (self.rangeOfArticlesToShow.length)
            return self.rangeOfArticlesToShow.length;
        else
            return self.aggregator.allArticles.count;
    }
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    if (displaySpinner) {
        static NSString *loadingCellIdentifier = @"loadingCell";
        AQGridViewCell *cell = [self.gridView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
        if (cell == nil) {
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell = [[AQGridViewCell alloc] initWithFrame:spinner.frame reuseIdentifier:loadingCellIdentifier];
            [spinner startAnimating];
            [cell.contentView addSubview:spinner];
            cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        }
        return cell;
        
    } else {
        MWFeedItem *article = [self.aggregator.allArticles objectAtIndex:index+self.rangeOfArticlesToShow.location];
        static NSString *newsCellIdentifier = @"newsCell";
        NewsGridViewCell *cell = (NewsGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:newsCellIdentifier];
        if (cell == nil) {
            cell = [[NewsGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 250.0) reuseIdentifier:newsCellIdentifier];
            cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = article.title;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *dateString = [dateFormatter stringFromDate:article.date];
        cell.dateLabel.text = dateString;
        
        UIImage *image = [self.aggregator firstImageForArticle:article];
        if (image) {
            cell.thumbnailImageView.image = image;
        }
        return cell;
    }
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    if (displaySpinner) {
        return [UIScreen mainScreen].bounds.size;
    } else {
        return CGSizeMake(320.0, 270.0);
    }
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    if (displaySpinner)
        return;
    [self performSegueWithIdentifier:@"ShowArticleDetails" sender:self];
}
#pragma mark - RSSAggregatorDelegate methods

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)theAggregator
{
    [super allFeedsDidLoadForAggregator:theAggregator];
    [self.gridView reloadData];
}

- (void)aggregator:(RSSAggregator *)aggregator didDownloadFirstImage:(UIImage *)image forArticle:(MWFeedItem *)article
{
    int index = [self.aggregator.allArticles indexOfObject:article]+self.rangeOfArticlesToShow.location;
    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];
}

@end
