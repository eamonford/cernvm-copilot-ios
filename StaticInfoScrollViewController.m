//
//  PageContainingViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/26/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "StaticInfoScrollViewController.h"
#import "StaticInfoSelectorViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface StaticInfoScrollViewController ()

@end

@implementation StaticInfoScrollViewController
@synthesize scrollView, dataSource, popoverController, pageControl;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
 
    }
    return self;
}

- (StaticInfoItemViewController *)viewControllerForPage:(int)page
{
    UIStoryboard *mainStoryboard;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];

    StaticInfoItemViewController *detailViewController = [mainStoryboard instantiateViewControllerWithIdentifier:kStaticInfoItemViewController];
    detailViewController.staticInfo = [self.dataSource objectAtIndex:page];
    
    return detailViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = YES;

    [self.view layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self refresh];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageControl.currentPage = page;
}

- (void)refresh
{
    for (UIViewController *childViewController in self.childViewControllers) {
        [childViewController.view removeFromSuperview];
        [childViewController removeFromParentViewController];
    }
    
    self.pageControl.numberOfPages = self.dataSource.count;

    CGFloat detailViewWidth = 0.0;
    CGFloat detailViewHeight = 480.0;
    CGFloat detailViewX = 0.0;
    CGFloat detailViewY = self.scrollView.frame.size.height/2-detailViewHeight/2;
    CGFloat detailViewMargin = 0.0;

    for (int i=0; i<self.dataSource.count; i++) {
        StaticInfoItemViewController *detailViewController = [self viewControllerForPage:i];
        detailViewWidth = detailViewController.view.frame.size.width;
        detailViewHeight = detailViewController.view.frame.size.height;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            detailViewMargin = 5.0;
        } else {
            detailViewMargin = 50.0;
        }
        detailViewX = (detailViewWidth+(2*detailViewMargin))*i;
            
        detailViewController.view.frame = CGRectMake(detailViewX+detailViewMargin, detailViewY, detailViewWidth, detailViewHeight);
        [self addChildViewController:detailViewController];
        [self.scrollView addSubview:detailViewController.view];
        [detailViewController didMoveToParentViewController:self];
        [detailViewController.view setNeedsDisplay];
    }
    self.scrollView.contentSize = CGSizeMake(detailViewX+detailViewWidth+2*detailViewMargin, 1.0);
}

- (IBAction)categoryButtonTapped:(id)sender
{
    if (!self.popoverController) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        StaticInfoSelectorViewController *selectorViewController = [[StaticInfoSelectorViewController alloc] init];
        selectorViewController.tableDataSource = appDelegate.staticInfoDataSource;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectorViewController];
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    }
    [self.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
