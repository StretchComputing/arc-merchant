//
//  ResetPasswordViewController.h
//  ARC
//
//  Created by Nick Wroblewski on 10/15/12.
//
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITextField *passcodeText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *confirmText;
@property (weak, nonatomic) NSString *passcodeString;
@property (weak, nonatomic) NSString *emailString;

- (IBAction)submitAction;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)cancelAction:(id)sender;



@property (nonatomic, strong) NSString *emailAddress;

@end
