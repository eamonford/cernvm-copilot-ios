//
//  NewsGridViewCell.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/7/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewCell.h"

@interface NewsGridViewCell : AQGridViewCell
{
    UILabel *titleLabel;
    UILabel *dateLabel;
    UIImageView *thumbnailImageView;
}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIImageView *thumbnailImageView;

@end
