//
//  TwitterFeed.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/21/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedDelegate.h"

@interface TwitterFeed : NSObject
{
    NSString *screenName;
    NSArray *posts;
    id<FeedDelegate> delegate;
}
@property (nonatomic, retain) NSString *screenName;
@property (atomic, retain) NSArray *posts;
@property (nonatomic, strong) id<FeedDelegate> delegate;

- (id)initWithScreenName:(NSString *)screenName;
- (void)refresh;

@end
