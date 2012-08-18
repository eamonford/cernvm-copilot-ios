//
//  RSSGridViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSGridViewController.h"
#import "MBProgressHUD.h"

@interface RSSGridViewController ()

@end

@implementation RSSGridViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.aggregator = [[RSSAggregator alloc] init];
        self.aggregator.delegate = self;
        self.gridView.separatorStyle = AQGridViewCellSeparatorStyleNone;
        self.gridView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    if (self.aggregator.feeds.count) {
        [_noConnectionHUD hide:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.aggregator refreshAllFeeds];
    }
}

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasTapped:(MBProgressHUD *)hud
{
    [self refresh];
}

#pragma mark - RSSAggregatorDelegate methods

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)aggregator
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)aggregator:(RSSAggregator *)aggregator didFailWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	_noConnectionHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    _noConnectionHUD.delegate = self;
    _noConnectionHUD.mode = MBProgressHUDModeText;
    _noConnectionHUD.labelText = @"No internet connection";
    _noConnectionHUD.removeFromSuperViewOnHide = YES;

}

@end
