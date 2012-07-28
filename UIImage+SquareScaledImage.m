//
//  UIImage+SquareScaledImage.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/28/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "UIImage+SquareScaledImage.h"

@implementation UIImage (SquareScaledImage)


+ (UIImage *)squareImageWithDimension:(float)dimension fromImage:(UIImage *)originalImage
{
    CGImageRef imageRef = originalImage.CGImage;
    CGFloat width = originalImage.size.width;
    CGFloat height = originalImage.size.height;
    CGFloat minDimension = width<height ? width : height;
    
    CGRect cropRect = CGRectMake(0.0, 0.0, minDimension, minDimension);
    
    imageRef = CGImageCreateWithImageInRect(imageRef, cropRect);
    
    float scaleFactor = dimension/originalImage.size.width;
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scaleFactor orientation:UIImageOrientationUp];
    
    return image;
}

@end
