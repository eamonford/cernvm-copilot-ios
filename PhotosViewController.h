//
//  PhotosViewController.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/27/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "AQGridViewController.h"
#import "AQGridView.h"
#import "AQGridViewCell.h"
#import "CernMediaMARCParser.h"
#import "MWPhotoBrowser.h"
#import "PhotoDownloader.h"

@interface PhotosViewController : AQGridViewController<AQGridViewDataSource, AQGridViewDelegate, MWPhotoBrowserDelegate, PhotoDownloaderDelegate>
{
    UIView *loadingView;
}

- (IBAction)close:(id)sender;

@end
