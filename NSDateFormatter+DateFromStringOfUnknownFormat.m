//
//  NSDateFormatter+DateFromStringOfUnknownStyle.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/6/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "NSDateFormatter+DateFromStringOfUnknownFormat.h"

@implementation NSDateFormatter (DateFromStringOfUnknownFormat)

- (NSDate *)dateFromStringOfUnknownFormat:(NSString *)string
{
    NSDate *date;
    
    //self.locale = [NSLocale currentLocale];
    self.timeStyle = NSDateFormatterNoStyle;
    [self setLenient:YES];
    
    NSArray *allLocales = [NSLocale availableLocaleIdentifiers];
    int numLocales = allLocales.count;
    
    for (int i=0; i<numLocales; i++) {
        self.locale = [[NSLocale alloc] initWithLocaleIdentifier:[allLocales objectAtIndex:i]];
        
        self.dateStyle = NSDateFormatterShortStyle;
        date = [self dateFromString:string];
        if (date)
            return date;
        self.dateStyle = NSDateFormatterMediumStyle;
        if (date)
            return date;
        self.dateStyle = NSDateFormatterLongStyle;
        if (date)
            return date;
        self.dateStyle = NSDateFormatterFullStyle;
        if (date)
            return date;
    }
    return nil;
}

@end
