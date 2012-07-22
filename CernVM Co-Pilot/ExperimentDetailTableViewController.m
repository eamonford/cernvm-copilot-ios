//
//  ExperimentDetailTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/20/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "ExperimentDetailTableViewController.h"
#import "NewsTableViewController.h"

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
            break;
    }

}

@end
