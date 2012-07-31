//
//  NSDate+LastOccurrenceOfWeekday.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/30/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "NSDate+LastOccurrenceOfWeekday.h"

@implementation NSDate (LastOccurrenceOfWeekday)

- (NSDate *)nextOccurrenceOfWeekday:(int)targetWeekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    int startingWeekday = components.weekday;
    int daysTillTarget = (targetWeekday-startingWeekday+7)%7;
        
    return [self dateByAddingTimeInterval:60*60*24*daysTillTarget];
}

- (NSDate *)midnight
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    //components.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

@end
