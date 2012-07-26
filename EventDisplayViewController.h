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
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIBarButtonItem *refreshButton;
    
    NSMutableArray *sources;
    NSMutableArray *downloadedResults;
    int numPages;
}

@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSMutableArray *sources;
@property (nonatomic, retain) NSMutableArray *downloadedResults;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIBarButtonItem *refreshButton;

// This method should be called immediately after init, and before viewDidLoad gets called.
- (void)addSourceWithDescription:(NSString *)description URL:(NSURL *)url boundaryRects:(NSArray *)boundaryRects;
- (IBAction)refresh:(id)sender;
- (void)synchronouslyDownloadImageForSource:(NSDictionary *)source;

- (void)addDisplay:(NSDictionary *)eventDisplayInfo toPage:(int)page;
- (void)addSpinnerToPage:(int)page;

@end
