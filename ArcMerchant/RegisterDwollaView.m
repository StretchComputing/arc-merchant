//
//  RegisterDwollaView.m
//  ARC
//
//  Created by Nick Wroblewski on 6/28/12.
//  Copyright (c) 2012 Stretch Computing, Inc. All rights reserved.
//

#import "RegisterDwollaView.h"
#import "Settings.h"
#import "rSkybox.h"
#import "ArcClient.h"

@interface RegisterDwollaView ()

@end

@implementation RegisterDwollaView

-(void)viewDidLoad{
    @try {
        
        [rSkybox addEventToSession:@"viewRegisterDwollaScreen"];
        
        //CorbelTitleLabel *navLabel = [[CorbelTitleLabel alloc] initWithText:@"Dwolla Confirm"];
        //self.navigationItem.titleView = navLabel;
        
        self.title = @"Dwolla Confirm";
        
        NSArray *scopes = @[@"send", @"balance", @"accountinfofull", @"contacts", @"funding",  @"request", @"transactions"];
        DwollaOAuth2Client *client = [[DwollaOAuth2Client alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) key:@"2iFSd6ifWh5KchAPbYQ7TWylQqs+c/xkT8ji5/GwYTx2BkImr3" secret:@"83wLV7XvDAq2VuYXt0l4vB98uo7KFeivHNi+y6yeCyOttbmmeH" redirect:@"https://www.dwolla.com" response:@"code" scopes:scopes view:self.view reciever:self];
        [client login];
        
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"RegisterDwollaView.viewDidLoad" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}

-(void)successfulLogin
{
    @try {
        
        [rSkybox addEventToSession:@"successfulDwollaLogin"];
        
            Settings *tmp = [[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count] - 2 ];
            tmp.fromDwolla = YES;
            tmp.dwollaSuccess = YES;
            
            [self.navigationController popViewControllerAnimated:NO];
    
        
        //[ArcClient trackEvent:@"DWOLLA_ACTIVATED"];

    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"RegisterDwollaView.successfulLogin" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
     
    
  
}


-(void)failedLogin:(NSArray*)errors
{
    @try {
        
        [rSkybox addEventToSession:@"failedDwollaLogin"];
        
            Settings *tmp = [[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count] - 2 ];
            tmp.fromDwolla = YES;
            tmp.dwollaSuccess = NO;
            
            [self.navigationController popViewControllerAnimated:NO];
            
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"RegisterDwollaView.failedLogin" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }

    
}


@end
