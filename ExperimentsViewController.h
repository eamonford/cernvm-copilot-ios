//
//  ExperimentsViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ATLAS,
    CMS,
    ALICE,
    LHCb,
    LHC
} ExperimentType;

@interface ExperimentsViewController : UIViewController
{
    IBOutlet UIImageView *mapImageView;
    IBOutlet UIImageView *shadowImageView;
    UIPopoverController *popoverController;
    
    IBOutlet UIButton *atlasButton, *cmsButton, *aliceButton, *lhcbButton, *lhcButton;
}
@property (nonatomic, strong) UIImageView *mapImageView;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIButton *atlasButton, *cmsButton, *aliceButton, *lhcbButton, *lhcButton;
@property (nonatomic, strong) UIPopoverController *popoverController;

- (void)setupVisualsForOrientation:(UIDeviceOrientation)orientation withDuration:(NSTimeInterval)duration;
@end
