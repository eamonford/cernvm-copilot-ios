//
//  AppDelegate.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/24/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSFeed.h"
#import "PhotoDownloader.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    PhotoDownloader *photoDownloader;
    NSMutableArray *videoMetadata;
    NSMutableDictionary *videoThumbnails;
}

@property (nonatomic, retain) PhotoDownloader *photoDownloader;

@property (nonatomic, retain) NSMutableArray *videoMetadata;
@property (nonatomic, retain) NSMutableDictionary *videoThumbnails;

@property (strong, nonatomic) UIWindow *window;

@end
