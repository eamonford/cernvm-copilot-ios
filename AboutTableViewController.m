//
//  AboutTableViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/18/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AboutTableViewController.h"
#import "StaticInfoViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController
@synthesize currentElement;

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
    if (!self.currentElement) {
        // We need to load the static information plist file.
        NSString *path = [[NSBundle mainBundle] pathForResource:@"StaticInformation" ofType:@"plist"];
        self.currentElement = [NSDictionary dictionaryWithContentsOfFile:path];
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
    if ([self.currentElement isKindOfClass:[NSDictionary class]])
        return ((NSDictionary *)self.currentElement).allKeys.count;
    else if ([self.currentElement isKindOfClass:[NSArray class]])
        return ((NSArray *)self.currentElement).count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *title;
    if ([self.currentElement isKindOfClass:[NSDictionary class]]) {
        title = [((NSDictionary *)self.currentElement).allKeys objectAtIndex:indexPath.row];
    } else if ([self.currentElement isKindOfClass:[NSArray class]]) {
        NSDictionary *staticInfo = [((NSArray *)self.currentElement) objectAtIndex:indexPath.row];
        title = [staticInfo objectForKey:@"Title"];
    }
    
    cell.textLabel.text = title;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowStaticInfo"]) {
        // We need to initialize the detail view controller with the proper static information.
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        NSDictionary *staticInformation = [(NSArray *)self.currentElement objectAtIndex:selectedRow];
        StaticInfoViewController *detailViewController = segue.destinationViewController;
        detailViewController.staticInfo = staticInformation;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.currentElement isKindOfClass:[NSDictionary class]]) {
        // If the current element is a dictionary, there is still another level in the hierarchy before we get to the static info. So we will push another copy of the same view controller to show the next level in the hierarchy.
        NSObject *nextLevel = [((NSDictionary *)self.currentElement).allValues objectAtIndex:indexPath.row];
        AboutTableViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutTableViewController"];
        viewController.currentElement = nextLevel;
        [self.navigationController pushViewController:viewController animated:YES];

    } else if ([self.currentElement isKindOfClass:[NSArray class]]) {
        // If the current element is an array, then we have reached the end of the hierarchy. We will thus push a detail view controller.
        [self performSegueWithIdentifier:@"ShowStaticInfo" sender:self];
    }
}

@end
