//
//  ExperimentTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ExperimentTableViewController.h"
#import "TwitterFeed.h"
#import "ArticleTableViewCell.h"
#import "ArticleDetailViewController.h"
#import "NSDate+InternetDateTime.h"
#import "NSString+HTML.h"
@interface ExperimentTableViewController ()

@end

@implementation ExperimentTableViewController
@synthesize feed, aggregator, feedArticles;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.feed = [[TwitterFeed alloc] init];
        self.feed.delegate = self;
        self.aggregator = [[RSSAggregator alloc] init];
        self.aggregator.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIViewController attemptRotationToDeviceOrientation];
    
    [self.feed refresh];
    [self.aggregator refreshAllFeeds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grayTexture.png"]];
    self.tableView.backgroundView = backgroundView;
    self.tableView.separatorColor = [UIColor lightGrayColor];
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
    if ([[segue identifier] isEqualToString:@"ShowTweetDetails"])
    {        
//        NSDictionary *tweet = [self.feed.posts objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        ArticleDetailViewController *detailViewController = [segue destinationViewController];
        MWFeedItem *article = [self.feedArticles objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [detailViewController setContentForArticle:article];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return self.feedArticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    ShadowedCell *cell;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"experimentInfoCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ShadowedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.position = ShadowedCellPositionSingle;
    } else {
        static NSString *CellIdentifier = @"experimentNewsCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];            
        }
        
        if (self.feedArticles.count == 1)
            ((ArticleTableViewCell *)cell).position = ShadowedCellPositionSingle;                
        else if (indexPath.row == 0)
            ((ArticleTableViewCell *)cell).position = ShadowedCellPositionTop;
        else if (indexPath.row == self.feedArticles.count-1)
            ((ArticleTableViewCell *)cell).position = ShadowedCellPositionBottom;
        else
            ((ArticleTableViewCell *)cell).position = ShadowedCellPositionMiddle;
                
        MWFeedItem *article = [self.feedArticles objectAtIndex:indexPath.row];
        ((ArticleTableViewCell *)cell).titleLabel.text = article.title;
        NSString *feedName = [self.aggregator feedForArticle:article].info.title;
        ((ArticleTableViewCell *)cell).feedLabel.text = feedName;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZ yyyy";
        NSDate *date = article.date;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *dateString = [dateFormatter stringFromDate:date];
        ((ArticleTableViewCell *)cell).dateLabel.text = dateString;
   }
        
    cell.cornerRadius = 5.0;
    cell.shadowSize = 2.0;
    //cell.borderColor = [UIColor greenColor];
    cell.fillColor = [UIColor whiteColor];
    cell.shadowColor = [UIColor darkGrayColor];

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
    if (indexPath.section == 0) {
        return 150.0;
    } else {
        NSString *text = [[self.feed.posts objectAtIndex:indexPath.row] objectForKey:@"text"];
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(260.0, CGFLOAT_MAX)];
        
        return size.height+60.0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = NO;
        CGRect labelFrame = CGRectMake(20.0, 0.0, [UIScreen mainScreen].bounds.size.width-20.0, [self tableView:self.tableView heightForHeaderInSection:section]);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.text = [self tableView:self.tableView titleForHeaderInSection:section];
        
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont boldSystemFontOfSize:13.0];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0.0, 1.0);
        [view addSubview:label];
        
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 50.0;
    } else {
        return 0.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Twitter Feed";
    }
    return nil;
}

- (void)feedDidLoad:(id)sender
{
    if ([sender class] == [TwitterFeed class]) {
        self.feed = sender;
        [self.tableView reloadData];
    }
}

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
    self.feedArticles = [sender aggregate];
    [self.tableView reloadData];
}

@end
