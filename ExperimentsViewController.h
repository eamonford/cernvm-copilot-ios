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
    LHCb
} ExperimentType;

@interface ExperimentsViewController : UIViewController
{
    IBOutlet UIImageView *mapImageView;
    IBOutlet UIImageView *shadowImageView;
    UIPopoverController *popoverController;
    
    IBOutlet UIButton *atlasButton, *cmsButton, *aliceButton, *lhcbButton, *lhcButton;
}
@property (nonatomic, retain) UIImageView *mapImageView;
@property (nonatomic, retain) UIImageView *shadowImageView;
@property (nonatomic, retain) UIButton *atlasButton, *cmsButton, *aliceButton, *lhcbButton, *lhcButton;
@property (nonatomic, strong) UIPopoverController *popoverController;

- (void)setupVisualsForOrientation:(UIDeviceOrientation)orientation;
@end
