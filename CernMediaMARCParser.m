//
//  CernMediaMODSParser.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/25/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "CernMediaMARCParser.h"

@implementation CernMediaMARCParser
@synthesize url, resourceTypes, delegate;

- (id)init {
    if (self = [super init]) {
        asyncData = [[NSMutableData alloc] init];
        self.url = [[NSURL alloc] init];
        self.resourceTypes = [NSArray array];
    }
    return self;
}


- (void)parse
{    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [asyncData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:asyncData];
    xmlParser.delegate = self;
    [xmlParser parse];
}

#pragma mark NSXMLParserDelegate methods 

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    asyncData = [[NSMutableData alloc] init];
    currentUValue = [NSMutableString string];
    mediaItems = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"datafield"]) {
        // Within each datafield, there is the possibility of extracting a media item url
        foundX = NO;
        foundU = NO;
        foundSubfield = NO;
        currentResourceType = @"";
        
    } else if ([elementName isEqualToString:@"subfield"]) {
        NSString *subfieldCode = [attributeDict objectForKey:@"code"];
        if ([subfieldCode isEqualToString:@"x"]) {
            foundSubfield = YES;
            currentSubfieldCode = SUBFIELD_CODE_X;
        } else if ([subfieldCode isEqualToString:@"u"]) {
            [currentUValue setString:@""];
            foundSubfield = YES;
            currentSubfieldCode = SUBFIELD_CODE_U;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (foundSubfield == YES) {
        if (currentSubfieldCode == SUBFIELD_CODE_X) {
            // if the subfield has code="x", it will contain a resource type descriptor
            int numResourceTypes = self.resourceTypes.count;
            for (int i=0; i<numResourceTypes; i++) {
                if ([string isEqualToString:[self.resourceTypes objectAtIndex:i]]) {
                    currentResourceType = string;
                    foundX = YES;
                    break;
                }
            }
          /*  if ([string isEqualToString:@"jpgA4"]) {
                // found a large image url
                currentImageSize = IMAGE_SIZE_LARGE;
                foundX = YES;
            } else if ([string isEqualToString:@"jpgA5"]) {
                // found a medium image url
                currentImageSize = IMAGE_SIZE_MEDIUM;
                foundX = YES;
            } else if ([string isEqualToString:@"jpgIcon"]) {
                // found an icon url
                currentImageSize = IMAGE_SIZE_ICON;
                foundX = YES;
            }*/
        } else if (currentSubfieldCode == SUBFIELD_CODE_U) {
            // if the subfield has code="u", it will contain a url to the resource
            [currentUValue appendString:string];
            foundU = YES;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"datafield"]) {
        if (foundX && foundU) {
            if (!currentMediaItem) {
                currentMediaItem = [NSMutableDictionary dictionary];
            }
            NSURL *resourceURL = [NSURL URLWithString:[currentUValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                            
            [currentMediaItem setObject:resourceURL forKey:currentResourceType];
            /*switch (currentImageSize) {
                case IMAGE_SIZE_ICON:
                    currentMediaItem.iconURL = imageURL;
                    break;
                case IMAGE_SIZE_MEDIUM:
                    currentMediaItem.mediumURL = imageURL;
                    break;
                case IMAGE_SIZE_LARGE:
                    currentMediaItem.largeURL = imageURL;
                    break;
                default:
                    break;
            }*/
            
            if ([currentMediaItem allKeys].count == self.resourceTypes.count) {
            /*if (currentMediaItem.iconURL && 
                currentMediaItem.mediumURL && 
                currentMediaItem.largeURL) {*/
                // Media item is complete. Add it to the array, and reset currentMediaItem.
                [mediaItems addObject:currentMediaItem];
                currentMediaItem = nil;
            }
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (delegate)
        [delegate parser:self didParseMediaItems:mediaItems];
}

@end

