//
//  EventDisplayViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 7/15/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDisplayViewController : UIViewController<NSURLConnectionDelegate>
{
    //IBOutlet UIImageView *imageView;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIBarButtonItem *barButtonItem;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    
    // An array of NSDictionaries each containing a user-friendly description of the display (such as "Front" or "Side"), the URL to download the image, and an image. The object that initialized this view controller should supply it with the descriptions and URLS, and then the images will be downloaded.
    NSMutableArray *sources;
    NSMutableArray *results;
        
    UIView *loadingView;
    NSMutableData *asyncData;
    int numPages;
}
//@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIBarButtonItem *barButtonItem;
@property (nonatomic, retain) NSMutableArray *sources;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

- (IBAction)close:(id)sender;
- (IBAction)segmentedControlTapped:(id)sender;

- (void)showLoadingView;
- (void)hideLoadingView;
- (IBAction)refresh:(id)sender;
- (void)synchronouslyDownloadImageForSource:(NSDictionary *)source;
- (void)addSourceWithDescription:(NSString *)description URL:(NSURL *)url boundaryRects:(NSArray *)boundaryRects;

@end
