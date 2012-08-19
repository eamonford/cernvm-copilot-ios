//
//  PhotoDownloader.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/4/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "PhotoDownloader.h"
#import "UIImage+SquareScaledImage.h"

@implementation PhotoDownloader
@synthesize urls, thumbnails, delegate;

- (id)init
{
    if (self = [super init]) {        
        parser = [[CernMediaMARCParser alloc] init];
        parser.delegate = self;
        parser.resourceTypes = [NSArray arrayWithObjects:@"jpgA4", @"jpgA5", @"jpgIcon", nil];
        
        queue = [NSOperationQueue new];
    }
    return self;
}

- (NSURL *)url
{
    return parser.url;
}

- (void)setUrl:(NSURL *)url;
{
    parser.url = url;
}

- (void)parse {
    self.isDownloading = YES;
    self.urls = [[NSMutableArray alloc] init];
    self.thumbnails = [NSMutableDictionary dictionary];
    [parser parse];
}

#pragma mark CernMediaMARCParserDelegate methods

- (void)parser:(CernMediaMARCParser *)aParser didParseRecord:(NSDictionary *)record
{
    // we will assume that each array in the dictionary has the same number of photo urls
    NSMutableDictionary *resources = [record objectForKey:@"resources"];
    int numPhotosInRecord = ((NSArray *)[resources objectForKey:[parser.resourceTypes objectAtIndex:0]]).count;
    for (int i=0; i<numPhotosInRecord; i++) {
        NSMutableDictionary *photo = [NSMutableDictionary dictionary];
        NSArray *resourceTypes = parser.resourceTypes;
        int numResourceTypes = resourceTypes.count;
        for (int j=0; j<numResourceTypes; j++) {
            NSString *currentResourceType = [resourceTypes objectAtIndex:j];
            NSURL *url = [[resources objectForKey:currentResourceType] objectAtIndex:i];
            
            [photo setObject:url forKey:currentResourceType];
        }
        [self.urls addObject:photo];
        
        // now download the thumbnail for that photo
        int index = self.urls.count-1;
        [self performSelectorInBackground:@selector(downloadThumbnailForIndex:) withObject:[NSNumber numberWithInt:index]];
    }
 }

// We will use a synchronous connection running in a background thread to download thumbnails
// because it is much simpler than handling an arbitrary number of asynchronous connections concurrently.
- (void)downloadThumbnailForIndex:(id)indexNumber
{
    // now download the thumbnail for that photo
    int index = ((NSNumber *)indexNumber).intValue;
    NSDictionary *photo = [self.urls objectAtIndex:index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[photo objectForKey:@"jpgIcon"]];
    NSData *thumbnailData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailData];
    if (thumbnailImage) {
        [self.thumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
    } else {
        NSLog(@"Error downloading thumbnail #%d, will try again.", index);
        [self downloadThumbnailForIndex:[NSNumber numberWithInt:index]];
    }
    
    if (self.thumbnails.count == self.urls.count)
        self.isDownloading = NO;
    
    if (delegate && [delegate respondsToSelector:@selector(photoDownloader:didDownloadThumbnailForIndex:)]) {
         [delegate photoDownloader:self didDownloadThumbnailForIndex:index];
    }
}

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    if (delegate && [delegate respondsToSelector:@selector(photoDownloaderDidFinish:)]) {
        [delegate photoDownloaderDidFinish:self];
    }
}

- (void)parser:(CernMediaMARCParser *)parser didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoDownloader:didFailWithError:)])
        [self.delegate photoDownloader:self didFailWithError:error];
}

@end
