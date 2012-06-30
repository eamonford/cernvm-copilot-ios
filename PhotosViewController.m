//
//  PhotosViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/27/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "PhotosViewController.h"
#import "CernMediaMARCParser.h"
#import "PhotoGridViewCell.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController
@synthesize photoURLs;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        /*thumbnailConnctions = [NSMutableArray array];
        thumbnails = [NSMutableArray array];*/
        self.photoURLs = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.backgroundColor = [UIColor whiteColor];
    self.gridView.resizesCellWidthToFit = YES;
    self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
   // self.gridView.separatorColor = [UIColor whiteColor];
    CernMediaMARCParser *marcParser = [[CernMediaMARCParser alloc] init];
    marcParser.url = [NSURL URLWithString:@"http://cdsweb.cern.ch/search?ln=en&cc=Press+Office+Photo+Selection&p=&f=&action_search=Search&c=Press+Office+Photo+Selection&c=&sf=&so=d&rm=&rg=10&sc=1&of=xm"];
    marcParser.resourceTypes = [NSArray arrayWithObjects:@"jpgA4", @"jpgA5", @"jpgIcon", nil];
    marcParser.delegate = self;
    [marcParser parse];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)parser:(CernMediaMARCParser *)parser didParseMediaItems:(NSArray *)mediaItems
{
    self.photoURLs = [mediaItems mutableCopy];
    [self.gridView reloadData];
    //[self loadThumbnails];
}

/*- (void)loadThumbnails
{
    int numPhotos = self.photoURLs.count;
    for (int i=0; i<numPhotos; i++) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[[self.photoURLs objectAtIndex:i] objectForKey:@"jpgIcon"]];
        NSMutableData *data = [[NSMutableData alloc] init];
        
        [thumbnails addObject:data];
        [thumbnailConnctions addObject:[NSURLConnection connectionWithRequest:request delegate:self]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    int thumbnailIndex = [thumbnailConnctions indexOfObject:connection];
    if (thumbnailIndex != NSNotFound) {
        [[thumbnails objectAtIndex:thumbnailIndex] appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    int thumbnailIndex = [thumbnailConnctions indexOfObject:connection];
    if (thumbnailIndex != NSNotFound) {
        UIImage *thumbnailImage = [UIImage imageWithData:[thumbnails objectAtIndex:thumbnailIndex]];
        [thumbnails replaceObjectAtIndex:thumbnailIndex withObject:thumbnailImage];
        
        [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:thumbnailIndex] withAnimation:AQGridViewItemAnimationTop];
    }
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.photoURLs.count;
}
- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *CellIdentifier = @"photoCell";
    PhotoGridViewCell *cell = (PhotoGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PhotoGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0) reuseIdentifier:CellIdentifier];
        //id thumbnail = [thumbnails objectAtIndex:index];
        // thumbnail with be NSData if it has not finished downloading, or a UIImage if it has finished donwloading
        //if ([thumbnail class] == [UIImage class]) {
        //    cell.image = thumbnail;
        [cell setImageFromURL:[[self.photoURLs objectAtIndex:index] objectForKey:@"jpgIcon"]];
    }
    return cell;
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    NSLog(@"you touched thumbnail %d", index);
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(50.0, 50.0);

}

@end
