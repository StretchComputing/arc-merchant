//
//  ViewController.m
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/9/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ArcClient.h"
#import "DwollaAPI.h"
#import "rSkybox.h"
#import "ResetPasswordViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    @try {
        
        self.password.text = @"";
        
        [self.myTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];
        self.errorLabel.text = @"";
        [self.username becomeFirstResponder];
        
        AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
        if ([mainDelegate.logout isEqualToString:@"true"]) {
            
            mainDelegate.logout = @"false";
            self.username.text = @"";
            self.password.text = @"";
            [DwollaAPI clearAccessToken];
        }
        
                
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"ViewController.viewWillAppear" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        
    }
    
}


-(void)selectPassword{
    [self.password becomeFirstResponder];
}

- (void)viewDidLoad
{
    @try {
        
        self.signInButton.text = @"Sign In";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInComplete:) name:@"signInNotification" object:nil];
        
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        
        self.username = [[UITextField alloc] initWithFrame:CGRectMake(95, 8, 205, 20)];
        self.username.autocorrectionType = UITextAutocorrectionTypeNo;
        self.username.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.username.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.username.returnKeyType = UIReturnKeyNext;
        self.username.keyboardType = UIKeyboardTypeEmailAddress;
        [self.username addTarget:self action:@selector(selectPassword) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(95, 8, 205, 20)];
        self.password.autocorrectionType = UITextAutocorrectionTypeNo;
        self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.password.secureTextEntry = YES;
        self.password.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.password.returnKeyType = UIReturnKeyGo;
        [self.password addTarget:self action:@selector(signIn) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        self.username.text = @"";
        self.password.text = @"";
        
        self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21.0/255.0 green:80.0/255.0  blue:125.0/255.0 alpha:1.0];

        self.navBar.tintColor = [UIColor colorWithRed:21.0/255.0 green:80.0/255.0  blue:125.0/255.0 alpha:1.0];
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.topLineView.backgroundColor = dutchTopLineColor;
        self.backView.backgroundColor = dutchTopNavColor;
        
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"ViewController.viewDidLoad" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        
    }
    
}

-(void)signIn{
    
    [self performSelector:@selector(runSignIn)];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
    if (section == 0) {
        return 2;
    }
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    @try {
        static NSString *FirstLevelCell=@"FirstLevelCell";
        
        static NSInteger fieldTag = 1;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier: FirstLevelCell];
            
            CGRect frame;
            frame.origin.x = 10;
            frame.origin.y = 6;
            frame.size.height = 22;
            frame.size.width = 80;
            
            UILabel *fieldLabel = [[UILabel alloc] initWithFrame:frame];
            fieldLabel.tag = fieldTag;
            [cell.contentView addSubview:fieldLabel];
            
            
        }
        
        UILabel *fieldLabel = (UILabel *)[cell.contentView viewWithTag:fieldTag];
        
        fieldLabel.textColor = [UIColor blackColor];
        fieldLabel.backgroundColor = [UIColor clearColor];
        NSUInteger row = [indexPath row];
        NSUInteger section = [indexPath section];
        
        if (section == 0) {
            
            fieldLabel.frame = CGRectMake(10, 6, 80, 22);
            fieldLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            fieldLabel.textAlignment = UITextAlignmentLeft;
            
            if (row == 0) {
                fieldLabel.text = @"Email";
                
                [cell.contentView addSubview:self.username];
                
                cell.isAccessibilityElement = YES;
                cell.accessibilityLabel = @"user name";
            }else if (row == 1){
                fieldLabel.text = @"Password";
                [cell.contentView addSubview:self.password];
                
                cell.isAccessibilityElement = YES;
                cell.accessibilityLabel = @"pass word";
            }
            
            [self.username becomeFirstResponder];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else{
            
            fieldLabel.frame = CGRectMake(0, 6, 298, 22);
            fieldLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            fieldLabel.textAlignment = UITextAlignmentCenter;
            
            fieldLabel.text = @"How ARC Merchant Works";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"ViewController.tableView" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        
    }
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(void)runSignIn{
    
    self.errorLabel.text = @"";
    
    if ([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        self.errorLabel.text = @"*Please enter your email and password.";
    }else{
        @try {
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
            NSDictionary *loginDict = [[NSDictionary alloc] init];
            [ tempDictionary setObject:self.username.text forKey:@"userName"];
            [ tempDictionary setObject:self.password.text forKey:@"password"];
            
            [self.activity startAnimating];
            
            loginDict = tempDictionary;
            ArcClient *client = [[ArcClient alloc] init];
            [client getCustomerToken:loginDict];
        }
        @catch (NSException *e) {
            [rSkybox sendClientLog:@"viewController.runSignIn" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        }
    }
}


-(void)signInComplete:(NSNotification *)notification{
    @try {
        [rSkybox addEventToSession:@"signInComplete"];
        
        NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];
        
        //NSLog(@"Response Info: %@", responseInfo);
        
        NSString *status = [responseInfo valueForKey:@"status"];
        
        [self.activity stopAnimating];
        if ([status isEqualToString:@"success"]) {
            //success
            
            ArcClient *tmp = [[ArcClient alloc] init];
            [tmp updatePushToken];
            
            int resetPassword = [[[responseInfo valueForKey:@"Results"] valueForKey:@"ResetPassword"] intValue];
            
            if (resetPassword == 0) {
                [[NSUserDefaults standardUserDefaults] setValue:self.username.text forKey:@"customerEmail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                ArcClient *client = [[ArcClient alloc] init];
                [client sendPushToken];
                
                [self performSegueWithIdentifier:@"goHome" sender: self];
                //Do the next thing (go home?)
            }else{
                self.passCode =  [[responseInfo valueForKey:@"Results"] valueForKey:@"PassCode"];
                [self performSegueWithIdentifier:@"resetPassword" sender:self];
            
            }
         
        } else {
            self.errorLabel.text = @"*Invalid credentials, please try again.";
        }
    }
    @catch (NSException *e) {
       [rSkybox sendClientLog:@"ViewController.signInComplete" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @try {
        
        if ([[segue identifier] isEqualToString:@"resetPassword"]) {
            
            UINavigationController *nav = [segue destinationViewController];
            ResetPasswordViewController *next = [[nav viewControllers] objectAtIndex:0];
            next.passcodeString = self.passCode;
            next.emailAddress = self.username.text;
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.prepareForSegue" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath section] == 1) {
        //Go to "How it works"
        [self performSegueWithIdentifier:@"howItWorks" sender:self];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 20;
    }
    return 0;
}


- (void)viewDidUnload {
    [self setBackView:nil];
    [self setTopLineView:nil];
    [self setSignInButton:nil];
    [super viewDidUnload];
}
@end
