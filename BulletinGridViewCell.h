//
//  BulletinGridViewCell.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewCell.h"

@interface BulletinGridViewCell : AQGridViewCell
{
    UILabel *titleLabel;
    UILabel *descriptionLabel;
}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;

@end
