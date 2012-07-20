//
//  ExperimentsViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ExperimentsViewController.h"
#import "ExperimentTableViewController.h"

#define CMS_BUTTON 0
#define LHCB_BUTTON 1
#define ATLAS_BUTTON 2
#define ALICE_BUTTON 3

@interface ExperimentsViewController ()

@end

@implementation ExperimentsViewController
@synthesize shadowImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Fade in the shadow graphic
    [UIView animateWithDuration:1.0 animations:^{shadowImageView.alpha = 1.0;}];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ExperimentTableViewController *viewController = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"ShowCMSInfo"]) {
        viewController.feed.screenName = @"CMSexperiment";
        [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://cms.web.cern.ch/news/category/265/rss.xml"]];
    } else if ([[segue identifier] isEqualToString:@"ShowATLASInfo"]) {
        viewController.feed.screenName = @"ATLASexperiment";
        [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://pdg2.lbl.gov/atlasblog/?feed=rss2"]];
    } else if ([[segue identifier] isEqualToString:@"ShowLHCBInfo"]) {
        viewController.feed.screenName = @"LHCbexperiment";
        [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"https://twitter.com/statuses/user_timeline/92522167.rss"]];
    } else if ([[segue identifier] isEqualToString:@"ShowALICEInfo"]) {
        [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://alicematters.web.cern.ch/rss.xml"]];
        viewController.feed.screenName = @"ALICEexperiment";
    } 

}

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
