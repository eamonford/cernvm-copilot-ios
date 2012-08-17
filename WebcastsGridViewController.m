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
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.parser = [[WebcastsParser alloc] init];
        self.parser.delegate = self;
        [self.parser parseRecent];
    }
    return self;
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

- (void)webcastsParser:(WebcastsParser *)parser didParseRecentItem:(NSDictionary *)item
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.gridView reloadData];

}

- (void)webcastsParserDidFinishParsingParsingRecentWebcasts:(WebcastsParser *)parser
{
    [self.gridView reloadData];
}


#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.parser.recentWebcasts.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *newsCellIdentifier = @"newsCell";
    NewsGridViewCell *cell = (NewsGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:newsCellIdentifier];
    if (cell == nil) {
        cell = [[NewsGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 180.0) reuseIdentifier:newsCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleNone;
    }
    
    NSDictionary *webcast = [self.parser.recentWebcasts objectAtIndex:index];
    
    // Set the title label
    cell.titleLabel.text = [webcast objectForKey:@"title"];
    
    // Set the date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [dateFormatter stringFromDate:[webcast objectForKey:@"date"]];
    cell.dateLabel.text = dateString;
    
    // Set the thumbnail
    UIImage *image = [self.parser.recentWebcastThumbnails objectForKey:[NSNumber numberWithInt:index]];
    if (image) {
        cell.thumbnailImageView.image = image;
    } else {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder"];
   }

  return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(200.0, 200.0);
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    NSDictionary *webcast = [self.parser.recentWebcasts objectAtIndex:index];
    NSDictionary *resources = [webcast objectForKey:@"resources"];
    NSURL *url = [[NSURL alloc] init];
    if ([resources objectForKey:kVideoMetadataPropertyVideoURL])
        url = [[resources objectForKey:kVideoMetadataPropertyVideoURL] objectAtIndex:0];
    else
        url = [[resources objectForKey:@"mp4mobile"] objectAtIndex:0];
    NSLog(@"url: %@", url);
    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    if (self.parentViewController)
        [self.parentViewController presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
    else
        [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
}

@end
