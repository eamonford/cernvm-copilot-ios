//
//  RSSFeed.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/28/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSFeed.h"
#import "RSSArticle.h"
#import "GDataXMLNode.h"


@implementation RSSFeed
@synthesize title, description, url, articles, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.articles = [NSMutableArray array];
    }
    return self;
}

- (void)refresh
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([self setTitleAndArticlesFromRSSData:data]) {
                                   if (self.delegate) {
                                       [self.delegate rssFeedDidLoad:self];
                                   }
                               }
                           }];
    
}

- (BOOL)setTitleAndArticlesFromRSSData:(NSData *)data
{
    GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:NULL];
    if (xmlDoc) {
        GDataXMLNode* feedTitleNode = [[[xmlDoc rootElement] nodesForXPath:@"channel/title" error:NULL] objectAtIndex:0];
        self.title = feedTitleNode.stringValue;
        
        NSArray* items = [[xmlDoc rootElement] nodesForXPath:@"channel/item" error:NULL];
        for (GDataXMLNode *item in items) {
            GDataXMLNode *itemTitleNode = [[item nodesForXPath:@"title" error:NULL] objectAtIndex:0];
            GDataXMLNode *itemDescriptionNode = [[item nodesForXPath:@"description" error:NULL] objectAtIndex:0];
            GDataXMLNode *itemURLNode = [[item nodesForXPath:@"link" error:NULL] objectAtIndex:0];
            RSSArticle *article = [[RSSArticle alloc] init];
            article.title = itemTitleNode.stringValue;
            article.description = itemDescriptionNode.stringValue;
            article.url = [NSURL URLWithString:itemURLNode.stringValue];
            [self.articles addObject:article];
        }
        
        return YES;
    }
    return NO;
}

// NSURLConnectionDelegate methods


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // If a feed requires authentication, just cancel the request.
    [challenge.sender cancelAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"The feed \"%@\" failed to load! Error code %d", self.title, error.code);
}

@end
