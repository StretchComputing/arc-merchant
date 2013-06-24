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
#import "ArcClient.h"

@interface Settings ()
@end

@implementation Settings

-(void)viewWillAppear:(BOOL)animated{
    @try {
        
        self.navigationController.navigationBar.tintColor = dutchTopNavColor;
        
        ArcClient *tmp = [[ArcClient alloc] init];
        if (![tmp admin]) {
            self.changeServerButton.hidden = YES;
        }else{
            self.changeServerButton.hidden = NO;
        }
        
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
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"Settings.viewWillAppear" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}

- (void)viewDidLoad
{
    @try {
        
        self.title = @"";
        self.changeServerButton.text = @"View/Change Server";
        [super viewDidLoad];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.text = @"Settings";
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel; 
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21.0/255.0 green:80.0/255.0  blue:125.0/255.0 alpha:1.0];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        backView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        
        self.tableView.backgroundView = backView;
        [rSkybox addEventToSession:@"viewSettings"];
        
        
        
        NVUIGradientButton *myButton = [[NVUIGradientButton alloc] initWithFrame:CGRectMake(0, 4, 75, 36)];
        myButton.text = @"Home";
        [myButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
        
        self.navigationItem.leftBarButtonItem = homeButton;
        
        
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"Settings.viewDidLoad" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        
        if (indexPath.section == 1) {
            AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
            mainDelegate.logout = @"true";
            [self.navigationController dismissModalViewControllerAnimated:NO];
            [rSkybox addEventToSession:@"logOut"];
        }
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"Settings.tableView" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

-(void)goBack{
    [self.navigationController dismissModalViewControllerAnimated:YES];

}
- (IBAction)cancelAction:(id)sender {
    @try {
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"Settings.cancelAction" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

- (IBAction)changeServerAction {
    
    [self performSegueWithIdentifier:@"goServer" sender:self];
}


- (IBAction)dwollaAuthSwitchSelected {
    @try {
        
        if (self.dwollaAuthSwitch.on) {
            
            [self performSegueWithIdentifier:@"confirmDwolla" sender:self];
            [rSkybox addEventToSession:@"requestDwollaActivation"];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove Dwolla?"  message:@"Are you sure you want to delete your Dwolla info from ARC?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [alert show];
            
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"Settings.dwollaAuthSwitchSelected" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [DwollaAPI clearAccessToken];
        //[ArcClient trackEvent:@"DWOLLA_DEACTIVATED"];
    }else{
        self.dwollaAuthSwitch.on = YES;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @try {
        
        if ([[segue identifier] isEqualToString:@"confirmDwolla"]) {
            
            RegisterDwollaView *detailViewController = [segue destinationViewController];
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"Settings.prepareForSegue" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}



@end
