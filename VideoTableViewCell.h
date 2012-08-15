//
//  VideoTableViewCell.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/5/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIImageView *thumbnailImageView;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;

@end
