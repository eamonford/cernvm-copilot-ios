//
//  RSSTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/31/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSTableViewController.h"

@interface RSSTableViewController ()

@end

@implementation RSSTableViewController
@synthesize aggregator;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.aggregator = [[RSSAggregator alloc] init];
        self.aggregator.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

 }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
}

- (void)refresh
{
    if (self.aggregator.feeds.count) {
        [self showLoadingView];
        [self.aggregator refreshAllFeeds];
    }
}

- (void)allFeedsDidLoadForAggregator:(RSSAggregator *)sender
{
    [self hideLoadingView];
}


#pragma mark - UI methods

- (void)showLoadingView
{
    if (!loadingView) {
        loadingView = [[UIView alloc] init];
        loadingView.frame = self.tableView.bounds;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
