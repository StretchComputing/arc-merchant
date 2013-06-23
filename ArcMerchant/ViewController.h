//
//  ViewController.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/9/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"
@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) UITextField *username;
@property (nonatomic, strong) UITextField *password;

@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableData *serverData;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *passCode;
@property BOOL autoSignIn;
-(IBAction)signIn;
@property (strong, nonatomic) IBOutlet NVUIGradientButton *signInButton;


@end
