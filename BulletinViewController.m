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

@interface BulletinViewController ()

@end

@implementation BulletinViewController
@synthesize issues;

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
    
    NSArray *articles = [self.aggregator aggregate];
    self.issues = [self feedArticlesSeparatedByWeek:articles];
    [self.tableView reloadData];
    
    [super allFeedsDidLoadForAggregator:sender];
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
    NewsTableViewController *viewController = [segue destinationViewController];
    NSIndexPath *issueIndexPath = [self.tableView indexPathForSelectedRow];
    NSArray *issueArticles = [[self.issues objectAtIndex:issueIndexPath.row] objectForKey:@"Articles"];
    viewController.feedArticles = issueArticles;
    [viewController loadAllArticleThumbnails];
    
    // Set the title of the new view controller to a string of the issue date
    NSDictionary *issue = [self.issues objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *issueDate = [dateFormatter stringFromDate:[issue objectForKey:@"Date"]];
    viewController.title = issueDate;

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
    return self.issues.count;
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
    
    NSDictionary *issue = [self.issues objectAtIndex:[indexPath row]];
    // Set the number of articles label
    int numberOfArticles = [[issue objectForKey:@"Articles"] count];
    NSMutableString *articlesString = [NSMutableString stringWithFormat:@"%d ", numberOfArticles];
    [articlesString appendString: numberOfArticles>1?@"articles":@"article"];
    cell.detailLabel1.text = articlesString;
    
    // Set the article title label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *issueDate = [dateFormatter stringFromDate:[issue objectForKey:@"Date"]];
    cell.titleLabel.text = [NSString stringWithFormat:@"Week of %@", issueDate];;
 
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

@end
