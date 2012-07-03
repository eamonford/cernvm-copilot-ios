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
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ExperimentTableViewController *experimentInfoViewController = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"ShowCMSInfo"]) {
        experimentInfoViewController.feed.screenName = @"CMSexperiment";
    } else if ([[segue identifier] isEqualToString:@"ShowATLASInfo"]) {
        experimentInfoViewController.feed.screenName = @"ATLASexperiment";
    } else if ([[segue identifier] isEqualToString:@"ShowLHCBInfo"]) {
        experimentInfoViewController.feed.screenName = @"LHCbexperiment";
    } else if ([[segue identifier] isEqualToString:@"ShowALICEInfo"]) {
        experimentInfoViewController.feed.screenName = @"ALICEexperiment";
    } 

}

- (IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
