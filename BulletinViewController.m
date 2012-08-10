//
//  BulletinViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/30/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "BulletinViewController.h"
#import "NSDate+LastOccurrenceOfWeekday.h"
#import "ArticleTableViewCell.h"
#import "NewsGridViewController.h"

@interface BulletinViewController ()

@end

@implementation BulletinViewController
@synthesize rangesOfArticlesSeparatedByWeek;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"BULLETIN");
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
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
}

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
    
    //NSLog(@"range: %@", [self rangesOfArticlesSeparatedByWeek:self.aggregator.allArticles]);
//    NSArray *articles = [self.aggregator aggregate];
    //NSArray *articles = self.aggregator.allArticles;
    //self.issues = [self feedArticlesSeparatedByWeek:articles];
    self.rangesOfArticlesSeparatedByWeek = [self calculateRangesOfArticlesSeparatedByWeek:self.aggregator.allArticles];
    [self.tableView reloadData];
    
    [super allFeedsDidLoadForAggregator:sender];
}

- (NSArray *)calculateRangesOfArticlesSeparatedByWeek:(NSArray *)articles
{
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
//    NSArray *sortedArticles = [articles sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

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

- (NSArray *)feedArticlesSeparatedByWeek:(NSArray *)articles
{
    NSMutableArray *weeks = [NSMutableArray array];
    
    for (MWFeedItem *article in articles) {
        NSDate *nextMonday = [[article.date midnight] nextOccurrenceOfWeekday:2];
        BOOL addedArticle = NO;
        for (NSMutableDictionary *issue in weeks) {
            // If there is already an issue from this week, add the article to that issue.
            if ([[issue objectForKey:@"Date"] isEqualToDate:nextMonday]) {
                NSMutableArray *issueArticles = [issue objectForKey:@"Articles"];
                [issueArticles addObject:article];
                addedArticle = YES;
                break;
            }
        }
        if (!addedArticle) {
            NSMutableDictionary *newIssue = [NSMutableDictionary dictionary];
            [newIssue setValue:nextMonday forKey:@"Date"];
            NSMutableArray *issueArticles = [NSMutableArray arrayWithObject:article];
            [newIssue setValue:issueArticles forKey:@"Articles"];
            [weeks addObject:newIssue];
        }

    }
    
    return weeks;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NewsGridViewController *viewController = [segue destinationViewController];
    NSIndexPath *issueIndexPath = [self.tableView indexPathForSelectedRow];
    viewController.aggregator = self.aggregator;
    viewController.aggregator.delegate = viewController;
    
    viewController.rangeOfArticlesToShow = [[self.rangesOfArticlesSeparatedByWeek objectAtIndex:issueIndexPath.row] rangeValue];
    [viewController.gridView reloadData];
    // Set the title of the new view controller to a string of the issue date
 /*   NSDictionary *issue = [self.issues objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *issueDate = [dateFormatter stringFromDate:[issue objectForKey:@"Date"]];
    viewController.title = issueDate;
*/
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
    return self.rangesOfArticlesSeparatedByWeek.count;
    //return self.issues.count;
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
    NSRange issueRange = [[self.rangesOfArticlesSeparatedByWeek objectAtIndex:indexPath.row] rangeValue];
    NSMutableString *articlesString = [NSMutableString stringWithFormat:@"%d ", issueRange.length];
    [articlesString appendString: issueRange.length>1?@"articles":@"article"];
    cell.detailLabel1.text = articlesString;
    
    // Set the article title label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    MWFeedItem *latestArticle = [self.aggregator.allArticles objectAtIndex:issueRange.location+issueRange.length-1];
    NSDate *issueDate = [[latestArticle.date midnight] nextOccurrenceOfWeekday:2];
    NSString *issueDateString = [dateFormatter stringFromDate:issueDate];
    cell.titleLabel.text = [NSString stringWithFormat:@"Week of %@", issueDateString];
 
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

@end
