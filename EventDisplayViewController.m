//
//  EventDisplayViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/15/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "EventDisplayViewController.h"

#define SOURCE_DESCRIPTION @"Description"
#define SOURCE_URL @"URL"
#define SOURCE_BOUNDARY_RECTS @"Boundaries"
#define RESULT_IMAGE @"Image"
#define RESULT_LAST_UPDATED @"Last Updated"

@interface EventDisplayViewController ()

@end

@implementation EventDisplayViewController
@synthesize segmentedControl, barButtonItem, sources, results, scrollView, pageControl;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.sources = [NSMutableArray array];
        numPages = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageControl.numberOfPages = numPages;
    
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*numPages, 1.0);
    asyncData = [[NSMutableData alloc] init];
    [self refresh:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)refresh:(id)sender
{
   // [self showLoadingView];
    self.results = [NSMutableArray array];

    for (NSDictionary *source in self.sources) {
        // ASYNCHRONOUSLY download the image for each source of the event display.
        [self performSelectorInBackground:@selector(synchronouslyDownloadImageForSource:) withObject:source];
    }
}

- (void)synchronouslyDownloadImageForSource:(NSDictionary *)source
{
    NSURL *url = [source objectForKey:SOURCE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    UIImage *image = [UIImage imageWithData:imageData];
    
    // Get the date the image was uploaded
    NSDictionary *allHeaderFields = response.allHeaderFields;
    NSString *lastModifiedString = [allHeaderFields objectForKey:@"Last-Modified"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    NSDate *lastUpdated = [dateFormatter dateFromString:lastModifiedString];
    
    
    NSArray *boundaryRects = [source objectForKey:SOURCE_BOUNDARY_RECTS];
    if (boundaryRects) {
        for (NSDictionary *boundaryInfo in boundaryRects) {
            NSValue *rectValue = [boundaryInfo objectForKey:@"Rect"];
            CGRect boundaryRect = [rectValue CGRectValue];
            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, boundaryRect);
            UIImage *partialImage = [UIImage imageWithCGImage:imageRef];

            NSDictionary *imageInfo = [NSMutableDictionary dictionary];
            [imageInfo setValue:partialImage forKey:RESULT_IMAGE];
            [imageInfo setValue:[boundaryInfo objectForKey:SOURCE_DESCRIPTION] forKey:SOURCE_DESCRIPTION];
            [imageInfo setValue:lastUpdated forKey:RESULT_LAST_UPDATED];
            [self.results addObject:imageInfo];
            [self addDisplay:imageInfo toPage:self.results.count];
        }
    } else {
        NSDictionary *imageInfo = [NSMutableDictionary dictionary];
        [imageInfo setValue:image forKey:RESULT_IMAGE];
        [imageInfo setValue:[source objectForKey:SOURCE_DESCRIPTION] forKey:SOURCE_DESCRIPTION];
        [imageInfo setValue:lastUpdated forKey:RESULT_LAST_UPDATED];
        [self.results addObject:imageInfo];
        [self addDisplay:imageInfo toPage:self.results.count];
    }
}

- (void)addDisplay:(NSDictionary *)eventDisplayInfo toPage:(int)page
{
    UIImage *image = [eventDisplayInfo objectForKey:RESULT_IMAGE];
    CGRect imageViewFrame = CGRectMake(self.scrollView.frame.size.width*(page-1), 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [self.scrollView addSubview:imageView];
}

- (void)addSourceWithDescription:(NSString *)description URL:(NSURL *)url boundaryRects:(NSArray *)boundaryRects
{
    NSMutableDictionary *source = [NSMutableDictionary dictionary];
    [source setValue:description forKey:SOURCE_DESCRIPTION];
    [source setValue:url forKey:SOURCE_URL];
    if (boundaryRects) {
        [source setValue:boundaryRects forKey:SOURCE_BOUNDARY_RECTS];
        // If the image downloaded from this source is going to be divided into multiple images, we will want a separate page for each of these.
        numPages += boundaryRects.count;
    } else {
        numPages += 1;
    }
    [self.sources addObject:source];
}

#pragma mark - Page control

- (void)scrollViewDidScroll:(UIScrollView *)sender {

    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

/*
#pragma mark NSURLConnectionDelegate methods


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [asyncData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [[UIImage alloc] initWithData:asyncData];

    CGFloat largeImageDimension = 764.0;
    CGFloat smallImageDimension = 379.0;
    
    CGRect frontRect = CGRectMake(2.0, 2.0, largeImageDimension, largeImageDimension);
    CGImageRef frontImageRef = CGImageCreateWithImageInRect(image.CGImage, frontRect);
    self.frontImage = [UIImage imageWithCGImage:frontImageRef];
    
    CGRect sideRect = CGRectMake(2.0+4.0+largeImageDimension, 2.0, smallImageDimension, smallImageDimension);
    CGImageRef sideImageRef = CGImageCreateWithImageInRect(image.CGImage, sideRect);
    self.sideImage = [UIImage imageWithCGImage:sideImageRef];
    
    CGRect infoRect = CGRectMake(2.0+4.0+largeImageDimension, 2.0+5.0+smallImageDimension, smallImageDimension, smallImageDimension);
    CGImageRef infoImageRef = CGImageCreateWithImageInRect(image.CGImage, infoRect);
    self.infoImage = [UIImage imageWithCGImage:infoImageRef];
  
    CGImageRelease(frontImageRef);
    CGImageRelease(sideImageRef);
    CGImageRelease(infoImageRef);
    
    [self segmentedControlTapped:self.segmentedControl];
    [self hideLoadingView];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSDictionary *allHeaderFields = ((NSHTTPURLResponse *)response).allHeaderFields;
    NSString *lastModifiedString = [allHeaderFields objectForKey:@"Last-Modified"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    NSDate *date = [dateFormatter dateFromString:lastModifiedString];
    
    int secondsSinceUpdated = abs([date timeIntervalSinceNow]);
    float hoursSinceUpdated = (float)secondsSinceUpdated/(60*60);
    self.barButtonItem.title = [NSString stringWithFormat:@"Last updated %.1f hours ago", hoursSinceUpdated];
}*/

#pragma mark - UI methods

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showLoadingView
{
    if (!loadingView) {
        loadingView = [[UIView alloc] init];
        loadingView.frame = self.view.bounds;    
        UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect frame = loadingView.frame;
        ac.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [loadingView addSubview:ac];
        [ac startAnimating];
        loadingView.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:loadingView];
}

- (void)hideLoadingView
{    
    [loadingView removeFromSuperview];
}

/*- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.imageView.image = self.frontImage;
            break;
        case 1:
            self.imageView.image = self.sideImage;
            break;
        case 2:
            self.imageView.image = self.infoImage;
            break;
        default:
            break;
    }
}*/

@end
