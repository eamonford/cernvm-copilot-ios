//
//  VideosGridViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "VideosGridViewController.h"
#import "Constants.h"
#import "NewsGridViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"

@interface VideosGridViewController ()

@end

@implementation VideosGridViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.videoMetadata = [NSMutableArray array];
        self.videoThumbnails = [NSMutableDictionary dictionary];
        self.gridView.backgroundColor = [UIColor whiteColor];
        queue = [[NSOperationQueue alloc] init];
         
        self.parser = [[CernMediaMARCParser alloc] init];
        self.parser.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Press+Office+Video+Selection&p=internalnote%3A%22ATLAS%22&f=&action_search=Search&c=Press+Office+Video+Selection&c=&sf=year&so=d&rm=&rg=100&sc=0&of=xm"];
        self.parser.resourceTypes = [NSArray arrayWithObjects:kVideoMetadataPropertyVideoURL, kVideoMetadataPropertyThumbnailURL, nil];
        self.parser.delegate = self;
     }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}

- (void)refresh
{
    if (self.videoMetadata.count == 0) {
        [_noConnectionHUD hide:YES];
        [self.parser parse];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

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


- (void)hudWasTapped:(MBProgressHUD *)hud
{
    [self refresh];
}

#pragma mark - CernMediaMARCParserDeleate methods

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    NSLog(@"finished");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.gridView reloadData];
}

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)record
{
    NSLog(@"got record");
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

- (void)parser:(CernMediaMARCParser *)parser didFailWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	_noConnectionHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _noConnectionHUD.delegate = self;
    _noConnectionHUD.mode = MBProgressHUDModeText;
    _noConnectionHUD.labelText = @"No internet connection";
    _noConnectionHUD.removeFromSuperViewOnHide = YES;
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
    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index.intValue] withAnimation:AQGridViewItemAnimationFade];
}


#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.videoMetadata.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *newsCellIdentifier = @"newsCell";
    NewsGridViewCell *cell = (NewsGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:newsCellIdentifier];
    if (cell == nil) {
        cell = [[NewsGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 250.0) reuseIdentifier:newsCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
    }
    
    NSDictionary *video = [self.videoMetadata objectAtIndex:index];

    // Set the title label
    cell.titleLabel.text = [video objectForKey:kVideoMetadataPropertyTitle];
    
    // Set the date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *dateString = [dateFormatter stringFromDate:[video objectForKey:kVideoMetadataPropertyDate]];
    cell.dateLabel.text = dateString;

    // Set the thumbnail
    
    
    UIImage *image = [self.videoThumbnails objectForKey:[NSNumber numberWithInt:index]];
    if (image) {
        cell.thumbnailImageView.image = image;
    }
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(320.0, 270.0);
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    [gridView deselectItemAtIndex:index animated:YES];
    NSDictionary *video = [self.videoMetadata objectAtIndex:index];
    NSURL *url = [video objectForKey:kVideoMetadataPropertyVideoURL];
    MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];

}

@end
