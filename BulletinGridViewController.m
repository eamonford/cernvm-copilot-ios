//
//  BulletinGridViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "BulletinGridViewController.h"
#import "NSDate+LastOccurrenceOfWeekday.h"
#import "BulletinGridViewCell.h"
#import "NewsGridViewController.h"

@interface BulletinGridViewController ()

@end

@implementation BulletinGridViewController
//@synthesize rangesOfArticlesSeparatedByWeek;

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
	// Do any additional setup after loading the view.
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

- (NSArray *)calculateRangesOfArticlesSeparatedByWeek:(NSArray *)articles
{
    NSMutableArray *issues = [NSMutableArray array];
    NSRange currentRange = NSMakeRange(0, 0);
    MWFeedItem *firstArticle = [articles objectAtIndex:0];
    NSDate *currentIssueDate = [[firstArticle.date midnight] nextOccurrenceOfWeekday:2];
    
    for (int i=0; i<articles.count; i++) {
        
        MWFeedItem *article = [articles objectAtIndex:i];
        NSDate *oneWeekLater = [article.date dateByAddingTimeInterval:60*60*24*7];
        // if the current article is within a week of the current issue date, add it to the current issue
        if ([oneWeekLater compare:currentIssueDate] == NSOrderedDescending) {
            currentRange.length++;
        } else {    // otherwise, it's time to store the current issue and start a new issue
            NSValue *rangeValue = [NSValue valueWithRange:currentRange];
            [issues addObject:rangeValue];
            currentIssueDate = [[article.date midnight] nextOccurrenceOfWeekday:2];
            currentRange.location = i;
            currentRange.length = 1;
        }
    }
    NSValue *rangeValue = [NSValue valueWithRange:currentRange];
    [issues addObject:rangeValue];
    
    return issues;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NewsGridViewController *viewController = [segue destinationViewController];
    NSUInteger issueIndex = [self.gridView indexOfSelectedItem];
    viewController.aggregator = self.aggregator;
    viewController.aggregator.delegate = viewController;
    
    viewController.rangeOfArticlesToShow = [[self.rangesOfArticlesSeparatedByWeek objectAtIndex:issueIndex] rangeValue];
    [viewController.gridView reloadData];
    
    [self.gridView deselectItemAtIndex:self.gridView.indexOfSelectedItem animated:YES];
}

#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.rangesOfArticlesSeparatedByWeek.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *bulletinCellIdentifier = @"bulletinCell";

    BulletinGridViewCell *cell = (BulletinGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:bulletinCellIdentifier];
    if (cell == nil) {
        cell = [[BulletinGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 120.0) reuseIdentifier:bulletinCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
    }
    
    NSRange issueRange = [[self.rangesOfArticlesSeparatedByWeek objectAtIndex:index] rangeValue];
    NSMutableString *articlesString = [NSMutableString stringWithFormat:@"%d ", issueRange.length];
    [articlesString appendString: issueRange.length>1?@"articles":@"article"];
    cell.descriptionLabel.text = articlesString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    MWFeedItem *latestArticle = [self.aggregator.allArticles objectAtIndex:issueRange.location+issueRange.length-1];
    NSDate *issueDate = [[latestArticle.date midnight] nextOccurrenceOfWeekday:2];
    NSString *issueDateString = [dateFormatter stringFromDate:issueDate];
    cell.titleLabel.text = [NSString stringWithFormat:@"Week of %@", issueDateString];
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
        return CGSizeMake(320.0, 140.0);
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    [self performSegueWithIdentifier:@"ShowBulletinArticles" sender:self];
}

#pragma mark - RSSAggregatorDelegate methods

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
    [super allFeedsDidLoadForAggregator:sender];
    self.rangesOfArticlesSeparatedByWeek = [self calculateRangesOfArticlesSeparatedByWeek:self.aggregator.allArticles];
    [self.gridView reloadData];
}

@end
