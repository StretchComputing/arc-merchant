//
//  Settings.m
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/29/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import "Settings.h"
#import "RegisterDwollaView.h"
#import "DwollaAPI.h"
#import "rSkybox.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface Settings ()

@end

@implementation Settings

-(void)viewWillAppear:(BOOL)animated{
    
    NSString *dwollaAuthToken = @"";
    @try {
        dwollaAuthToken = [DwollaAPI getAccessToken];
    }
    @catch (NSException *exception) {
        dwollaAuthToken = nil;
    }
    
    if ((dwollaAuthToken == nil) || [dwollaAuthToken isEqualToString:@""]) {
        self.dwollaAuthSwitch.on = NO;
    }else{
        self.dwollaAuthSwitch.on = YES;
    }
    
    if (self.fromDwolla) {
        self.fromDwolla = NO;
        
        NSString *title = @"";
        NSString *message = @"";
        if (self.dwollaSuccess) {
            
            title = @"Success!";
            message = @"Congratulations! You are now authorized for Dwolla!";
            
        }else{
            
            title = @"Authorization Error";
            message = @"You were not successfully authorized for Dwolla.  Please try again";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

     self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21.0/255.0 green:80.0/255.0  blue:125.0/255.0 alpha:1.0];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = backView.bounds;
    UIColor *myColor = [UIColor colorWithRed:114.0/255.0 green:168.0/255.0 blue:192.0/255.0 alpha:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[myColor CGColor], nil];
    [backView.layer insertSublayer:gradient atIndex:0];
    
    self.tableView.backgroundView = backView;
    

}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
        mainDelegate.logout = @"true";
        [self.navigationController dismissModalViewControllerAnimated:NO];
    }
   
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (IBAction)dwollaAuthSwitchSelected {
    @try {
        
        if (self.dwollaAuthSwitch.on) {
            
            [self performSegueWithIdentifier:@"confirmDwolla" sender:self];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove Dwolla?"  message:@"Are you sure you want to delete your Dwolla info from ARC?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [alert show];
            
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"SettingsView.dwollaAuthSwitchSelected" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @try {
        
        if ([[segue identifier] isEqualToString:@"confirmDwolla"]) {
            
            RegisterDwollaView *detailViewController = [segue destinationViewController];
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"SettingsView.prepareForSegue" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}


- (void)viewDidUnload {
    [self setDwollaAuthSwitch:nil];
    [super viewDidUnload];
}
@end
