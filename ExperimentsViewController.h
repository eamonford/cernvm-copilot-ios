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
    IBOutlet UIImageView *shadowImageView;
    UIPopoverController *popoverController;
    
}
@property (nonatomic, retain) UIImageView *shadowImageView;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end
