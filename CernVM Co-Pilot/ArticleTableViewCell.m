//
//  ArticleTableViewCell.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/19/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArticleTableViewCell
@synthesize titleLabel, feedLabel, dateLabel, thumbnailImageView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)awakeFromNib
{
    self.thumbnailImageView.layer.cornerRadius = 5.0;
    self.thumbnailImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
