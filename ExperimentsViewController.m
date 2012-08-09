//
//  ExperimentsViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ExperimentsViewController.h"
//#import "ExperimentTableViewController.h"
#import "ExperimentFunctionSelectorViewController.h"
#import "Constants.h"

#define CMS_BUTTON 0
#define LHCB_BUTTON 1
#define ATLAS_BUTTON 2
#define ALICE_BUTTON 3

@interface ExperimentsViewController ()

@end

@implementation ExperimentsViewController
@synthesize shadowImageView, popoverController;

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

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ExperimentFunctionSelectorViewController *viewController = [segue destinationViewController];

    // Since viewController.experiment is an ExperimentType enum, it will be an integer between 0 and 3. So the button tags in the storyboard are just set to match the enum types.
    viewController.experiment = ((UIButton *)sender).tag;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        ExperimentFunctionSelectorViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil] instantiateViewControllerWithIdentifier:kExperimentFunctionSelectorViewIdentifier];        
        viewController.experiment = sender.tag;
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        self.popoverController.popoverContentSize = CGSizeMake(320, 200);
        
        //show the popover next to the annotation view (pin)
        [self.popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
   }
 }

@end
