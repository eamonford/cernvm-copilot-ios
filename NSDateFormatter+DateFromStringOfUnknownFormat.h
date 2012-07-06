//
//  NSDateFormatter+DateFromStringOfUnknownStyle.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/6/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (DateFromStringOfUnknownFormat)
 
- (NSDate *)dateFromStringOfUnknownFormat:(NSString *)string;

@end
