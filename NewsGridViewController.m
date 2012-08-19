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
#import "NSString+HTML.h"

#define MIN_IMAGE_WIDTH 300.0
#define MIN_IMAGE_HEIGHT 125.0

@interface NewsGridViewController ()

@end

@implementation NewsGridViewController
//@synthesize rangeOfArticlesToShow;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.gridView.resizesCellWidthToFit = NO;
        self.gridView.backgroundColor = [UIColor whiteColor];
        self.gridView.allowsSelection = YES;
    }
    return self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ArticleDetailViewController *viewController = (ArticleDetailViewController *)segue.destinationViewController;
    [viewController setContentForArticle:[self.aggregator.allArticles objectAtIndex:self.gridView.indexOfSelectedItem]];
    [self.gridView deselectItemAtIndex:self.gridView.indexOfSelectedItem animated:YES];
}

#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    if (self.rangeOfArticlesToShow.length)
        return self.rangeOfArticlesToShow.length;
    else
        return self.aggregator.allArticles.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    MWFeedItem *article = [self.aggregator.allArticles objectAtIndex:index+self.rangeOfArticlesToShow.location];
    static NSString *newsCellIdentifier = @"newsCell";
    NewsGridViewCell *cell = (NewsGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:newsCellIdentifier];
    if (cell == nil) {
        cell = [[NewsGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 250.0) reuseIdentifier:newsCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
    }
    cell.titleLabel.text = [article.title stringByConvertingHTMLToPlainText];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [dateFormatter stringFromDate:article.date];
    cell.dateLabel.text = dateString;
    
    UIImage *image = [self.aggregator firstImageForArticle:article];
    if (image && image.size.width >= MIN_IMAGE_WIDTH && image.size.height >= MIN_IMAGE_HEIGHT) {
        cell.thumbnailImageView.image = image;
    } else {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(320.0, 270.0);
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex:(NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
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
