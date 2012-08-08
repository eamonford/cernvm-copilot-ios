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

typedef enum {
    TabIndexNews,
    TabIndexAbout,
    TabIndexLive,
    TabIndexBulletin,
    TabIndexPhotos,
    TabIndexVideos,
    TabIndexJobs
} TabIndices;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>
{
    UITabBarController *tabBarController;
    NSMutableDictionary *tabsAlreadySetup;
    //PhotoDownloader *photoDownloader;
//    NSMutableArray *videoMetadata;
//    NSMutableDictionary *videoThumbnails;
}

- (void)setupViewController:(UIViewController *)viewController atIndex:(int)index;

@property (nonatomic, retain) UITabBarController *tabBarController;
//@property (nonatomic, retain) PhotoDownloader *photoDownloader;
//@property (nonatomic, retain) NSMutableArray *videoMetadata;
//@property (nonatomic, retain) NSMutableDictionary *videoThumbnails;

@property (strong, nonatomic) UIWindow *window;

@end
