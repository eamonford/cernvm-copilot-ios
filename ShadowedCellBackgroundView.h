//
//  RoundedCellBackgroundView.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/10/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    ShadowedCellPositionTop, 
    ShadowedCellPositionMiddle, 
    ShadowedCellPositionBottom,
    ShadowedCellPositionSingle
} ShadowedCellPosition;

@interface ShadowedCellBackgroundView : UIView {
    //UIColor *borderColor;
    UIColor *separatorColor;
    UIColor *fillColor;
    UIColor *shadowColor;
    
    ShadowedCellPosition position;
    CGFloat shadowSize;
    CGFloat cornerRadius;
}

@property(nonatomic, retain) UIColor /**borderColor,*/ *separatorColor, *fillColor, *shadowColor;
@property ShadowedCellPosition position;
@property CGFloat shadowSize, cornerRadius;

@end
