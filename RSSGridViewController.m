//
//  RSSGridViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSGridViewController.h"

@interface RSSGridViewController ()

@end

@implementation RSSGridViewController
@synthesize aggregator, displaySpinner;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.displaySpinner = NO;
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
    NSLog(@"refreshing %d feeds", self.aggregator.feeds.count);
    if (self.aggregator.feeds.count) {
        self.displaySpinner = YES;
        [self.gridView reloadData];
        [self.aggregator refreshAllFeeds];
    }
}

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)aggregator
{
    self.displaySpinner = NO;
}

@end
