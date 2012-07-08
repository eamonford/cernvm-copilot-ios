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
@synthesize feed;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.feed = [[TwitterFeed alloc] init];
        self.feed.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIViewController attemptRotationToDeviceOrientation];
    
    [self.feed refresh];
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
        NSDictionary *tweet = [self.feed.posts objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        ArticleDetailViewController *detailViewController = [segue destinationViewController];
        [detailViewController setContentForTweet:tweet];
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
        return self.feed.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"experimentInfoCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    } else {
        static NSString *CellIdentifier = @"experimentNewsCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
            
        }
        NSDictionary *post = [self.feed.posts objectAtIndex:indexPath.row];
        
        ((ArticleTableViewCell *)cell).titleLabel.text = [post objectForKey:@"text"];
        ((ArticleTableViewCell *)cell).feedLabel.text = [NSString stringWithFormat:@"@%@", self.feed.screenName];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZ yyyy";
        NSDate *date = [dateFormatter dateFromString:[post objectForKey:@"created_at"]];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *dateString = [dateFormatter stringFromDate:date];
        ((ArticleTableViewCell *)cell).dateLabel.text = dateString;

   }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
        
        return size.height+50.0;
    }
}

- (void)feedDidLoad:(id)sender
{
    if ([sender class] == [TwitterFeed class]) {
        self.feed = sender;
        [self.tableView reloadData];
    }
}

@end
