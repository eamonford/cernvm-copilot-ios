//
//  BulletinGridViewCell.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "BulletinGridViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BulletinGridViewCell
@synthesize titleLabel, descriptionLabel;

- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:aReuseIdentifier]) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 5.0;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 0.5;
        CGPathRef shadowPathRef = CGPathCreateWithRect(self.layer.frame, NULL);
        self.layer.shadowPath = shadowPathRef;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];

        UIView *borderMaskView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 8.0+5.0, frame.size.width-40.0, 40.0)];
        borderMaskView.clipsToBounds = YES;

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1.0, 0.0, borderMaskView.frame.size.width+2.0, borderMaskView.frame.size.height)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.shadowColor = [UIColor whiteColor];
        self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.titleLabel.layer.borderWidth = 1.0;
        [borderMaskView addSubview:self.titleLabel];
        [self.contentView addSubview:borderMaskView];

        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0+5.0, borderMaskView.frame.origin.y+borderMaskView.frame.size.height+5.0, frame.size.width-16.0-10.0, 25.0)];
        self.descriptionLabel.font = [UIFont systemFontOfSize:13.0];
        self.descriptionLabel.textColor = [UIColor grayColor];
        self.descriptionLabel.textAlignment = UITextAlignmentCenter;
        self.descriptionLabel.shadowColor = [UIColor whiteColor];
        self.descriptionLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.descriptionLabel.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.descriptionLabel];
      }
    return self;
}


@end
