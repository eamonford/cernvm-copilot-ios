//
//  ArticleTableViewCell.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/19/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTableViewCell : UITableViewCell
{
    IBOutlet UILabel *feedLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *titleLabel;
}

@property (nonatomic, readonly) UILabel *feedLabel;
@property (nonatomic, readonly) UILabel *dateLabel;
@property (nonatomic, readonly) UILabel *titleLabel;

@end
