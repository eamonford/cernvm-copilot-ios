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
//@synthesize photoURLs;
AppDelegate *appDelegate;
BOOL displaySpinner = YES;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.photoDownloader.delegate = self;
        //queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.backgroundColor = [UIColor whiteColor];
    
    /*CernMediaMARCParser *marcParser = [[CernMediaMARCParser alloc] init];
    marcParser.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Press+Office+Photo+Selection&p=&f=&action_search=Search&c=Press+Office+Photo+Selection&c=&sf=&so=d&rm=&rg=10&sc=1&of=xm"];
    marcParser.resourceTypes = [NSArray arrayWithObjects:@"jpgA5", @"jpgIcon", nil];
    marcParser.delegate = self;
    */
    if (appDelegate.photoDownloader.urls.count == 0) {
        [self configureGridForSpinner:YES];
        //[marcParser parse];
        appDelegate.photoDownloader.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Press+Office+Photo+Selection&p=&f=&action_search=Search&c=Press+Office+Photo+Selection&c=&sf=&so=d&rm=&rg=10&sc=1&of=xm"];
        [appDelegate.photoDownloader parse];
        
    } else {
        [self configureGridForSpinner:NO];
    }
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

#pragma mark - Interface methods

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)reloadCellAtIndex:(NSNumber *)index
{
    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:[index intValue]] withAnimation:AQGridViewItemAnimationTop];
}

#pragma mark - PhotoDownloaderDelegate methods

- (void)photoDownloaderDidFinish:(PhotoDownloader *)photoDownloader
{
    [self configureGridForSpinner:NO];
    [self.gridView reloadData];
}

- (void)photoDownloader:(PhotoDownloader *)photoDownloader didDownloadThumbnailForIndex:(int)index
{
    [self performSelectorOnMainThread:@selector(reloadCellAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
}

/*
#pragma mark CernMediaMARCParserDelegate methods

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)mediaItem
{
    [self configureGridForSpinner:NO];
    
    [appDelegate.photoURLs addObject:mediaItem];
    int index = appDelegate.photoURLs.count-1;
    NSURLRequest *request = [NSURLRequest requestWithURL:[mediaItem objectForKey:@"jpgIcon"]];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         UIImage *thumbnailImage = [UIImage imageWithData:data];
         [appDelegate.photoThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];

         if (parser.isFinishedParsing)
             [self performSelectorOnMainThread:@selector(reloadCellAtIndex:) 
                                    withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];

     }];
}



- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    [self.gridView reloadData];
}
*/

#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    if (displaySpinner) {
        return 1;
    } else {
        return appDelegate.photoDownloader.urls.count;
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
        cell.image = [appDelegate.photoDownloader.thumbnails objectForKey:[NSNumber numberWithInt:index]];

        return cell;
    }
}

/*- (UIImage *)thumbnailForCellAtIndex:(int)index
{
    if (index < thumbnailImages.count) {
       // return [thumbnailImages objectAtIndex:index];
    } else {
        NSLog(@"loading thumb");
        NSURLRequest *request = [NSURLRequest requestWithURL:[[self.photoURLs objectAtIndex:index] objectForKey:@"jpgIcon"]];
        [thumbnailData addObject:[[NSMutableData alloc] init]];
        [thumbnailDownloadConnections addObject:[NSURLConnection connectionWithRequest:request delegate:self]];
        return nil;
    }
}*/

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
    return appDelegate.photoDownloader.urls.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < appDelegate.photoDownloader.urls.count) {
        NSURL *url = [[appDelegate.photoDownloader.urls objectAtIndex:index] objectForKey:@"jpgA5"];
        return [MWPhoto photoWithURL:url];
    }
    
    return nil;
}

@end
