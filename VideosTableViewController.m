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
#import "Constants.h"

@interface VideosTableViewController ()

@end

@implementation VideosTableViewController
@synthesize videoMetadata, videoThumbnails, detailView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.videoMetadata = [NSMutableArray array];
        self.videoThumbnails = [NSMutableDictionary dictionary];
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CernMediaMARCParser *marcParser = [[CernMediaMARCParser alloc] init];
    marcParser.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Press+Office+Video+Selection&p=internalnote%3A%22ATLAS%22&f=&action_search=Search&c=Press+Office+Video+Selection&c=&sf=year&so=d&rm=&rg=100&sc=0&of=xm"];
    marcParser.resourceTypes = [NSArray arrayWithObjects:kVideoMetadataPropertyVideoURL, kVideoMetadataPropertyThumbnailURL, nil];
    marcParser.delegate = self;
    

    if (self.videoMetadata.count == 0) {
        [self showLoadingView];
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
}

#pragma mark - UI methods

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showLoadingView
{
    if (!loadingView) {
        loadingView = [[UIView alloc] init];
        loadingView.frame = self.tableView.bounds;    
        UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect frame = loadingView.frame;
        ac.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [loadingView addSubview:ac];
        [ac startAnimating];
        loadingView.backgroundColor = [UIColor whiteColor];
    }
    [self.tableView addSubview:loadingView];
}

- (void)hideLoadingView
{    
    [loadingView removeFromSuperview];
}

#pragma mark - CernMediaMARCParserDeleate methods

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    [self hideLoadingView];
    [self.tableView reloadData];
}

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)record
{
    // Copy over just the title, the date, and the first url of each resource type
    NSMutableDictionary *video = [NSMutableDictionary dictionary];
    [video setObject:[record objectForKey:@"title"] forKey:kVideoMetadataPropertyTitle];
    NSDate *date = [record objectForKey:@"date"];
    if (date)
        [video setObject:date forKey:kVideoMetadataPropertyDate];

    NSDictionary *resources = [record objectForKey:@"resources"];
    NSArray *resourceTypes = [resources allKeys];
    for (NSString *currentResourceType in resourceTypes) {
        NSURL *url = [[resources objectForKey:currentResourceType] objectAtIndex:0];
        [video setObject:url forKey:currentResourceType];
    }
    [self.videoMetadata addObject:video];
    // now download the thumbnail for that photo
    int index = self.videoMetadata.count-1;
    [self performSelectorInBackground:@selector(downloadThumbnailForIndex:) withObject:[NSNumber numberWithInt:index]];
}

// We will use a synchronous connection running in a background thread to download thumbnails
// because it is much simpler than handling an arbitrary number of asynchronous connections concurrently.
- (void)downloadThumbnailForIndex:(id)indexNumber
{
    // now download the thumbnail for that photo
    int index = ((NSNumber *)indexNumber).intValue;
    NSDictionary *video = [self.videoMetadata objectAtIndex:index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[video objectForKey:kVideoMetadataPropertyThumbnailURL]];
    NSData *thumbnailData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailData];
    [self.videoThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
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
    return self.videoMetadata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"videoCell";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *video = [self.videoMetadata objectAtIndex:indexPath.row];
    // Set the title label
    cell.titleLabel.text = [video objectForKey:kVideoMetadataPropertyTitle];
    
    // Set the date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [dateFormatter stringFromDate:[video objectForKey:kVideoMetadataPropertyDate]];
    cell.dateLabel.text = dateString;

    // Set the thumbnail
    cell.thumbnailImageView.image = [self.videoThumbnails objectForKey:[NSNumber numberWithInt:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *video = [self.videoMetadata objectAtIndex:indexPath.row];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSURL *url = [video objectForKey:kVideoMetadataPropertyVideoURL];
        MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];        
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (!self.detailView) {
            self.detailView = [self.splitViewController.viewControllers objectAtIndex:1];
        }
        [self.detailView setContentForVideoMetadata:video];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

@end
