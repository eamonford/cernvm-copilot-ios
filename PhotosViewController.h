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

@interface PhotosViewController : AQGridViewController<AQGridViewDataSource, AQGridViewDelegate, CernMediaMarcParserDelegate/*, NSURLConnectionDelegate*/>
{
    NSMutableArray *photoURLs;
    
   /* @private
    NSMutableArray *thumbnailConnctions;
    NSMutableArray *thumbnails;*/
}

@property (nonatomic, retain) NSMutableArray *photoURLs;

@end
