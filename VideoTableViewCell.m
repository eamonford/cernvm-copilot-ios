//
//  VideoTableViewCell.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/5/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell
@synthesize titleLabel, dateLabel, thumbnailImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
