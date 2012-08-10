//
//  VideosGridViewController.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 8/9/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "VideosGridViewController.h"
#import "Constants.h"

@interface VideosGridViewController ()

@end

@implementation VideosGridViewController
@synthesize videoMetadata, videoThumbnails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - CernMediaMARCParserDeleate methods

- (void)parserDidFinish:(CernMediaMARCParser *)parser
{
    [self hideLoadingView];
    [self.gridView reloadData];
}

- (void)parser:(CernMediaMARCParser *)parser didParseRecord:(NSDictionary *)record
{
    // Copy over just the title, the date, and the first url of each resource type
    NSMutableDictionary *video = [NSMutableDictionary dictionary];
    [video setObject:[record objectForKey:@"title"] forKey:kVideoMetadataPropertyTitle];
    NSDate *date = [record objectForKey:@"date"];
    if (date)
        [video setObject:date forKey:kVideoMetadataPropertyDate];
    
    NSDictionary *resources = [record objectForKey:@"resources"];
    NSArray *resourceTypes = [resources allKeys];
    for (NSString *currentResourceType in resourceTypes) {
        NSURL *url = [[resources objectForKey:currentResourceType] objectAtIndex:0];
        [video setObject:url forKey:currentResourceType];
    }
    [self.videoMetadata addObject:video];
    // now download the thumbnail for that photo
    int index = self.videoMetadata.count-1;
    [self performSelectorInBackground:@selector(downloadThumbnailForIndex:) withObject:[NSNumber numberWithInt:index]];
}

// We will use a synchronous connection running in a background thread to download thumbnails
// because it is much simpler than handling an arbitrary number of asynchronous connections concurrently.
- (void)downloadThumbnailForIndex:(id)indexNumber
{
    // now download the thumbnail for that photo
    int index = ((NSNumber *)indexNumber).intValue;
    NSDictionary *video = [self.videoMetadata objectAtIndex:index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[video objectForKey:kVideoMetadataPropertyThumbnailURL]];
    NSData *thumbnailData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *thumbnailImage = [UIImage imageWithData:thumbnailData];
    [self.videoThumbnails setObject:thumbnailImage forKey:[NSNumber numberWithInt:index]];
    [self performSelectorOnMainThread:@selector(reloadRowAtIndex:) withObject:[NSNumber numberWithInt:index] waitUntilDone:NO];
}

- (void)reloadRowAtIndex:(NSNumber *)index
{
    [self.gridView reloadItemsAtIndices:[NSIndexSet indexSetWithIndex:index.intValue] withAnimation:AQGridViewItemAnimationFade];
}


#pragma mark - AQGridView methods

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    if (displaySpinner) {
        return 1;
    } else {
        if (self.rangeOfArticlesToShow.length)
            return self.rangeOfArticlesToShow.length;
        else
            return self.aggregator.allArticles.count;
    }
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    if (displaySpinner) {
        NSLog(@"display spinner");
        static NSString *loadingCellIdentifier = @"loadingCell";
        AQGridViewCell *cell = [self.gridView dequeueReusableCellWithIdentifier:loadingCellIdentifier];
        if (cell == nil) {
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell = [[AQGridViewCell alloc] initWithFrame:spinner.frame reuseIdentifier:loadingCellIdentifier];
            [spinner startAnimating];
            [cell.contentView addSubview:spinner];
            cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        }
        return cell;
        
    } else {
        MWFeedItem *article = [self.aggregator.allArticles objectAtIndex:index+self.rangeOfArticlesToShow.location];
        static NSString *newsCellIdentifier = @"newsCell";
        NewsGridViewCell *cell = (NewsGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:newsCellIdentifier];
        if (cell == nil) {
            cell = [[NewsGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 250.0) reuseIdentifier:newsCellIdentifier];
            cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = article.title;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        NSString *dateString = [dateFormatter stringFromDate:article.date];
        cell.dateLabel.text = dateString;
        
        UIImage *image = [self.aggregator firstImageForArticle:article];
        if (image) {
            cell.thumbnailImageView.image = image;
        }
        return cell;
    }
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    if (displaySpinner) {
        return [UIScreen mainScreen].bounds.size;
    } else {
        return CGSizeMake(320.0, 270.0);
    }
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index numFingersTouch:(NSUInteger)numFingers
{
    if (displaySpinner)
        return;
    [self performSegueWithIdentifier:@"ShowArticleDetails" sender:self];
}

@end
