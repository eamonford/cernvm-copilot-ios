//
//  ArticleTableViewCell.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/19/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowedCell.h"

@interface ArticleTableViewCell : ShadowedCell
{
    IBOutlet UILabel *detailLabel1;
    IBOutlet UILabel *detailLabel2;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *thumbnailImageView;
}

@property (nonatomic, readonly) UILabel *detailLabel1;
@property (nonatomic, readonly) UILabel *detailLabel2;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *thumbnailImageView;

@end
