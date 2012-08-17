//
//  APBaseSplitViewController.m
//  SplitSample
//
//  Created by slatvick on 2/15/11.
//  Copyright 2011 Alterplay. All rights reserved.
//

#import "APSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

#define constDividerWidth 0.0f
#define constMasterWidth 320.0f
#define constDetailStartPoint (constMasterWidth+constDividerWidth)

static float koefficient = 0.0f; // Need to fix a bug with 20px near the statusbar

@interface APSplitViewController()
//- (void) layoutSubviews;
@end

@implementation APSplitViewController

#pragma mark -
#pragma mark Helpers

// returns size of split view
- (CGSize) sizeRotated {
    
	UIScreen *screen = [UIScreen mainScreen];
	CGRect bounds = screen.bounds; // always implicitly in Portrait orientation.
	CGRect appFrame = screen.applicationFrame;
	CGSize size = bounds.size;
	
	float statusBarHeight = MAX((bounds.size.width - appFrame.size.width), (bounds.size.height - appFrame.size.height));
	
	// let's figure out if width/height must be swapped
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) 
	{
		// we're going to landscape, which means we gotta swap them
		size.width = bounds.size.height;
		size.height = bounds.size.width;
	}
	
	size.height = size.height -statusBarHeight -self.tabBarController.tabBar.frame.size.height;
	return size;
}

- (void) layoutSubviews {
    
//	NSLog(@"layoutSubviews");
	
	CGSize size = [self sizeRotated];
	
	_masterContainerView.frame = CGRectMake(0, 0 - koefficient, constMasterWidth, size.height + koefficient);
	self.detailViewController.view.frame = CGRectMake(constDetailStartPoint, 0 - koefficient, size.width - constDetailStartPoint, size.height + koefficient);
}


#pragma mark - View lifecycle

/*- (void) pushToMasterController:(UIViewController *)controller {
    
	CGSize size = [self sizeRotated];
	
	controller.view.frame = CGRectMake(0, 0, constMasterWidth, size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth 
		| UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin 
		| UIViewAutoresizingFlexibleRightMargin  | UIViewAutoresizingFlexibleLeftMargin;
//	controller.view.backgroundColor = [UIColor redColor];
		
    [_master pushViewController:controller animated:NO];
	_master.view.frame = CGRectMake(0, 0, constMasterWidth, size.height);
    _master.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _master.view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_master.view];
	[self.view bringSubviewToFront:_divider];
}
*/
- (void)setMasterViewController:(UIViewController *)master
{
    if (self.masterViewController) {
        [self.masterViewController.view removeFromSuperview];
        [self.masterViewController removeFromParentViewController];
    }
    _masterViewController = master;
    
    CGSize size = [self sizeRotated];
	
	self.masterViewController.view.frame = CGRectMake(0, 0, constMasterWidth, size.height);
    _masterContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _masterContainerView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    _masterContainerView.layer.shadowOpacity = 1.0;
    _masterContainerView.layer.shadowRadius = 5.0;
    CGPathRef shadowPath = CGPathCreateWithRect(_masterContainerView.frame, NULL);
    _masterContainerView.layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    _masterContainerView.clipsToBounds = NO;
    self.masterViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self addChildViewController:self.masterViewController];
    [_masterContainerView addSubview:self.masterViewController.view];
    [self.masterViewController didMoveToParentViewController:self];
}

- (void)setDetailViewController:(UIViewController *)detail
{
    if (self.detailViewController) {
        [self.detailViewController.view removeFromSuperview];
        [self.detailViewController removeFromParentViewController];
    }
    
    _detailViewController = detail;
 	CGSize size = [self sizeRotated];
	
    self.detailViewController.view.frame = CGRectMake(0, 0, size.width-constDetailStartPoint, size.height);
    self.detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin  | UIViewAutoresizingFlexibleLeftMargin;	
	
    //[self.detail pushViewController:controller animated:NO];
    self.detailViewController.view.frame = CGRectMake(constDetailStartPoint, 0, size.width-constDetailStartPoint, size.height);
    self.detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //   _detail.view.backgroundColor = [UIColor darkGrayColor];
    [self addChildViewController:self.detailViewController];
    [self.view addSubview:self.detailViewController.view];
	[self.view bringSubviewToFront:_masterContainerView];
}

/*
- (void) pushToDetailController:(UIViewController *)controller {
    
	CGSize size = [self sizeRotated];
	
    controller.view.frame = CGRectMake(0, 0, size.width-constDetailStartPoint, size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
		| UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin 
		| UIViewAutoresizingFlexibleRightMargin  | UIViewAutoresizingFlexibleLeftMargin;
//	controller.view.backgroundColor = [UIColor lightGrayColor];
	

	
    [_detail pushViewController:controller animated:NO];
    _detail.view.frame = CGRectMake(constDetailStartPoint, 0, size.width-constDetailStartPoint, size.height);
    _detail.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
 //   _detail.view.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_detail.view];
	[self.view bringSubviewToFront:_divider];
}
*/
- (void) loadView {
    
	CGSize size = [self sizeRotated];
	
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
	self.view.backgroundColor = [UIColor grayColor];
	
	// slatvick: old divider
/*	_divider = [[UIView alloc] init];
	_divider.frame = CGRectMake(constMasterWidth, 0, constDividerWidth, size.height);
	_divider.backgroundColor = [UIColor redColor];
	_divider.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_divider];
    
    UIImage *image = [UIImage imageNamed:@"split-divider.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(-4, 0, image.size.width, image.size.height);
    [_divider addSubview:imageView];
*/
}

- (void) viewDidLoad {
    [super viewDidLoad];

    CGSize size = [self sizeRotated];
    _masterContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - koefficient, constMasterWidth, size.height + koefficient)];
    [self.view addSubview:_masterContainerView];
    //_master = [[APNavigationControllerForSplitController alloc] initWithSplit:self];
    //_detail = [[APNavigationControllerForSplitController alloc] initWithSplit:self];
//    _master = [[UINavigationController alloc] init];
//    _detail = [[UINavigationController alloc] init];
    
    // don't remember what for?
	//[_master viewDidLoad];
	//[_detail viewDidLoad];
    
	
//	NSLog(@"   self.view.frame: %@", NSStringFromCGRect(self.view.frame));
//	NSLog(@"_master.view.frame: %@", NSStringFromCGRect(_master.view.frame));
//	NSLog(@"_detail.view.frame: %@", NSStringFromCGRect(_detail.view.frame));
}

- (void) viewDidUnload {

    self.masterViewController = nil;
    self.detailViewController = nil;
}

#pragma mark -
#pragma mark STANDARD METHODS

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self.masterViewController viewWillAppear:animated];
	[self.detailViewController viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.masterViewController viewDidAppear:animated];
	[self.detailViewController viewDidAppear:animated];
    
    // it's Needed to fix a bug with 20px near the statusbar
    if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        koefficient = 20.0f;
    else
        koefficient = 0.0f;
    
//	[self layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.masterViewController viewWillDisappear:animated];
	[self.detailViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.masterViewController viewDidDisappear:animated];
	[self.detailViewController viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.detailViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//	[self layoutSubviews];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.masterViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.detailViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    [self layoutSubviews];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.detailViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.detailViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	[self.masterViewController didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
	[self.detailViewController didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
	[self.detailViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

@end