//
//  PageContainingViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/26/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "PageContainingViewController.h"

@interface PageContainingViewController ()

@end

@implementation PageContainingViewController
@synthesize scrollView, dataSource, pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (StaticInfoViewController *)viewControllerForPage:(int)page
{
    StaticInfoViewController *detailViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"StaticInfoDetailView"];
    detailViewController.staticInfo = [self.dataSource objectAtIndex:page];
    
    return detailViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageControl.numberOfPages = self.dataSource.count;
    NSLog(@"page control has %d pages", self.pageControl.numberOfPages);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*self.dataSource.count, 1.0);
    
    for (int i=0; i<self.dataSource.count; i++) {
        StaticInfoViewController *detailViewController = [self viewControllerForPage:i];
        detailViewController.view.frame = CGRectMake(self.scrollView.frame.size.width*i, 0.0, detailViewController.view.frame.size.width, detailViewController.view.frame.size.height);
        
        [self addChildViewController:detailViewController];
        [self.scrollView addSubview:detailViewController.view];
        [detailViewController didMoveToParentViewController:self];
    }
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageControl.currentPage = page;
}

@end
