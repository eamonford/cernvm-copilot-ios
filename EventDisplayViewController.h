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
    UILabel *titleLabel;
    UILabel *dateLabel;
    
    NSMutableArray *sources;
    NSMutableArray *downloadedResults;
    int numPages;
    int currentPage;
}

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *sources;
@property (nonatomic, strong) NSMutableArray *downloadedResults;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;

// This method should be called immediately after init, and before viewDidLoad gets called.
- (void)addSourceWithDescription:(NSString *)description URL:(NSURL *)url boundaryRects:(NSArray *)boundaryRects;
- (IBAction)refresh:(id)sender;
- (void)synchronouslyDownloadImageForSource:(NSDictionary *)source;

- (void)addDisplay:(NSDictionary *)eventDisplayInfo toPage:(int)page;
- (void)addSpinnerToPage:(int)page;

@end
