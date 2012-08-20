//
//  StaticInfoViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/17/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface StaticInfoItemViewController : UIViewController<MWPhotoBrowserDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *titleLabel;
    NSDictionary *staticInfo;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSDictionary *staticInfo;

- (void)setAndPositionInformation;
@end
