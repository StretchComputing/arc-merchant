//
//  Settings.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/29/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"

@interface Settings : UITableViewController
- (IBAction)cancelAction:(id)sender;
- (IBAction)changeServerAction;

@property (weak, nonatomic) IBOutlet NVUIGradientButton *changeServerButton;
@property (weak, nonatomic) IBOutlet UISwitch *dwollaAuthSwitch;
- (IBAction)dwollaAuthSwitchSelected;
@property BOOL fromDwolla;
@property BOOL dwollaSuccess;
@end
