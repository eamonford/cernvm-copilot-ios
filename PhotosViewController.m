//
//  PhotosViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/27/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "PhotosViewController.h"
#import "CernMediaMARCParser.h"
#import "PhotoGridViewCell.h"
#import "AppDelegate.h"
@interface PhotosViewController ()

@end

@implementation PhotosViewController
@synthesize photoDownloader;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //appDelegate = [UIApplication sharedApplication].delegate;
        //appDelegate.photoDownloader.delegate = self;
        displaySpinner = YES;
        self.photoDownloader = [[PhotoDownloader alloc] init];
        self.photoDownloader.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.backgroundColor = [UIColor whiteColor];
    [self configureGridForSpinner:NO];
}

- (void)configureGridForSpinner:(BOOL)spinner
{
    displaySpinner = spinner;
    if (spinner) {
        self.gridView.separatorStyle = AQGridViewCellSeparatorStyleNone;
        self.gridView.resizesCellWidthToFit = NO;
    } else {
        self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
        self.gridView.resizesCellWidthToFit = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refresh
{
    if (self.photoDownloader.urls.count == 0) {
        [self configureGridForSpinner:YES];
        [self.photoDownloader parse];
    }
}

#pragma mark - Interface methods

- (void)reloadCellAtIndex:(NSNumber *)index
{
    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:[index intValue]] withAnimation:AQGridViewItemAnimationTop];
}

#pragma mark - PhotoDownloaderDelegate methods

- (void)photoDownloaderDidFinish:(PhotoDownloader *)photoDownloader
{
    NSLog(@"photo downloader finished");
    [self configureGridForSpinner:NO];
    [self.gridView reloadData];
}

- (void)photoDownloader:(PhotoDownloader *)photoDownloader didDownloadThumbnailForIndex:(int)index
{
    [self performSelectorOnMainThread:@selector(reloadCellAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
}

#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    if (displaySpinner) {
        return 1;
    } else {
        //return appDelegate.photoDownloader.urls.count;
        return self.photoDownloader.urls.count;

    }
}
- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    if (displaySpinner) {
        static NSString *loadingCellIdentifier = @"loadingCell";
        AQGridViewCell *cell = [self.gridView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
        if (cell == nil) {
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell = [[AQGridViewCell alloc] initWithFrame:spinner.frame reuseIdentifier:loadingCellIdentifier];
            [spinner startAnimating];
            [cell.contentView addSubview:spinner];
            cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        }
        return cell;

    } else {
        static NSString *photoCellIdentifier = @"photoCell";
        PhotoGridViewCell *cell = (PhotoGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:photoCellIdentifier];
        if (cell == nil) {
            cell = [[PhotoGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0) reuseIdentifier:photoCellIdentifier];
            cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        }
        //cell.image = [appDelegate.photoDownloader.thumbnails objectForKey:[NSNumber numberWithInt:index]];
        cell.image = [self.photoDownloader.thumbnails objectForKey:[NSNumber numberWithInt:index]];
        return cell;
    }
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    if (displaySpinner)
        return;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    [browser setInitialPageIndex:index];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browser];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:navigationController animated:YES];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    if (displaySpinner) {
        return [UIScreen mainScreen].bounds.size;
    } else {
        return CGSizeMake(50.0, 50.0);
    }
}

#pragma mark - MWPhotoBrowserDelegate methods

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    //return appDelegate.photoDownloader.urls.count;
    return self.photoDownloader.urls.count;

}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    //if (index < appDelegate.photoDownloader.urls.count) {
    if (index < self.photoDownloader.urls.count) {

        //NSURL *url = [[appDelegate.photoDownloader.urls objectAtIndex:index] objectForKey:@"jpgA5"];
        NSURL *url = [[self.photoDownloader.urls objectAtIndex:index] objectForKey:@"jpgA5"];
        return [MWPhoto photoWithURL:url];
    }
    
    return nil;
}

@end
