//
//  EventDisplayViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/15/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDisplayViewController : UIViewController<NSURLConnectionDelegate>
{
    IBOutlet UIImageView *imageView;
    IBOutlet UISegmentedControl *segmentedControl;
    UIView *loadingView;
    NSMutableData *asyncData;
    
    UIImage *frontImage;
    UIImage *sideImage;
    UIImage *infoImage;
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIImage *frontImage;
@property (nonatomic, retain) UIImage *sideImage;
@property (nonatomic, retain) UIImage *infoImage;

- (IBAction)close:(id)sender;
- (IBAction)segmentedControlTapped:(id)sender;
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)refresh;

@end
