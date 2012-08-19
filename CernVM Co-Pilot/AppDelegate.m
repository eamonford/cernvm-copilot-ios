//
//  AppDelegate.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/24/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AppDelegate.h"
#import "RSSAggregator.h"
#import "PhotosGridViewController.h"
#import "NewsGridViewController.h"
#import "BulletinGridViewController.h"
#import "StaticInfoSelectorViewController.h"
#import "StaticInfoScrollViewController.h"
#import "APSplitViewController.h"
#import "WebcastsGridViewController.h"
#import "Constants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    self.tabBarController.delegate = self;
    self.tabBarController.moreNavigationController.delegate = self;
    self.tabBarController.customizableViewControllers = [NSArray array];
    self.tabsAlreadySetup = [NSMutableDictionary dictionary];
        
    [self setupViewController:[self.tabBarController.viewControllers objectAtIndex:TabIndexNews] atIndex:TabIndexNews];

    return YES;
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
    int index = [theTabBarController.viewControllers indexOfObject:viewController];
    [self setupViewController:viewController atIndex:index];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)showingViewController animated:(BOOL)animated
{
    
    UINavigationBar *morenavbar = navigationController.navigationBar;
    UINavigationItem *morenavitem = morenavbar.topItem;
    /* We don't need Edit button in More screen. */
    morenavitem.rightBarButtonItem = nil;
    
    // In order to figure out the index of the selected view controller, we have to search through tabBarController.viewControllers for a UINavigationController that has no topViewController, because the selected view controller got popped off its navigation stack.
    id checkIfNil = ^BOOL(id element, NSUInteger idx, BOOL *stop) {
        return [(UINavigationController *)element topViewController] == nil;
    };
    int index = [self.tabBarController.viewControllers indexOfObjectPassingTest:checkIfNil];
    [self setupViewController:showingViewController atIndex:index];
}

- (void)setupViewController:(UIViewController *)viewController atIndex:(int)index
{
    // Only set up each view controller once, and then never do it again.
    if ([[self.tabsAlreadySetup objectForKey:[NSNumber numberWithInt:index]] boolValue])
        return;
    else
        [self.tabsAlreadySetup setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:index]];

    
    if ([viewController respondsToSelector:@selector(viewControllers)]) {
        viewController = [[(id)viewController viewControllers] objectAtIndex:0];
    }
    
    switch (index) {
        case TabIndexNews: {
            // Populate the general News view controller with news feeds
            [((NewsGridViewController *)viewController).aggregator addFeedForURL:[NSURL URLWithString:@"http://twitter.com/statuses/user_timeline/15234407.rss"]];
            [((NewsGridViewController *)viewController).aggregator addFeedForURL:[NSURL URLWithString:@"http://feeds.feedburner.com/CernCourier"]];
            
           
            
            [(NewsGridViewController *)viewController refresh];
            break;
        }
        case TabIndexAbout: {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"StaticInformation" ofType:@"plist"];
            NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
            self.staticInfoDataSource = [plistDict objectForKey:@"Root"];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                StaticInfoSelectorViewController *selectorViewController = (StaticInfoSelectorViewController *)[[self.tabBarController.viewControllers objectAtIndex:TabIndexAbout] topViewController];
                selectorViewController.tableDataSource = self.staticInfoDataSource;
                
            } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                NSArray *defaultRecords = [[self.staticInfoDataSource objectAtIndex:0] objectForKey:@"Items"];
                StaticInfoScrollViewController *scrollViewController = [self.tabBarController.viewControllers objectAtIndex:TabIndexAbout];
                scrollViewController.dataSource = defaultRecords;
                [scrollViewController refresh];
            }
            
            break;
        }
        case TabIndexLive: {
            break;
        }
        case TabIndexBulletin: {
            BulletinGridViewController *bulletinViewController = (BulletinGridViewController *)viewController;
            [bulletinViewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://cdsweb.cern.ch/rss?p=980__a%3ABULLETINNEWS%20or%20980__a%3ABULLETINNEWSDRAFT&ln=en"]];
            [bulletinViewController refresh];

            break;
        }
        case TabIndexPhotos: {
            // Initialize the photos view controller with a photo downloader object
            ((PhotosGridViewController *)viewController).photoDownloader.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Photos&p=&f=&action_search=Search&c=Photos&c=&sf=&so=d&rm=&rg=10&sc=1&of=xm"];
            //[(PhotosGridViewController *)viewController refresh];
            break;
        }
        case TabIndexVideos: {
            break;
        }
        case TabIndexJobs: {
            [((NewsGridViewController *)viewController).aggregator addFeedForURL:[NSURL URLWithString:@"https://ert.cern.ch/browse_www/wd_portal_rss.rss?p_hostname=ert.cern.ch"]];
            [(NewsGridViewController *)viewController refresh];
            break;
        }
        case TabIndexWebcasts: {
       /*     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
                APSplitViewController *splitViewController = (APSplitViewController *)viewController;
                WebcastTypeSelectorTableViewController *tableView = [mainStoryboard instantiateViewControllerWithIdentifier:kWebcastTypeSelectorTableViewController];
                splitViewController.masterViewController = tableView;
                
                WebcastsGridViewController *webcastsVC = [mainStoryboard instantiateViewControllerWithIdentifier:kWebcastsGridViewController];
                splitViewController.detailViewController = webcastsVC;
            }
            break;*/
        }
        default:
            break;
    }
}


@end
