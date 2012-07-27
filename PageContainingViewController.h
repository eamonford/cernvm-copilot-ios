//
//  PageContainingViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/26/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticInfoViewController.h"

@interface PageContainingViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    
    NSArray *dataSource;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, retain) UIPageControl *pageControl;

- (StaticInfoViewController *)viewControllerForPage:(int)page;

@end
