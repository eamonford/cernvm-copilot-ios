//
//  StaticInfoViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/17/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "StaticInfoViewController.h"

@interface StaticInfoViewController ()

@end

@implementation StaticInfoViewController
@synthesize scrollView;

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
    float totalHeight = 0.0f;
    for (UIView *subview in self.scrollView.subviews) {
        float maxVerticalExtension = subview.frame.origin.y + subview.frame.size.height;
        if (totalHeight < maxVerticalExtension)
            totalHeight = maxVerticalExtension;
    }
    self.scrollView.contentSize = CGSizeMake(320.0, totalHeight);
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

@end
