//
//  ArcUtility.m
//  ArcMerchant
//
//  Created by Nick Wroblewski on 10/28/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import "ArcUtility.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "rSkybox.h"
#import "ArcClient.h"

@implementation ArcUtility

-(void)updatePushToken{
    
    @try {
        [rSkybox addEventToSession:@"updatePushToken"];
        
        NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
        
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [pairs setValue:mainDelegate.pushToken forKey:@"DeviceId"];
        
        NSString *requestString = [NSString stringWithFormat:@"%@", [pairs JSONRepresentation], nil];
        NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
        
        ArcClient *tmp = [[ArcClient alloc] init];
        NSString *arcUrl = [tmp getCurrentUrl];
        

        
        NSString *merchantId = [[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"];
        merchantId = @"current";
        
        NSString *createReviewUrl = [NSString stringWithFormat:@"%@merchants/update/%@", arcUrl, merchantId, nil];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:createReviewUrl]];
        [request setHTTPMethod: @"POST"];
        
        [request setHTTPBody: requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[tmp authHeader] forHTTPHeaderField:@"Authorization"];
        
        NSString *authHeader = [tmp authHeader];
        
        self.serverData = [NSMutableData data];
        [rSkybox startThreshold:@"updatePushToken"];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately: YES];
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"ArcClient.createReview" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"HTTP Status Code: %d", statusCode);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    @try {
        

        
        NSData *returnData = [NSData dataWithData:self.serverData];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"ReturnString: %@", returnString);
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary *response = (NSDictionary *) [jsonParser objectWithString:returnString error:NULL];
        
       
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"ArcClient.connectionDidFinishLoading" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}



@end
