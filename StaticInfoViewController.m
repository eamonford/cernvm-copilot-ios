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
@synthesize scrollView, imageView, descriptionLabel, titleLabel, staticInfo;

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
    // Set the title label and resize it accordingly
    NSString *title = [self.staticInfo objectForKey:@"Title"];
    self.titleLabel.text = title;
    CGSize titleSize = [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleSize.height);

    // Set the image, and position it right below the title label
    NSString *imageName = [self.staticInfo objectForKey:@"Image"];
    UIImage *image = [UIImage imageNamed:imageName];
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+8.0f, self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    // Set the description label and resize it accordingly, and also position it right below the image view
    NSString *description = [self.staticInfo objectForKey:@"Description"];
    CGSize descriptionSize = [description sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, CGFLOAT_MAX)];
    descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, self.imageView.frame.origin.y+self.imageView.frame.size.height+8.0f, descriptionLabel.frame.size.width, descriptionSize.height);
    self.descriptionLabel.text = description;
    
    // Set the content size of the scrollview
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height);
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
