//
//  APBaseSplitViewController.h
//  SplitSample
//
//  Created by slatvick on 2/15/11.
//  Copyright 2011 Alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APSplitViewDelegate<NSObject>
@optional
- (void)navigationController:(UINavigationController*)navigationController poppedDetailController:(UIViewController*)popedController;
@end

@interface APSplitViewController : UIViewController <APSplitViewDelegate>
{
    UIView *_masterContainerView;
}
@property (nonatomic, strong) UIViewController *masterViewController;
@property (nonatomic, strong) UIViewController *detailViewController;

@end