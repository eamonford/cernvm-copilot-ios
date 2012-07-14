//
//  ShadowedCell.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/12/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ShadowedCell.h"

@implementation ShadowedCell
//@synthesize borderColor, fillColor, shadowColor, separatorColor, position, shadowSize, cornerRadius;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        shadowedBackgroundView = [[ShadowedCellBackgroundView alloc] initWithFrame:self.frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        shadowedBackgroundView = [[ShadowedCellBackgroundView alloc] initWithFrame:self.frame];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect 
{
    self.backgroundView = shadowedBackgroundView;
    [self.backgroundView setNeedsDisplay];
 }

#pragma mark - Properties

- (UIColor *)borderColor
{
    return shadowedBackgroundView.borderColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    shadowedBackgroundView.borderColor = borderColor;
    [shadowedBackgroundView setNeedsDisplay];
}

- (UIColor *)separatorColor
{
    return shadowedBackgroundView.separatorColor;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    shadowedBackgroundView.separatorColor = separatorColor;
    [shadowedBackgroundView setNeedsDisplay];
}

- (UIColor *)fillColor
{
    return shadowedBackgroundView.fillColor;
}

- (void)setFillColor:(UIColor *)fillColor
{
    shadowedBackgroundView.fillColor = fillColor;
    [shadowedBackgroundView setNeedsDisplay];
}

- (UIColor *)shadowColor
{
    return shadowedBackgroundView.shadowColor;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    shadowedBackgroundView.shadowColor = shadowColor;
    [shadowedBackgroundView setNeedsDisplay];
}

- (CGFloat)shadowSize
{
    return shadowedBackgroundView.shadowSize;
}

- (void)setShadowSize:(CGFloat)shadowSize
{
    shadowedBackgroundView.shadowSize = shadowSize;
    [shadowedBackgroundView setNeedsDisplay];
}

- (CGFloat)cornerRadius
{
    return shadowedBackgroundView.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    shadowedBackgroundView.cornerRadius = cornerRadius;
    [shadowedBackgroundView setNeedsDisplay];
}

- (ShadowedCellPosition)position
{
    return shadowedBackgroundView.position;
}

- (void)setPosition:(ShadowedCellPosition)position
{
    shadowedBackgroundView.position = position;
    [shadowedBackgroundView setNeedsDisplay];
}

@end
