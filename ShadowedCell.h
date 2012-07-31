//
//  ShadowedCell.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/12/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShadowedCellBackgroundView.h"

@interface ShadowedCell : UITableViewCell
{
    @private
    ShadowedCellBackgroundView *shadowedBackgroundView;
}

@property(nonatomic, retain) UIColor *separatorColor, *fillColor, *shadowColor;
@property CGFloat shadowSize;
@property CGFloat cornerRadius;
@property ShadowedCellPosition position;

@end
