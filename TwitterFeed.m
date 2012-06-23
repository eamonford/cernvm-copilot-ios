//
//  TwitterFeed.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/21/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "TwitterFeed.h"
#import <Twitter/Twitter.h>

@implementation TwitterFeed
@synthesize screenName, posts, delegate;

- (id)init
{
    if (self = [super init]) {
        self.screenName = @"";
        self.posts = [NSArray array];
    }
    return self;
}
- (id)initWithScreenName:(NSString *)name
{
    if (self = [super init]) {
        self.screenName = name;
        self.posts = [NSArray array];
        NSLog(@"initializing feed");
    }
    return self;
}

- (void)refresh
{
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=%@", self.screenName]] parameters:nil requestMethod:TWRequestMethodGET];
    // Perform the request created above and create a handler block to handle the response.
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            // Parse the responseData, which we asked to be in JSON format for this request, into an array of dictionaries using NSJSONSerialization.
            NSError *jsonParsingError = nil;
            self.posts = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
        } else {
            NSLog(@"Error retreiving twitter feed for user %@: returned HTTP status code %i", self.screenName, [urlResponse statusCode]);
        }
        NSLog(@"parsed... now telling delegate");
        [self.delegate feedDidLoad:self];
    }];
    
}

@end
