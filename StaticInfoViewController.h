//
//  StaticInfoViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/17/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticInfoViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
}
@property(nonatomic, retain) UIScrollView *scrollView;

@end
