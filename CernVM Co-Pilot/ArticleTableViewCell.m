//
//  ArticleTableViewCell.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/19/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ArticleTableViewCell.h"

@implementation ArticleTableViewCell
@synthesize titleLabel, feedLabel, dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"article table view cell");
        // Initialization code
        self.textLabel.frame = CGRectMake(0.0, 30.0, 280.0, 70.0);
        self.textLabel.backgroundColor = [UIColor blueColor];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
