//
//  VideosGridViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "CernMediaMARCParser.h"
#import "MBProgressHUD.h"
@interface VideosGridViewController : AQGridViewController<AQGridViewDataSource, AQGridViewDelegate, CernMediaMarcParserDelegate, MBProgressHUDDelegate>
{
    NSOperationQueue *queue;
    MBProgressHUD *_noConnectionHUD;
}

@property (nonatomic, strong) CernMediaMARCParser *parser;
@property (nonatomic, strong) NSMutableArray *videoMetadata;
@property (nonatomic, strong) NSMutableDictionary *videoThumbnails;

- (void)refresh;
@end
