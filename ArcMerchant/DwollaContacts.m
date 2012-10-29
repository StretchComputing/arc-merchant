//
//  DwollaContacts.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 Stretch Computing, Inc. All rights reserved.
//

#import "DwollaContacts.h"
#import "rSkybox.h"

@implementation DwollaContacts

-(id)initWithSuccess:(BOOL)_success 
            contacts:(NSMutableArray*)_contacts
{
    @try {
        
        if (self)
        {
            success = _success;
            contacts = _contacts;
        }
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaContacts.initWithSuccess" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    return self;
}

-(BOOL)getSuccess
{
    return success;
}

-(NSMutableArray*)getAll
{
    return contacts;
}

-(NSMutableArray*)getAlphabetized:(NSString *)direction
{
    @try {
        
        if ([direction isEqualToString:@"DESC"])
        {
            [contacts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                DwollaContact* one = (DwollaContact*) obj1;
                DwollaContact* two = (DwollaContact*) obj2;
                
                return [[one getName] compare:[two getName]];
            }];
        }
        else
        {
            [contacts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                DwollaContact* one = (DwollaContact*) obj1;
                DwollaContact* two = (DwollaContact*) obj2;
                
                return -1*[[one getName] compare:[two getName]];
            }];     
        }
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaContacts.getAlphabetized" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    return contacts;
}

-(int)count
{
    return [contacts count];
}

-(DwollaContact*)getObjectAtIndex:(int)index
{
    return [contacts objectAtIndex:index];
}


@end
