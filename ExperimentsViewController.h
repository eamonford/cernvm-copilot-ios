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
}
@property (nonatomic, retain) UIImageView *shadowImageView;

- (IBAction)close:(id)sender;

@end
