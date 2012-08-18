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

- (void)loadHTMLString
{
    if (!_pendingHTMLStringLoad) {
        _pendingHTMLStringLoad = YES;
        _asyncData = [[NSMutableData alloc] init];
        self.recentWebcasts = [[NSMutableArray alloc] init];
        self.upcomingWebcasts = [[NSMutableArray alloc] init];
        self.recentWebcastThumbnails = [NSMutableDictionary dictionary];
        self.upcomingWebcastThumbnails = [NSMutableDictionary dictionary];
        NSURL *webpageURL = [NSURL URLWithString:WEBCAST_PAGE_URL];
        NSURLRequest *request = [NSURLRequest requestWithURL:webpageURL];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void)parseRecentWebcasts
{
    if (!_htmlString) {
        _pendingRecentWebcastsParse = YES;
        [self loadHTMLString];
        return;
    }
    NSScanner *scanner = [NSScanner scannerWithString:_htmlString];
    numParsersLoading = 0;
    while ([scanner scanUpToString:@"<div class=\"recentEvents\"" intoString:NULL]) {
        NSString *beginningOfLink = @"<a href=\"https://cdsweb.cern.ch/record/";
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
    _pendingRecentWebcastsParse = NO;
}

- (void)parseUpcomingWebcasts
{
    if (!_htmlString) {
        _pendingUpcomingWebcastsParse = YES;
        [self loadHTMLString];
        return;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:_htmlString];
    while ([scanner scanUpToString:@"<div class=\"upcomEvents timezoneChange\"" intoString:NULL]) {

        NSMutableDictionary *webcast = [NSMutableDictionary dictionary];
        // Extract the image URL
        if ([scanner scanUpToString:@"<img class=\"upcomImg\" src=\"" intoString:NULL]) {
            [scanner scanString:@"<img class=\"upcomImg\" src=\"" intoString:NULL];
            NSString *imageURL;
            [scanner scanUpToString:@"\"" intoString:&imageURL];
            if (imageURL)
                [webcast setValue:[NSURL URLWithString:imageURL] forKey:@"thumbnailURL"];
        }
        // Extract the webcast title
        if ([scanner scanUpToString:@"<div class=\"upcomEventTitle\" title=\"" intoString:NULL]) {
            [scanner scanString:@"<div class=\"upcomEventTitle\" title=\"" intoString:NULL];
            NSString *title;
            [scanner scanUpToString:@"\"" intoString:&title];
            if (title)
                [webcast setValue:title forKey:@"title"];
        }
        // Extract the webcast description
        if ([scanner scanUpToString:@"<div class=\"upcomEventDesc\" title=\"" intoString:NULL]) {
            [scanner scanString:@"<div class=\"upcomEventDesc\" title=\"" intoString:NULL];
            NSString *description;
            [scanner scanUpToString:@"\"" intoString:&description];
            if (description)
                [webcast setValue:description forKey:@"description"];
        }
        // Extract the date
        if ([scanner scanUpToString:@"<p class=\"changeable_date_time\">" intoString:NULL]) {
            [scanner scanString:@"<p class=\"changeable_date_time\">" intoString:NULL];
            NSString *dateString;
            [scanner scanUpToString:@"</p>" intoString:&dateString];
            
            NSTimeZone *timeZone;
            // Extract the time zone
            if ([scanner scanUpToString:@"<p class=\"dynamic_timezone_label\">" intoString:NULL]) {
                [scanner scanString:@"<p class=\"dynamic_timezone_label\">" intoString:NULL];
                NSString *timeZoneString;
                [scanner scanUpToString:@"</p>" intoString:&timeZoneString];
                timeZone = [NSTimeZone timeZoneWithName:timeZoneString];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.timeZone = timeZone;
            dateFormatter.dateFormat = @"MMMM d, yyyy h:mm a";
            NSDate *date = [dateFormatter dateFromString:dateString];
            if (date)
                [webcast setValue:date forKey:@"date"];
        }

        if (webcast.count)
            [self.upcomingWebcasts addObject:webcast];
        
        // Now sort the webcasts in order by date
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        self.upcomingWebcasts = [[self.upcomingWebcasts sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParser:didParseUpcomingWebcast:)]) {
            [self.delegate webcastsParser:self didParseUpcomingWebcast:webcast];
        }
    }
    _pendingUpcomingWebcastsParse = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParserDidFinishParsingUpcomingWebcasts:)]) {
        [self.delegate webcastsParserDidFinishParsingUpcomingWebcasts:self];
    }
    [self performSelectorInBackground:@selector(downloadAllThumbnailsForUpcomingWebcasts) withObject:nil];

}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_asyncData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _htmlString = [[NSString alloc] initWithData:_asyncData encoding:NSUTF8StringEncoding];
    _pendingHTMLStringLoad = NO;
    
    if (_pendingRecentWebcastsParse)
        [self parseRecentWebcasts];
    if (_pendingUpcomingWebcastsParse)
        [self parseUpcomingWebcasts];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _pendingHTMLStringLoad = NO;
    _pendingRecentWebcastsParse = NO;
    _pendingUpcomingWebcastsParse = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParser:didFailWithError:)])
        [self.delegate webcastsParser:self didFailWithError:error];
}

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)record
{
    [self.recentWebcasts addObject:record];

    if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParser:didParseRecentWebcast:)]) {
        [self.delegate webcastsParser:self didParseRecentWebcast:record];
    }
}

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    numParsersLoading--;
    if (numParsersLoading == 0) {
        
        // Sort the webcasts by date
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        self.recentWebcasts = [[self.recentWebcasts sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParserDidFinishParsingRecentWebcasts:)]) {
            [self.delegate webcastsParserDidFinishParsingRecentWebcasts:self];
        }
        [self performSelectorInBackground:@selector(downloadAllThumbnailsForRecentWebcasts) withObject:nil];
    }
}

