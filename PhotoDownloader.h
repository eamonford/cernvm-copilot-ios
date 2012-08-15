//
//  PhotoDownloader.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/4/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CernMediaMARCParser.h"

@class PhotoDownloader;

@protocol PhotoDownloaderDelegate <NSObject>
@optional
- (void)photoDownloaderDidFinish:(PhotoDownloader *)photoDownloader;
- (void)photoDownloader:(PhotoDownloader *)photoDownloader didDownloadThumbnailForIndex:(int)index;
@end

@interface PhotoDownloader : NSObject<CernMediaMarcParserDelegate>
{
    NSMutableArray *urls;
    NSMutableDictionary *thumbnails;
    id<PhotoDownloaderDelegate> delegate;
    
    @private
    CernMediaMARCParser *parser;
    NSOperationQueue *queue;
}

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableDictionary *thumbnails;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) id<PhotoDownloaderDelegate> delegate;

- (void)parse;

@end
