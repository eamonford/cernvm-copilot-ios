//
//  NSDate+LastOccurrenceOfWeekday.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/30/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LastOccurrenceOfWeekday)

- (NSDate *)nextOccurrenceOfWeekday:(int)targetWeekday;
- (NSDate *)midnight;

@end