#pragma mark - Downloading thumbnails

- (void)downloadAllThumbnailsForRecentWebcasts
{
    for (NSDictionary *webcast in self.recentWebcasts) {
        [self downloadThumbnailForRecentWebcast:webcast];
    }
}

- (void)downloadAllThumbnailsForUpcomingWebcasts
{
    for (NSDictionary *webcast in self.upcomingWebcasts) {
        [self downloadThumbnailForUpcomingWebcast:webcast];
    }
}

- (void)downloadThumbnailForRecentWebcast:(NSDictionary *)webcast
{
    NSDictionary *resources = [webcast objectForKey:@"resources"];
    NSURL *url;
    if ([resources objectForKey:@"jpgthumbnail"])
        url = [[resources objectForKey:@"jpgthumbnail"] objectAtIndex:0];
    else
        url = [[resources objectForKey:@"pngthumbnail"] objectAtIndex:0];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *thumbnailData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailData];
    int index = [self.recentWebcasts indexOfObject:webcast];
    if (thumbnailImage) {
        [self.recentWebcastThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
    } else {
        NSLog(@"Error downloading thumbnail #%d, will try again.", index);
        [self downloadThumbnailForRecentWebcast:webcast];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParser:didDownloadThumbnailForRecentWebcastIndex:)]) {
        [self performSelectorOnMainThread:@selector(informDelegateOfRecentWebcastThumbnailDownloadForIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
    }
}

- (void)downloadThumbnailForUpcomingWebcast:(NSDictionary *)webcast
{
    NSURL *url = [webcast objectForKey:@"thumbnailURL"];
   // NSLog(@"trying upcoming thumbnail url: %@", url);

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *thumbnailData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailData];
    int index = [self.upcomingWebcasts indexOfObject:webcast];
    if (thumbnailImage) {
        [self.upcomingWebcastThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
    } else {
        NSLog(@"Error downloading thumbnail #%d, will try again.", index);
        [self downloadThumbnailForUpcomingWebcast:webcast];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webcastsParser:didDownloadThumbnailForUpcomingWebcastIndex:)]) {
        [self performSelectorOnMainThread:@selector(informDelegateOfUpcomingWebcastThumbnailDownloadForIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
    }
}

- (void)informDelegateOfRecentWebcastThumbnailDownloadForIndex:(NSNumber *)index
{
    [self.delegate webcastsParser:self didDownloadThumbnailForRecentWebcastIndex:index.intValue];
}

- (void)informDelegateOfUpcomingWebcastThumbnailDownloadForIndex:(NSNumber *)index
{
    [self.delegate webcastsParser:self didDownloadThumbnailForUpcomingWebcastIndex:index.intValue];
}

@end
