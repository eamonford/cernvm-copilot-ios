//
//  GeneralNewsTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "GeneralNewsTableViewController.h"
#import "NSString+HTML.h"
#import "ArticleDetailViewController.h"
#import "ArticleTableViewCell.h"

@interface GeneralNewsTableViewController ()

@end

@implementation GeneralNewsTableViewController
@synthesize aggregator, feedArticles;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feedArticles = [NSArray array];
    self.aggregator = [[RSSAggregator alloc] init];
    self.aggregator.delegate = self;
    [self.aggregator addFeedForURL:[NSURL URLWithString:@"http://feeds.feedburner.com/CernCourier"]];
    [self.aggregator addFeedForURL:[NSURL URLWithString:@"http://cdsweb.cern.ch/rss?cc=Weekly+Bulletin&ln=en&c=Breaking%20News&c=News%20Articles&c=Official%20News&c=Training%20and%20Development&c=General%20Information&c=Bulletin%20Announcements&c=Bulletin%20Events"]];
    
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

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
    self.feedArticles = [sender aggregate];
    [self.tableView reloadData];
}


@end
