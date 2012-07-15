//
//  EventDisplayViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/15/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "EventDisplayViewController.h"

@interface EventDisplayViewController ()

@end

@implementation EventDisplayViewController
@synthesize imageView, segmentedControl, frontImage, sideImage, infoImage;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor blackColor];
    [self showLoadingView];
    asyncData = [[NSMutableData alloc] init];
    [self refresh];
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

- (void)refresh
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://atlas-live.cern.ch/live.png"]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

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

- (IBAction)segmentedControlTapped:(UISegmentedControl *)sender
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
}

@end
