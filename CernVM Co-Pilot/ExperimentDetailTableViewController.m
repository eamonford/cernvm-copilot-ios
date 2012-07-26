//
//  ExperimentDetailTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ExperimentDetailTableViewController.h"
#import "NewsTableViewController.h"
#import "EventDisplayViewController.h"

@interface ExperimentDetailTableViewController ()

@end

@implementation ExperimentDetailTableViewController
@synthesize experiment;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowExperimentNews"]) {
        NewsTableViewController *viewController = segue.destinationViewController;
        switch (self.experiment) {
            case ATLAS:
            {
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://pdg2.lbl.gov/atlasblog/?feed=rss2"]];
                break;
            }
            case CMS:
            {
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://cms.web.cern.ch/news/category/265/rss.xml"]];
                break;
            }
            case ALICE:
            {
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"http://alicematters.web.cern.ch/rss.xml"]];
            
                break;
            }
            case LHCb:
            {
                [viewController.aggregator addFeedForURL:[NSURL URLWithString:@"https://twitter.com/statuses/user_timeline/92522167.rss"]];
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

                break;
            }
            case CMS:
            {
                [viewController addSourceWithDescription:@"3D Tower" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/3DTower.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"3D RecHit" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/3DRecHit.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"Lego" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/Lego.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"RhoPhi" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/RhoPhi.png"] boundaryRects:nil];
                [viewController addSourceWithDescription:@"RhoZ" URL:[NSURL URLWithString:@"http://cmsonline.cern.ch/evtdisp/RhoZ.png"] boundaryRects:nil];

                break;
            }
            case ALICE:
            {
                
                break;
            }
            case LHCb:
            {
                [viewController addSourceWithDescription:@"Side" URL:[NSURL URLWithString:@"http://lbcomet.cern.ch/Online/Images/evdisp.jpg"] boundaryRects:nil];
                break;
            }
            default:
                break;
        }    
    }
}

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
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"ShowExperimentNews" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"ShowEventDisplay" sender:self];
            break;
    }

}

@end
