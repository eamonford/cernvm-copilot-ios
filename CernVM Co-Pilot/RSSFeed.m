//
//  RSSFeed.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/28/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "RSSFeed.h"
#import "RSSArticle.h"

//@interface RSSFeed (ReadOnlyProperties)
//
//@property (nonatomic, retain) MWFeedParser *parser;
//@property (nonatomic, retain) MWFeedInfo *info;
//@property (nonatomic, retain) NSMutableArray *articles;
//
//@end

@implementation RSSFeed
@synthesize /*title, description, url,*/ parser, info, articles, aggregator, delegate;

- (id)initWithFeedURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.parser = [[MWFeedParser alloc] initWithFeedURL:url];
        self.parser.feedParseType = ParseTypeFull;
        self.parser.connectionType = ConnectionTypeAsynchronously;
        self.parser.delegate = self;
        self.articles = [NSMutableArray array];
    }
    return self;
}

- (void)refresh
{
//    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] 
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               if ([self setTitleAndArticlesFromRSSData:data]) {
//                                   if (self.delegate) {
//                                       [self.delegate rssFeedDidLoad:self];
//                                   }
//                               }
//                           }];
    self.articles = [NSMutableArray array];
    [self.parser parse];
}


//- (BOOL)setTitleAndArticlesFromRSSData:(NSData *)data
//{
//    GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:NULL];
//    if (xmlDoc) {
//        GDataXMLNode* feedTitleNode = [[[xmlDoc rootElement] nodesForXPath:@"channel/title" error:NULL] objectAtIndex:0];
//        self.title = feedTitleNode.stringValue;
//        
//        NSArray* items = [[xmlDoc rootElement] nodesForXPath:@"channel/item" error:NULL];
//        for (GDataXMLNode *item in items) {
//            GDataXMLNode *itemTitleNode = [[item nodesForXPath:@"title" error:NULL] objectAtIndex:0];
//            GDataXMLNode *itemDescriptionNode = [[item nodesForXPath:@"description" error:NULL] objectAtIndex:0];
//            GDataXMLNode *itemURLNode = [[item nodesForXPath:@"link" error:NULL] objectAtIndex:0];
//            RSSArticle *article = [[RSSArticle alloc] init];
//            article.title = itemTitleNode.stringValue;
//            article.description = itemDescriptionNode.stringValue;
//            article.url = [NSURL URLWithString:itemURLNode.stringValue];
//            [self.articles addObject:article];
//        }
//        
//        return YES;
//    }
//    return NO;
//}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)feedInfo
{
    self.info = feedInfo;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    [self.articles addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser
{
    if (aggregator)
        [aggregator rssFeedDidLoad:self];
    if (delegate)
        [delegate rssFeedDidLoad:self];
}

@end
