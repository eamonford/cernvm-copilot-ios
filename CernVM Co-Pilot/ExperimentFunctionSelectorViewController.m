//
//  ExperimentDetailTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ExperimentFunctionSelectorViewController.h"
#import "EventDisplayViewController.h"
#import "PhotosGridViewController.h"
#import "AppDelegate.h"
#import "NewsGridViewController.h"
#import "Constants.h"

@interface ExperimentFunctionSelectorViewController ()

@end

@implementation ExperimentFunctionSelectorViewController
//@synthesize experiment;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    switch (self.experiment) {
        case ATLAS:
            self.title = @"ATLAS";
            break;
        case CMS:
            self.title = @"CMS";
            break;
        case ALICE:
            self.title = @"ALICE";
            break;
        case LHCb:
            self.title = @"LHCb";
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);

}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowExperimentNews"]) {
        NewsTableViewController *viewController = segue.destinationViewController;
        switch (self.experiment) {
            case ATLAS:
            {
                viewController.title = @"ATLAS News";
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://pdg2.lbl.gov/atlasblog/?feed=rss2"]];
                [viewController refresh];
                break;
            }
            case CMS:
            {
                viewController.title = @"CMS News";
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://cms.web.cern.ch/news/category/265/rss.xml"]];
                [viewController refresh];
                break;
            }
            case ALICE:
            {
                viewController.title = @"ALICE News";
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://alicematters.web.cern.ch/rss.xml"]];
                [viewController refresh];
            
                break;
            }
            case LHCb:
            {
                viewController.title = @"LHCb News";
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"https://twitter.com/statuses/user_timeline/92522167.rss"]];
                [viewController refresh];
                break;
            }
            default:
                break;
        }
    } else if ([segue.identifier isEqualToString:@"ShowEventDisplay"]) {
        EventDisplayViewController *viewController = segue.destinationViewController;
        switch (self.experiment) {
            case ATLAS:
            {
                CGFloat largeImageDimension = 764.0;
                CGFloat smallImageDimension = 379.0;
                
                CGRect frontViewRect = CGRectMake(2.0, 2.0, largeImageDimension, largeImageDimension);
                NSDictionary *frontView = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:frontViewRect], @"Rect", @"Front", @"Description", nil];
                
                CGRect sideViewRect = CGRectMake(2.0+4.0+largeImageDimension, 2.0, smallImageDimension, smallImageDimension);
                NSDictionary *sideView = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:sideViewRect], @"Rect", @"Side", @"Description", nil];
                
                NSArray *boundaryRects = [NSArray arrayWithObjects:frontView, sideView, nil];
                [viewController addSourceWithDescription:nil URL:[NSURL URLWithString:@"http://atlas-live.cern.ch/live.png"] boundaryRects:boundaryRects];
                viewController.title = @"ATLAS";
                break;
            }
            case CMS:
            {
                [viewController addSourceWithDescription:@"3D Tower" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/3DTower.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"3D RecHit" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/3DRecHit.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"Lego" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/Lego.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"RhoPhi" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/RhoPhi.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"RhoZ" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/RhoZ.png"] boundaryRects:nil];
                viewController.title = @"CMS";
                break;
            }
            case ALICE:
            {
                break;
            }
            case LHCb:
            {
                CGRect cropRect = CGRectMake(0.0, 66.0, 1685.0, 811.0);
                NSDictionary *croppedView = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:cropRect], @"Rect", @"Side", @"Description", nil];

                NSArray *boundaryRects = [NSArray arrayWithObjects:croppedView, nil];
                [viewController addSourceWithDescription:nil URL:[NSURL URLWithString:@"http://lbcomet.cern.ch/Online/Images/evdisp.jpg"] boundaryRects:boundaryRects];
                viewController.title = @"LHCB";
                break;
            }
            default:
                break;
        }
    } else if ([segue.identifier isEqualToString:@"ShowEventPhotos"]) {
        PhotosGridViewController *photosViewController = segue.destinationViewController;
        photosViewController.photoDownloader.url = [NSURL URLWithString:@"https://cdsweb.cern.ch/record/1305399/export/xm?ln=en"];
        [photosViewController refresh];
    }
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            switch (self.experiment) {
                case ATLAS:
                    cell.textLabel.text = @"ATLAS News";
                    break;
                case CMS:
                    cell.textLabel.text = @"CMS News";
                    break;
                case ALICE:
                    cell.textLabel.text = @"ALICE News";
                    break;
                case LHCb:
                    cell.textLabel.text = @"LHCb News";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = @"Event Display";
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard;
    UINavigationController *navigationController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        navigationController = [appDelegate.tabBarController.viewControllers objectAtIndex:TabIndexLive];
        ExperimentsViewController *experimentsVC = (ExperimentsViewController *)navigationController.topViewController;
        [experimentsVC.popoverController dismissPopoverAnimated:YES];

    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        navigationController = self.navigationController;
    }
        
    switch (indexPath.row) {
        case 0:
        {
            NewsGridViewController *newsViewController = [mainStoryboard instantiateViewControllerWithIdentifier:kExperimentNewsViewController];
            switch (self.experiment) {
                case ATLAS:
                {
                    newsViewController.title = @"ATLAS News";
                    [newsViewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://pdg2.lbl.gov/atlasblog/?feed=rss2"]];
                    break;
                }
                case CMS:
                {
                    newsViewController.title = @"CMS News";
                    [newsViewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://cms.web.cern.ch/news/category/265/rss.xml"]];
                    break;
                }
                case ALICE:
                {
                    newsViewController.title = @"ALICE News";
                    [newsViewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://alicematters.web.cern.ch/rss.xml"]];
                    break;
                }
                case LHCb:
                {
                    newsViewController.title = @"LHCb News";
                    [newsViewController.aggregator addFeedForURL:[NSURL URLWithString:@"https://twitter.com/statuses/user_timeline/92522167.rss"]];
                    break;
                }
                default:
                    break;
            }
            [newsViewController refresh];
            [navigationController pushViewController:newsViewController animated:YES];
            break;
        }
        case 1:
        {
            EventDisplayViewController *eventViewController = [mainStoryboard instantiateViewControllerWithIdentifier:kEventDisplayViewController];
            
            switch (self.experiment) {
                case ATLAS:
                {
                    CGFloat largeImageDimension = 764.0;
                    CGFloat smallImageDimension = 379.0;
                    
                    CGRect frontViewRect = CGRectMake(2.0, 2.0, largeImageDimension, largeImageDimension);
                    NSDictionary *frontView = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:frontViewRect], @"Rect", @"Front", @"Description", nil];
                    
                    CGRect sideViewRect = CGRectMake(2.0+4.0+largeImageDimension, 2.0, smallImageDimension, smallImageDimension);
                    NSDictionary *sideView = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:sideViewRect], @"Rect", @"Side", @"Description", nil];
                    
                    NSArray *boundaryRects = [NSArray arrayWithObjects:frontView, sideView, nil];
                    [eventViewController addSourceWithDescription:nil URL:[NSURL URLWithString:@"http://atlas-live.cern.ch/live.png"] boundaryRects:boundaryRects];
                    eventViewController.title = @"ATLAS";
                    break;
                }
                case CMS:
                {
                    [eventViewController addSourceWithDescription:@"3D Tower" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/3DTower.png"] boundaryRects:nil];
                    [eventViewController addSourceWithDescription:@"3D RecHit" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/3DRecHit.png"] boundaryRects:nil];
                    [eventViewController addSourceWithDescription:@"Lego" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/Lego.png"] boundaryRects:nil];
                    [eventViewController addSourceWithDescription:@"RhoPhi" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/RhoPhi.png"] boundaryRects:nil];
                    [eventViewController addSourceWithDescription:@"RhoZ" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/RhoZ.png"] boundaryRects:nil];
                    eventViewController.title = @"CMS";
                    break;
                }
                case ALICE:
                {
                    PhotosGridViewController *photosViewController = [mainStoryboard instantiateViewControllerWithIdentifier:kALICEPhotoGridViewController];
                    
                    photosViewController.photoDownloader.url = [NSURL URLWithString:@"https://cdsweb.cern.ch/record/1305399/export/xm?ln=en"];
                    [photosViewController refresh];
                    [navigationController pushViewController:photosViewController animated:YES];
                    return;
                }
                case LHCb:
                {
                    CGRect cropRect = CGRectMake(0.0, 66.0, 1685.0, 811.0);
                    NSDictionary *croppedView = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGRect:cropRect], @"Rect", @"Side", @"Description", nil];
                    
                    NSArray *boundaryRects = [NSArray arrayWithObjects:croppedView, nil];
                    [eventViewController addSourceWithDescription:nil URL:[NSURL URLWithString:@"http://lbcomet.cern.ch/Online/Images/evdisp.jpg"] boundaryRects:boundaryRects];
                    eventViewController.title = @"LHCB";
                    break;
                }
                default:
                    break;
            }
            [navigationController pushViewController:eventViewController animated:YES];
            break;
        }
        default:
            break;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    }

}

@end
