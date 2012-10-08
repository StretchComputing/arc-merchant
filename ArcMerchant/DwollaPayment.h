//
//  DwollaPayment.h
//  ARC
//
//  Created by Nick Wroblewski on 6/27/12.
//  Copyright (c) 2012 Stretch Computing, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DwollaAPI.h"


@interface DwollaPayment : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property double refundAmount;
@property (nonatomic, strong) NSDictionary *refundAccountDictionary;
@property (weak, nonatomic) IBOutlet UILabel *refundToLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundAmountLabel;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *payButton;
@property int invoiceId;
@property double totalAmount;
@property double gratuity;

@property BOOL fromDwolla;
@property BOOL dwollaSuccess;

@property BOOL waitingSources;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (nonatomic, strong) NSMutableData *serverData;
@property (weak, nonatomic) IBOutlet UITextField *checkNumFour;
@property (weak, nonatomic) IBOutlet UITextField *checkNumThree;
@property (weak, nonatomic) IBOutlet UITextField *checkNumTwo;

@property (weak, nonatomic) IBOutlet UITextField *checkNumOne;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *notesText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) NSMutableArray *fundingSources;
@property (strong, nonatomic) NSString *fundingSourceStatus;
@property (nonatomic, strong) NSString *selectedFundingSourceId;

@property (nonatomic, strong) UITextField *hiddenText;


@end
