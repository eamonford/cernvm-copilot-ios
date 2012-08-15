//
//  PageContainingViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/26/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticInfoItemViewController.h"

@interface StaticInfoScrollViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    UIPopoverController *popoverController;
    
    NSArray *dataSource;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) NSArray *dataSource;

- (void)refresh;
- (StaticInfoItemViewController *)viewControllerForPage:(int)page;
- (IBAction)categoryButtonTapped:(id)sender;
@end
