//
//  AboutTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/18/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AboutTableViewController.h"
#import "StaticInfoViewController.h"
#import "PageContainingViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController
@synthesize tableDataSource, currentTitle, currentLevel;

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
    if (self.currentLevel == 0) {
        // We need to load the static information from the plist file.
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"StaticInformation" ofType:@"plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
        self.tableDataSource = [plistDict objectForKey:@"Root"];
        self.navigationItem.title = @"About CERN";
    } else {
        self.navigationItem.title = self.currentTitle;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *item = [self.tableDataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"Title"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowStaticInfo"]) {
        // We need to initialize the detail view controller with the proper static information.
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        NSDictionary *staticInfo = [self.tableDataSource objectAtIndex:selectedRow];
        
        StaticInfoViewController *detailViewController = segue.destinationViewController;
        detailViewController.staticInfo = staticInfo;
    }
    if ([segue.identifier isEqualToString:@"ShowPageView"]) {
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        NSArray *staticInfoRecords = [[self.tableDataSource objectAtIndex:selectedRow] objectForKey:@"Items"];
        PageContainingViewController *viewController = segue.destinationViewController;
        viewController.dataSource = staticInfoRecords;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.tableDataSource objectAtIndex:indexPath.row];
    NSArray *children = [item objectForKey:@"Items"];
    
    // If its children have children...
    if (children && [[children objectAtIndex:0] objectForKey:@"Items"]) {
        AboutTableViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutTableViewController"];
        viewController.tableDataSource = children;
        viewController.currentTitle = [item objectForKey:@"Title"];
        viewController.currentLevel = self.currentLevel+1;
        
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        // Push the detail view
        //[self performSegueWithIdentifier:@"ShowStaticInfo" sender:self];
        [self performSegueWithIdentifier:@"ShowPageView" sender:self];
    }
}

@end
