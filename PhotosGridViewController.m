//
//  PhotosViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/27/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "PhotosGridViewController.h"
#import "CernMediaMARCParser.h"
#import "PhotoGridViewCell.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface PhotosGridViewController ()

@end

@implementation PhotosGridViewController
@synthesize photoDownloader;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.photoDownloader = [[PhotoDownloader alloc] init];
        self.photoDownloader.delegate = self;
        self.gridView.backgroundColor = [UIColor whiteColor];
        self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
        self.gridView.resizesCellWidthToFit = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.photoDownloader.urls = nil;
    self.photoDownloader.thumbnails = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refresh
{
    if (self.photoDownloader.urls.count == 0) {
        NSLog(@"refreshing");
        [_noConnectionHUD hide:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.gridView reloadData];
}

- (void)photoDownloader:(PhotoDownloader *)photoDownloader didDownloadThumbnailForIndex:(int)index
{
    [self performSelectorOnMainThread:@selector(reloadCellAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
}

#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
        return self.photoDownloader.urls.count;
}
- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *photoCellIdentifier = @"photoCell";
    PhotoGridViewCell *cell = (PhotoGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:photoCellIdentifier];
    if (cell == nil) {
        cell = [[PhotoGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0) reuseIdentifier:photoCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleNone;
    }
    cell.imageView.image = [self.photoDownloader.thumbnails objectForKey:[NSNumber numberWithInt:index]];
    //cell.imageView.image = [UIImage imageNamed:@"cernLogo"];
    return cell;
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    [browser setInitialPageIndex:index];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browser];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:navigationController animated:YES];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{

    return CGSizeMake(100.0, 100.0);
}

#pragma mark - MWPhotoBrowserDelegate methods

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoDownloader.urls.count;

}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photoDownloader.urls.count) {
        NSURL *url = [[self.photoDownloader.urls objectAtIndex:index] objectForKey:@"jpgA5"];
        return [MWPhoto photoWithURL:url];
    }
    
    return nil;
}

- (void)photoDownloader:(PhotoDownloader *)photoDownloader didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	_noConnectionHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _noConnectionHUD.delegate = self;
    _noConnectionHUD.mode = MBProgressHUDModeText;
    _noConnectionHUD.labelText = @"No internet connection";
    _noConnectionHUD.removeFromSuperViewOnHide = YES;
}

- (void)hudWasTapped:(MBProgressHUD *)hud
{
    [self refresh];
}

@end
