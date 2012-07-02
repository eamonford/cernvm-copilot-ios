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

@interface PhotosViewController ()

@end

@implementation PhotosViewController
@synthesize photoURLs;

BOOL isLoadingXML = YES;
BOOL done = NO;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.photoURLs = [NSMutableArray array];
        //thumbnailDownloadConnections = [NSMutableArray array];
        //thumbnailData = [NSMutableArray array];
        thumbnailImages = [NSMutableDictionary dictionary];
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.backgroundColor = [UIColor whiteColor];
    self.gridView.separatorStyle = AQGridViewCellSeparatorStyleNone;
    
    CernMediaMARCParser *marcParser = [[CernMediaMARCParser alloc] init];
    marcParser.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Press+Office+Photo+Selection&p=&f=&action_search=Search&c=Press+Office+Photo+Selection&c=&sf=&so=d&rm=&rg=10&sc=1&of=xm"];
    marcParser.resourceTypes = [NSArray arrayWithObjects:@"jpgA4", @"jpgA5", @"jpgIcon", nil];
    marcParser.delegate = self;
    
    [marcParser parse];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark CernMediaMARCParserDelegate methods

- (void)parser:(CernMediaMARCParser *)parser didParseMediaItem:(NSDictionary *)mediaItem
{
    if (isLoadingXML) {
        isLoadingXML = NO;
        self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
        self.gridView.resizesCellWidthToFit = YES;
    }
    [self.photoURLs addObject:mediaItem];
    int index = self.photoURLs.count-1;
    NSURLRequest *request = [NSURLRequest requestWithURL:[mediaItem objectForKey:@"jpgIcon"]];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         UIImage *thumbnailImage = [UIImage imageWithData:data];
         [thumbnailImages setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];

         if (parser.isFinishedParsing)
             [self performSelectorOnMainThread:@selector(reloadCellAtIndex:) 
                                    withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];

     }];
}

- (void)reloadCellAtIndex:(NSNumber *)index
{
    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:[index intValue]] withAnimation:AQGridViewItemAnimationTop];
}

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    [self.gridView reloadData];
}
/*
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    int thumbnailIndex = [thumbnailDownloadConnections indexOfObject:connection];
    if (thumbnailIndex != NSNotFound) {
        [[thumbnailData objectAtIndex:thumbnailIndex] appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    int thumbnailIndex = [thumbnailDownloadConnections indexOfObject:connection];
    if (thumbnailIndex != NSNotFound) {
        UIImage *thumbnailImage = [UIImage imageWithData:[thumbnailData objectAtIndex:thumbnailIndex]];
        [thumbnailImages setObject:thumbnailImage forKey:[NSNumber numberWithInt:thumbnailIndex]];
        
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:thumbnailIndex] withAnimation:AQGridViewItemAnimationTop];
    }
}

*/
#pragma mark AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    if (isLoadingXML)
        return 1;
    else
        return self.photoURLs.count;
}
- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    if (isLoadingXML) {
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
        cell.image = [thumbnailImages objectForKey:[NSNumber numberWithInt:index]];

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
    if (isLoadingXML)
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
    if (isLoadingXML) {
        return [UIScreen mainScreen].bounds.size;
    } else {
        return CGSizeMake(50.0, 50.0);
    }
}

#pragma mark MWPhotoBrowserDelegate methods

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoURLs.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photoURLs.count) {
        NSURL *url = [[self.photoURLs objectAtIndex:index] objectForKey:@"jpgA5"];
        return [MWPhoto photoWithURL:url];
    }
    
    return nil;
}

@end
