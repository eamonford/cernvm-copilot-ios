//
//  WebcastsParser.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/16/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "WebcastsParser.h"
#import "Constants.h"

#define WEBCAST_PAGE_URL @"http://webcast.web.cern.ch/webcast/"

@implementation WebcastsParser

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}
- (void)parseRecent
{
    _recentsData = [[NSMutableData alloc] init];
    self.recentWebcasts = [[NSMutableArray alloc] init];
    self.recentWebcastThumbnails = [NSMutableDictionary dictionary];
    NSURL *webpageURL = [NSURL URLWithString:WEBCAST_PAGE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:webpageURL];
    _recentsConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _recentsConnection) {
        [_recentsData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == _recentsConnection) {
        NSString *htmlString = [[NSString alloc] initWithData:_recentsData encoding:NSUTF8StringEncoding];
        NSScanner *scanner = [NSScanner scannerWithString:htmlString];
        numParsersLoading = 0;
        while ([scanner scanUpToString:@"div class=\"recentEvents\"" intoString:NULL]) {
            NSString *beginningOfLink = @"a href=\"https://cdsweb.cern.ch/record/";
            if ([scanner scanUpToString:beginningOfLink intoString:NULL]) {
                [scanner scanString:beginningOfLink intoString:NULL];
                NSString *webcastID = @"";
                [scanner scanUpToString:@"\"" intoString:&webcastID];
                NSString *marcURLString = [NSString stringWithFormat:@"https://cdsweb.cern.ch/record/%@/export/xm?ln=en", webcastID];
                numParsersLoading++;
                CernMediaMARCParser *parser = [[CernMediaMARCParser alloc] init];
                parser.delegate = self;
                parser.url = [NSURL URLWithString:marcURLString];
                parser.resourceTypes = [NSArray arrayWithObjects:kVideoMetadataPropertyVideoURL, @"mp4mobile", kVideoMetadataPropertyThumbnailURL, @"jpgthumbnail", @"pngthumbnail", nil];
                [parser parse];
            }
        }
        
     }
}

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)record
{
    [self.recentWebcasts addObject:record];
    int recordIndex = [self.recentWebcasts indexOfObject:record];
    [self performSelectorInBackground:@selector(downloadThumbnailForIndex:) withObject:[NSNumber numberWithInt:recordIndex]];

    if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParser:didParseRecentItem:)]) {
        [self.delegate webcastsParser:self didParseRecentItem:record];
    }
}

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    numParsersLoading--;
    if (numParsersLoading == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParserDidFinishParsingParsingRecentWebcasts:)]) {
            [self.delegate webcastsParserDidFinishParsingParsingRecentWebcasts:self];
        }
    }
}

- (void)downloadThumbnailForIndex:(NSNumber *)indexNumber
{
    // now download the thumbnail for that photo
    int index = indexNumber.intValue;
    NSDictionary *webcast = [self.recentWebcasts objectAtIndex:index];
    NSDictionary *resources = [webcast objectForKey:@"resources"];
    NSURL *url;
    if ([resources objectForKey:@"jpgthumbnail"])
        url = [[resources objectForKey:@"jpgthumbnail"] objectAtIndex:0];
    else
        url = [[resources objectForKey:@"pngthumbnail"] objectAtIndex:0];
    NSLog(@"photo url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *thumbnailData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailData];
    if (thumbnailImage) {
        [self.recentWebcastThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
    } else {
        NSLog(@"Error downloading thumbnail #%d, will try again.", index);
        [self downloadThumbnailForIndex:indexNumber];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParser:didDownloadThumbnailForIndex:)]) {
        [self.delegate webcastsParser:self didDownloadThumbnailForIndex:index];
    }
}

@end
