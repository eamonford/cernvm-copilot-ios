//
//  StaticInfoViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/17/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "StaticInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface StaticInfoViewController ()

@end

@implementation StaticInfoViewController
@synthesize scrollView, imageView, descriptionLabel, titleLabel, staticInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleFingerTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.view.layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95].CGColor;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.borderWidth = 1.0;
    CALayer *masklayer = [CALayer layer];
    masklayer.backgroundColor = [UIColor whiteColor].CGColor;
    masklayer.cornerRadius = 10.0;
    masklayer.frame = CGRectMake(5.0, 5.0, self.view.frame.size.width-10.0, self.view.frame.size.height-10.0);
    self.view.layer.mask = masklayer;
    
    // Set the image, and position it right below the title label
    NSString *imageName = [self.staticInfo objectForKey:@"Image"];
    UIImage *image = [UIImage imageNamed:imageName];
    self.imageView.image = image;

    // Set the title label and resize it accordingly
    NSString *title = [self.staticInfo objectForKey:@"Title"];
    self.navigationItem.title = title;
    
    self.titleLabel.text = title;
    CGSize titleSize = [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, self.imageView.frame.origin.y+self.imageView.frame.size.height+8.0f, titleLabel.frame.size.width, titleSize.height);
    
    // Set the description label and resize it accordingly, and also position it right below the image view
    NSString *description = [self.staticInfo objectForKey:@"Description"];
    CGSize descriptionSize = [description sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, CGFLOAT_MAX)];
    descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+8.0f, descriptionLabel.frame.size.width, descriptionSize.height);
    self.descriptionLabel.text = description;
    
    // Set the content size of the scrollview
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height);
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer 
{
    CGPoint touchLocation = [recognizer locationInView:self.view];
    // If the photo was tapped, display it fullscreen
    if (CGRectContainsPoint(self.imageView.frame, touchLocation)) {
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browser];
        navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:navigationController animated:YES];
        
        // Otherwise if the tap was anywhere else on the view, dismiss the view
    } else {
        [self dismissModalViewControllerAnimated:YES];
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

#pragma mark - MWPhotoBrowserDelegate methods

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    UIImage *photo = [UIImage imageNamed:[self.staticInfo objectForKey:@"Image"]];
    return [MWPhoto photoWithImage:photo];
}



@end
