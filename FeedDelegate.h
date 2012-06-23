//
//  FeedDelegate.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/21/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedDelegate <NSObject>

- (void)feedDidLoad:(id)feed;

@end
