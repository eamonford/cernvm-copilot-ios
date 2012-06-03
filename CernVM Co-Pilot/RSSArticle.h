//
//  RSSArticle.h
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 5/28/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSArticle : NSObject
{
    NSString *__weak title;
    NSString *__weak description;
    NSURL *__weak url;   
}
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *description;
@property (weak, nonatomic) NSURL *url;

@end
