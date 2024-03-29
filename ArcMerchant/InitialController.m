//
//  InitialController.m
//  ARC
//
//  Created by Nick Wroblewski on 8/24/12.
//
//

#import "InitialController.h"
#import "ArcClient.h"
#import "rSkybox.h"
#import <QuartzCore/QuartzCore.h>
#import "ArcClient.h"
#import "AppDelegate.h"
#import "rSkybox.h"

@interface InitialController ()

@end

@implementation InitialController


-(void)viewDidAppear:(BOOL)animated{
    
    @try {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *managerId = [prefs stringForKey:@"managerId"];
        NSString *managerToken = [prefs stringForKey:@"managerToken"];
        
        
        if (![managerId isEqualToString:@""] && (managerId != nil) && ![managerToken isEqualToString:@""] && (managerToken != nil)) {
            //[self performSegueWithIdentifier: @"signInNoAnimation" sender: self];
            //self.autoSignIn = YES;
            
            //Send the Push Token to the server
            ArcClient *client = [[ArcClient alloc] init];
            [client sendPushToken];
            
            
            UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
            [self presentModalViewController:home animated:NO];
            [rSkybox addEventToSession:@"homePageDidAppear"];
            
            ArcClient *tmp = [[ArcClient alloc] init];
            [tmp updatePushToken];
            
        }else{
            UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInPage"];
            [self presentModalViewController:home animated:NO];
            [rSkybox addEventToSession:@"passwordResetComplete"];
            [rSkybox addEventToSession:@"signInPageDidAppear"];
        }
         
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"InitialController.viewDidAppear" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        
    }
    
}
-(void)viewDidLoad{
    @try {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.bounds;
        self.view.backgroundColor = [UIColor clearColor];
        //UIColor *myColor = [UIColor colorWithRed:114.0/255.0 green:168.0/255.0 blue:192.0/255.0 alpha:1.0];
        double x = 1.0;
        UIColor *myColor = [UIColor colorWithRed:114.0*x/255.0 green:168.0*x/255.0 blue:192.0*x/255.0 alpha:1.0];
        
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[myColor CGColor], nil];
        [self.view.layer insertSublayer:gradient atIndex:0];
        
        self.mottoLabel.font = [UIFont fontWithName:@"Chalet-Tokyo" size:21];
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InitialController.viewDidLoad" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}
@end
