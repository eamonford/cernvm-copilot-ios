//
//  RSSFeed.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/28/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSFeed : NSObject <NSURLConnectionDelegate>
{
    NSString *title;
    NSString *description;
    NSURL *url;    
    NSMutableArray *articles;
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSMutableArray *articles;

- (void)refresh;

@end
