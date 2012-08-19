//
//  WebcastsGridViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/16/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "WebcastsGridViewController.h"
#import "MBProgressHUD.h"
#import "NewsGridViewCell.h"
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WebcastsGridViewController ()

@end

@implementation WebcastsGridViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.gridView.backgroundColor = [UIColor whiteColor];
        
        _noConnectionHUD.delegate = self;
        _noConnectionHUD.mode = MBProgressHUDModeText;
        _noConnectionHUD.labelText = @"No internet connection";
        _noConnectionHUD.removeFromSuperViewOnHide = YES;
        
        self.parser = [[WebcastsParser alloc] init];
        self.parser.delegate = self;
        [self refresh];
    }
    return self;
}

- (void)refresh
{
    if (!self.parser.recentWebcasts.count && !self.parser.upcomingWebcasts.count) {
        [_noConnectionHUD hide:YES];

        self.finishedParsingRecent = NO;
        self.finishedParsingUpcoming = NO;
        
        [self.parser parseRecentWebcasts];
        [self.parser parseUpcomingWebcasts];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)hudWasTapped:(MBProgressHUD *)hud
{
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender
{
    self.mode = sender.selectedSegmentIndex;
    if (self.mode == WebcastModeRecent)
        self.gridView.allowsSelection = YES;
    else
        self.gridView.allowsSelection = NO;
    
    [self.gridView reloadData];
}

#pragma mark WebcastsParserDelegate methods

- (void)webcastsParserDidFinishParsingRecentWebcasts:(WebcastsParser *)parser
{
    self.finishedParsingRecent = YES;
    if (self.finishedParsingUpcoming)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.mode == WebcastModeRecent) {
        [self.gridView reloadData];
    }
}

- (void)webcastsParserDidFinishParsingUpcomingWebcasts:(WebcastsParser *)parser
{
    self.finishedParsingUpcoming = YES;
    if (self.finishedParsingRecent)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.mode == WebcastModeUpcoming) {
        [self.gridView reloadData];
    }
}

- (void)webcastsParser:(WebcastsParser *)parser didDownloadThumbnailForRecentWebcastIndex:(int)index
{
    if (self.mode == WebcastModeRecent)
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];
}

- (void)webcastsParser:(WebcastsParser *)parser didDownloadThumbnailForUpcomingWebcastIndex:(int)index
{
    if (self.mode == WebcastModeUpcoming)
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];
}

- (void)webcastsParser:(WebcastsParser *)parser didFailWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	_noConnectionHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _noConnectionHUD.delegate = self;
    _noConnectionHUD.mode = MBProgressHUDModeText;
    _noConnectionHUD.labelText = @"No internet connection";
    _noConnectionHUD.removeFromSuperViewOnHide = YES;
}

#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    switch (self.mode) {
        case WebcastModeRecent:
            return self.parser.recentWebcasts.count;
        case WebcastModeUpcoming:
            return self.parser.upcomingWebcasts.count;
        default:
            return 0;
    }
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *newsCellIdentifier = @"newsCell";
    NewsGridViewCell *cell = (NewsGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:newsCellIdentifier];
    if (cell == nil) {
        cell = [[NewsGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 180.0) reuseIdentifier:newsCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
        cell.titleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    
    
    
    NSDictionary *webcast;
    switch (self.mode) {
        case WebcastModeRecent: {
            webcast = [self.parser.recentWebcasts objectAtIndex:index];

            // Set the title label
            cell.titleLabel.text = [webcast objectForKey:@"title"];
            
 
            // Set the thumbnail
            UIImage *image = [self.parser.recentWebcastThumbnails objectForKey:[NSNumber numberWithInt:index]];
            if (image) {
                cell.thumbnailImageView.image = image;
            } else {
                cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder"];
            }
            break;
        }
        case WebcastModeUpcoming: {
            webcast = [self.parser.upcomingWebcasts objectAtIndex:index];

            // Set the title label
            cell.titleLabel.text = [webcast objectForKey:@"title"];

            // Set the thumbnail
            UIImage *image = [self.parser.upcomingWebcastThumbnails objectForKey:[NSNumber numberWithInt:index]];
            if (image) {
                cell.thumbnailImageView.image = image;
            } else {
                cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder"];
            }
            
            break;
        }
        default:
            break;
    }
    // Set the date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [dateFormatter stringFromDate:[webcast objectForKey:@"date"]];
    cell.dateLabel.text = dateString;

  return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(200.0, 200.0);
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    [gridView deselectItemAtIndex:index animated:YES];
    
    if (self.mode == WebcastModeRecent) {
        NSDictionary *webcast = [self.parser.recentWebcasts objectAtIndex:index];
        NSDictionary *resources = [webcast objectForKey:@"resources"];
        NSURL *url = [[NSURL alloc] init];
        if ([resources objectForKey:kVideoMetadataPropertyVideoURL])
            url = [[resources objectForKey:kVideoMetadataPropertyVideoURL] objectAtIndex:0];
        else
            url = [[resources objectForKey:@"mp4mobile"] objectAtIndex:0];
        MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        
        if (self.parentViewController)
            [self.parentViewController presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
        else
            [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
    }
}

@end
