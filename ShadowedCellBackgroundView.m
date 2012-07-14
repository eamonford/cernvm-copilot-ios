//
//  RoundedCellBackgroundView.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/10/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ShadowedCellBackgroundView.h"

@implementation ShadowedCellBackgroundView
@synthesize borderColor, separatorColor, fillColor, shadowColor, position, shadowSize, cornerRadius;

- (BOOL) isOpaque {
    return NO;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Default configuration
        self.borderColor = [UIColor blackColor];
        self.separatorColor = [UIColor lightGrayColor];
        self.fillColor = [UIColor whiteColor];
        self.shadowColor = [UIColor blackColor];
        self.shadowSize = 10.0f;
        self.cornerRadius = 5.0f;
        self.position = ShadowedCellPositionSingle;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, fillColor.CGColor);
    
    switch (self.position) {
        case ShadowedCellPositionTop:
        {
            CGMutablePathRef pathRef = CGPathCreateMutable();
            
            // Bottom right corner
            CGPathMoveToPoint(pathRef, NULL, rect.size.width-self.shadowSize, rect.size.height+self.shadowSize);
            // Top right corner
            CGPathAddLineToPoint(pathRef, NULL, rect.size.width-self.shadowSize, self.shadowSize+self.cornerRadius);
            CGPathAddArcToPoint(pathRef, NULL, rect.size.width-self.shadowSize, self.shadowSize, rect.size.width-(self.shadowSize+self.cornerRadius), self.shadowSize, self.cornerRadius);
            // Top left corner
            CGPathAddLineToPoint(pathRef, NULL, self.shadowSize+self.cornerRadius, self.shadowSize);
            CGPathAddArcToPoint(pathRef, NULL, self.shadowSize, self.shadowSize, self.shadowSize, self.shadowSize+self.cornerRadius, self.cornerRadius);
            // Bottom left corner
            CGPathAddLineToPoint(pathRef, NULL, self.shadowSize, rect.size.height+self.shadowSize);
            
            // Fill the path we just drew (with a shadow)
            CGContextAddPath(c, pathRef);
            CGContextSetShadowWithColor(c, CGSizeMake(0,0), self.shadowSize, self.shadowColor.CGColor);
            CGContextFillPath(c);
            
            // Draw the outer border
            CGContextSetShadowWithColor(c, CGSizeMake(0,0), 0, NULL);
            CGContextAddPath(c, pathRef);
            CGContextSetStrokeColorWithColor(c, self.borderColor.CGColor);
            CGContextStrokePath(c);
            
            // Draw the separator line
            CGContextSetStrokeColorWithColor(c, self.separatorColor.CGColor);
            CGContextBeginPath(c);
            CGContextMoveToPoint(c, self.shadowSize, rect.size.height);
            CGContextAddLineToPoint(c, rect.size.width-self.shadowSize, rect.size.height);
            CGContextStrokePath(c);
            
            break;
        }
        case ShadowedCellPositionBottom:
        {    
            CGMutablePathRef pathRef = CGPathCreateMutable();
            
            // Top left corner
            CGPathMoveToPoint(pathRef, NULL, self.shadowSize, -self.shadowSize);
            
            // Bottom left corner
            CGPathAddLineToPoint(pathRef, NULL, self.shadowSize, rect.size.height-(self.cornerRadius+self.shadowSize));
            CGPathAddArcToPoint(pathRef, NULL, self.shadowSize, rect.size.height-self.shadowSize, self.shadowSize+self.cornerRadius, rect.size.height-self.shadowSize, self.cornerRadius);
            
            // Bottom right corner
            CGPathAddLineToPoint(pathRef, NULL, rect.size.width-(self.shadowSize+self.cornerRadius), rect.size.height-self.shadowSize);
            CGPathAddArcToPoint(pathRef, NULL, rect.size.width-self.shadowSize, rect.size.height-self.shadowSize, rect.size.width-self.shadowSize, rect.size.height-(self.shadowSize+self.cornerRadius), self.cornerRadius);
            
            // Top right corner
            CGPathAddLineToPoint(pathRef, NULL, rect.size.width-shadowSize, -self.shadowSize);
            
            // Fill the path we just drew
            CGContextAddPath(c, pathRef);
            CGContextSetShadowWithColor(c, CGSizeMake(0,0), self.shadowSize, self.shadowColor.CGColor);
            CGContextFillPath(c);
            
            
            // Draw the outer border
            CGContextAddPath(c, pathRef);
            CGContextSetStrokeColorWithColor(c, self.borderColor.CGColor);
            CGContextSetShadowWithColor(c, CGSizeMake(0,0), 0, NULL);
            CGContextStrokePath(c);
        }
            break;
        case ShadowedCellPositionMiddle:
        {
            CGContextSetShadowWithColor(c, CGSizeMake(0,0), self.shadowSize, self.shadowColor.CGColor);
            
            // Fill the rect
            CGRect fillRect = CGRectMake(self.shadowSize, -self.shadowSize, rect.size.width-(2*self.shadowSize), rect.size.height+(2*self.shadowSize));
            CGContextFillRect(c, fillRect);
            
            // Get ready to draw the outer border
            CGContextSetShadowWithColor(c, CGSizeMake(0,0), 0, NULL);
            CGContextSetStrokeColorWithColor(c, self.borderColor.CGColor);
            
            CGContextBeginPath(c);
            // Top left corner
            CGContextMoveToPoint(c, self.shadowSize, 0.0);
            // Bottom left corner
            CGContextAddLineToPoint(c, self.shadowSize, rect.size.height);
            CGContextStrokePath(c);
            
            CGContextBeginPath(c);
            // Top right corner
            CGContextMoveToPoint(c, rect.size.width-self.shadowSize, 0.0);
            // Bottom right corner
            CGContextAddLineToPoint(c, rect.size.width-self.shadowSize, rect.size.height);
            CGContextStrokePath(c);
            
            // Now draw the separator line
            CGContextSetStrokeColorWithColor(c, self.separatorColor.CGColor);
            CGContextBeginPath(c);
            // Bottom left corner
            CGContextMoveToPoint(c, self.shadowSize, rect.size.height);
            // Bottom right corner
            CGContextAddLineToPoint(c, rect.size.width-self.shadowSize, rect.size.height);
            CGContextStrokePath(c);
            
            break;
        }   
        case ShadowedCellPositionSingle:
        {
            CGContextSetStrokeColorWithColor(c, self.borderColor.CGColor);
            CGContextBeginPath(c);
            
            // Top left corner
            CGContextMoveToPoint(c, self.shadowSize, self.shadowSize+self.cornerRadius);
            
            // Bottom left corner
            CGContextAddLineToPoint(c, self.shadowSize, rect.size.height-(self.shadowSize+self.cornerRadius));
            CGContextAddArcToPoint(c, self.shadowSize, rect.size.height-self.shadowSize, self.shadowSize+self.cornerRadius, rect.size.height-self.shadowSize, self.cornerRadius);
            
            // Bottom right corner
            CGContextAddLineToPoint(c, rect.size.width-(self.shadowSize+self.cornerRadius), rect.size.height-self.shadowSize);
            CGContextAddArcToPoint(c, rect.size.width-self.shadowSize, rect.size.height-self.shadowSize, rect.size.width-self.shadowSize, rect.size.height-(self.shadowSize+self.cornerRadius), self.cornerRadius);
            
            // Top right corner
            CGContextAddLineToPoint(c, rect.size.width-self.shadowSize, self.shadowSize+self.cornerRadius);
            CGContextAddArcToPoint(c, rect.size.width-self.shadowSize, self.shadowSize, rect.size.width-(self.shadowSize+self.cornerRadius), self.shadowSize, self.cornerRadius);
            
            // Top left corner
            CGContextAddLineToPoint(c, self.shadowSize+self.cornerRadius, self.shadowSize);
            CGContextAddArcToPoint(c, self.shadowSize, self.shadowSize, self.shadowSize, self.shadowSize+self.cornerRadius, self.cornerRadius);
            
            CGContextDrawPath(c, kCGPathFillStroke);
            
            break;
        }
        default:
            break;
    }
}

@end