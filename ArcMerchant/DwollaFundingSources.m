//
//  DwollaFundingSources.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 Stretch Computing, Inc. All rights reserved.
//

#import "DwollaFundingSources.h"
#import "rSkybox.h"


@implementation DwollaFundingSources

-(id)initWithSuccess:(BOOL)_success 
            sources:(NSMutableArray*)_sources
{
    if (self) 
    {
        success = _success;
        sources = _sources;
    }
    return self;
}

-(BOOL)getSuccess
{
    return success;
}

-(NSMutableArray*)getAll
{
    return sources;
}

-(NSMutableArray*)getAlphabetized:(NSString *)direction
{
    @try {
        if ([direction isEqualToString:@"DESC"])
        {
            [sources sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                DwollaFundingSource* one = (DwollaFundingSource*) obj1;
                DwollaFundingSource* two = (DwollaFundingSource*) obj2;
                
                return [[one getName] compare:[two getName]];
            }];
        }
        else
        {
            [sources sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                DwollaFundingSource* one = (DwollaFundingSource*) obj1;
                DwollaFundingSource* two = (DwollaFundingSource*) obj2;
                
                return -1*[[one getName] compare:[two getName]];
            }];     
        }
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaFundingSources.merchantListComplete" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
    return sources;
}

-(int)count
{
    return [sources count];
}

-(DwollaFundingSource*)getObjectAtIndex:(int)index
{
    return [sources objectAtIndex:index];
}


@end
