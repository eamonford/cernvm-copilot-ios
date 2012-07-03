//
//  AppDelegate.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/24/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSFeed.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *photoURLs;
    NSMutableDictionary *photoThumbnails;
    
    NSMutableArray *videoURLs;
    NSMutableDictionary *videoThumbnails;
}
@property (nonatomic, retain) NSMutableArray *photoURLs;
@property (nonatomic, retain) NSMutableDictionary *photoThumbnails;
@property (nonatomic, retain) NSMutableArray *videoURLs;
@property (nonatomic, retain) NSMutableDictionary *videoThumbnails;

@property (strong, nonatomic) UIWindow *window;

@end
