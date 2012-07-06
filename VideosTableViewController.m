//
//  VideosTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/3/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "VideosTableViewController.h"
#import "AppDelegate.h"
#import "VideoTableViewCell.h"
@interface VideosTableViewController ()

@end

@implementation VideosTableViewController

AppDelegate *appDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        appDelegate = [UIApplication sharedApplication].delegate;
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup loading view
    loadingView = [[UIView alloc] init];
    loadingView.frame = self.tableView.bounds;    
    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = loadingView.frame;
    ac.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    [loadingView addSubview:ac];
    [ac startAnimating];
    
    loadingView.backgroundColor = [UIColor whiteColor];
    CernMediaMARCParser *marcParser = [[CernMediaMARCParser alloc] init];
    marcParser.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Press+Office+Video+Selection&p=internalnote%3A%22ATLAS%22&f=&action_search=Search&c=Press+Office+Video+Selection&c=&sf=year&so=d&rm=&rg=100&sc=0&of=xm"];
    marcParser.resourceTypes = [NSArray arrayWithObjects:@"mp40600", @"jpgthumbnail", nil];
    marcParser.delegate = self;
    

    if (appDelegate.videoMetadata.count == 0) {
        [self.tableView addSubview:loadingView];
        [marcParser parse];
    }
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

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)showSpinnerView
{
    loadingView.hidden = NO;
}

- (void)hideSpinnerView
{
    loadingView.hidden = YES;
}

#pragma mark - CernMediaMARCParserDeleate methods

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    NSLog(@"about to hide loading view");
    if (loadingView == nil) 
        NSLog(@"nil loading view!");
    [loadingView removeFromSuperview];
    [self.tableView reloadData];
}

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)record
{
    // Copy over just the title and the first url of each resource type
    NSMutableDictionary *video = [NSMutableDictionary dictionary];
    [video setObject:[record objectForKey:@"title"] forKey:@"title"];

    NSDictionary *resources = [record objectForKey:@"resources"];
    NSArray *resourceTypes = [resources allKeys];
    for (NSString *currentResourceType in resourceTypes) {
        NSURL *url = [[resources objectForKey:currentResourceType] objectAtIndex:0];
        [video setObject:url forKey:currentResourceType];
    }
    [appDelegate.videoMetadata addObject:video];
    // now download the thumbnail for that photo
    int index = appDelegate.videoMetadata.count-1;
    [self performSelectorInBackground:@selector(downloadThumbnailForIndex:) withObject:[NSNumber numberWithInt:index]];
    /*NSURLRequest *request = [NSURLRequest requestWithURL:[video objectForKey:@"jpgthumbnail"]];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         UIImage *thumbnailImage = [UIImage imageWithData:data];
         [appDelegate.videoThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
         [self performSelectorOnMainThread:@selector(reloadRowAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
     }];*/

}

// We will use a synchronous connection running in a background thread to download thumbnails
// because it is much simpler than handling an arbitrary number of asynchronous connections concurrently.
- (void)downloadThumbnailForIndex:(id)indexNumber
{
    // now download the thumbnail for that photo
    int index = ((NSNumber *)indexNumber).intValue;
    NSDictionary *video = [appDelegate.videoMetadata objectAtIndex:index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[video objectForKey:@"jpgthumbnail"]];
    NSData *thumbnailData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailData];
    [appDelegate.videoThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
    [self performSelectorOnMainThread:@selector(reloadRowAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
}

- (void)reloadRowAtIndex:(NSNumber *)index
{
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index.intValue inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.videoMetadata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"videoCell";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *video = [appDelegate.videoMetadata objectAtIndex:indexPath.row];
    // Set the video title label
    cell.titleLabel.text = [video objectForKey:@"title"];
        
    /*// Create the article date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *articleDate = [dateFormatter stringFromDate:feedItem.date];
    cell.dateLabel.text = articleDate;
    */
    cell.thumbnailImageView.image = [appDelegate.videoThumbnails objectForKey:[NSNumber numberWithInt:indexPath.row]];
    
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
    NSURL *url = [[appDelegate.videoMetadata objectAtIndex:indexPath.row] objectForKey:@"mp40600"];
    MPMoviePlayerViewController * playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
    
//    playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    [playerController.moviePlayer play];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

@end
