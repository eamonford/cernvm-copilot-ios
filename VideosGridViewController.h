//
//  VideosGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "CernMediaMARCParser.h"

@interface VideosGridViewController : AQGridViewController<AQGridViewDataSource, AQGridViewDelegate, CernMediaMarcParserDelegate>
{
    CernMediaMARCParser *parser;
    NSOperationQueue *queue;
    UIView *loadingView;
    NSMutableArray *videoMetadata;
    NSMutableDictionary *videoThumbnails;
}

@property (nonatomic, strong) CernMediaMARCParser *parser;
@property (nonatomic, strong) NSMutableArray *videoMetadata;
@property (nonatomic, strong) NSMutableDictionary *videoThumbnails;

@end
