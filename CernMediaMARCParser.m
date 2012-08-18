//
//  CernMediaMODSParser.m
//  CernVM Co-Pilot
//
//  Created by Eamon Ford on 6/25/12.
//  Copyright (c) 2012 The Byte Factory. All rights reserved.
//

#import "CernMediaMARCParser.h"
#import "NSDateFormatter+DateFromStringOfUnknownFormat.h"

@implementation CernMediaMARCParser
//@synthesize url, resourceTypes, delegate, isFinishedParsing;

- (id)init {
    if (self = [super init]) {
        asyncData = [[NSMutableData alloc] init];
        self.url = [[NSURL alloc] init];
        self.resourceTypes = [NSMutableArray array];
    }
    return self;
}


- (void)parse
{
    self.isFinishedParsing = NO;
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(parser:didFailWithError:)])
        [self.delegate parser:self didFailWithError:error];
}

#pragma mark NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    asyncData = [[NSMutableData alloc] init];
    currentUValue = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"record"]) {
        currentRecord = [NSMutableDictionary dictionary];
        [currentRecord setObject:[NSMutableDictionary dictionary] forKey:@"resources"];
    } else if ([elementName isEqualToString:@"datafield"]) {
        currentDatafieldTag = [attributeDict objectForKey:@"tag"];
        foundX = NO;
        foundU = NO;
        foundSubfield = NO;
        currentResourceType = @"";
        
    } else if ([elementName isEqualToString:@"subfield"]) {
        currentSubfieldCode = [attributeDict objectForKey:@"code"];
        if ([currentDatafieldTag isEqualToString:@"856"]) {
            if ([currentSubfieldCode isEqualToString:@"x"]) {
                foundSubfield = YES;
                //currentSubfieldCode = SUBFIELD_CODE_X;
            } else if ([currentSubfieldCode isEqualToString:@"u"]) {
                [currentUValue setString:@""];
                foundSubfield = YES;
                //currentSubfieldCode = SUBFIELD_CODE_U;
            }
        } else if ([currentDatafieldTag isEqualToString:@"245"]) {
            if ([currentSubfieldCode isEqualToString:@"a"]) {
                foundSubfield = YES;
            }
        } else if ([currentDatafieldTag isEqualToString:@"269"]) {
            if ([currentSubfieldCode isEqualToString:@"c"]) {
                foundSubfield = YES;
            }
        }
    }
}

// If we've found a resource type descriptor or a URL, we will have to hold it temporarily until
// we have exited the datafield, before we can assign it to the current record. If we've found
// the title however, we can assign it to the record immediately.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *stringWithoutWhitespace = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![stringWithoutWhitespace isEqualToString:@""]) {
        if (foundSubfield == YES) {
            if ([currentSubfieldCode isEqualToString:@"x"]) {
                // if the subfield has code="x", it will contain a resource type descriptor
                int numResourceTypes = self.resourceTypes.count;
                if (numResourceTypes) {
                    for (int i=0; i<numResourceTypes; i++) {
                        if ([string isEqualToString:[self.resourceTypes objectAtIndex:i]]) {
                            currentResourceType = string;
                            foundX = YES;
                            break;
                        }
                    }
                } else {
                    currentResourceType = string;
                    foundX = YES;
                }
            } else if ([currentSubfieldCode isEqualToString:@"u"]) {
                // if the subfield has code="u", it will contain a url to the resource
                [currentUValue appendString:string];
                foundU = YES;
            } else if ([currentSubfieldCode isEqualToString:@"a"]) {
                [currentRecord setObject:string forKey:@"title"];
            } else if ([currentSubfieldCode isEqualToString:@"c"]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                NSDate * date = [formatter dateFromStringOfUnknownFormat:string];
                if (date)
                    [currentRecord setObject:date forKey:@"date"];
               // else 
               //     [currentRecord setObject:string forKey:@"date"];
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"datafield"]) {
        if (foundX && foundU) {
             // if there isn't already an array of URLs for the current x value in the current record, create one
            NSMutableDictionary *resources = [currentRecord objectForKey:@"resources"];
            if (![resources objectForKey:currentResourceType]) {
                [resources setObject:[NSMutableArray array] forKey:currentResourceType];
            }
            
            NSURL *resourceURL = [NSURL URLWithString:[currentUValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            NSMutableArray *urls = [resources objectForKey:currentResourceType];
            // add the url we found into the appropriate url array
            [urls addObject:resourceURL];
        }
    } else if ([elementName isEqualToString:@"record"]) {
        if (((NSMutableDictionary *)[currentRecord objectForKey:@"resources"]).count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(parser:didParseRecord:)]) {
                [self.delegate parser:self didParseRecord:currentRecord];
            }
        }
        currentRecord = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.isFinishedParsing = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(parserDidFinish:)])
        [self.delegate parserDidFinish:self];
}

@end

