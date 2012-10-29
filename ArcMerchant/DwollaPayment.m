//
//  DwollaPayment.m
//  ARC
//
//  Created by Nick Wroblewski on 6/27/12.
//  Copyright (c) 2012 Stretch Computing, Inc. All rights reserved.
//

#import "DwollaPayment.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "ArcClient.h"
#import "rSkybox.h"


@interface DwollaPayment ()

@end

@implementation DwollaPayment



- (void)viewDidLoad
{
    
    @try {
        
        
        [rSkybox addEventToSession:@"viewDwollaPaymentScreen"];
        
     self.title = @"Dwolla Refund";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentComplete:) name:@"createPaymentNotification" object:nil];
        
        self.fundingSourceStatus = @"";
        self.serverData = [NSMutableData data];
        
        self.notesText.delegate = self;
        self.checkNumOne.delegate = self;
        self.checkNumTwo.delegate = self;
        self.checkNumThree.delegate = self;
        self.checkNumFour.delegate = self;
        
        self.hiddenText = [[UITextField alloc] init];
        self.hiddenText.keyboardType = UIKeyboardTypeNumberPad;
        self.hiddenText.delegate = self;
        self.hiddenText.text = @"";
        [self.view addSubview:self.hiddenText];
        
        self.checkNumOne.text = @" ";
        self.checkNumTwo.text = @" ";
        self.checkNumThree.text = @" ";
        self.checkNumFour.text = @" ";
        
        self.checkNumOne.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
        self.checkNumTwo.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
        self.checkNumThree.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
        self.checkNumFour.font = [UIFont fontWithName:@"Helvetica-Bold" size:23];
        self.notesText.text = @"Transaction Notes (*optional):";
        
        self.notesText.layer.masksToBounds = YES;
        self.notesText.layer.cornerRadius = 5.0;
        
        self.fundingSourceStatus = @"";
        
        dispatch_queue_t queue = dispatch_queue_create("dwolla.task", NULL);
        dispatch_queue_t main = dispatch_get_main_queue();
        
        /*
        dispatch_async(queue,^{
            
            @try {
                DwollaFundingSources* sources = [DwollaAPI getFundingSources];
                
                //An array of DwollaFundingSource* objects
                self.fundingSources = [NSMutableArray arrayWithArray:[sources getAll]];
                self.fundingSourceStatus = @"success";
                
                if (self.waitingSources) {
                    self.waitingSources = NO;
                    
                    dispatch_async(main,^{
                        [self submit:nil];
                    });
                }
            }
            @catch (NSException *exception) {
                self.fundingSourceStatus = @"failed";
            }
            
            
        });
         */
        
       
        
     
        dispatch_async(queue,^{
            
            NSString *balance = @"";
            @try {
                
                balance = [DwollaAPI getBalance];
                
                dispatch_async(main,^{
                    //[self.dwollaBalanceActivity stopAnimating];
                    self.dwollaBalance = [balance doubleValue];
                    self.dwollaBalanceText.text = [NSString stringWithFormat:@"$%.2f", self.dwollaBalance];
                    //[self.dwollaBalanceActivity stopAnimating];
                    
                    if (self.dwollaBalance < self.refundAmount) {
                        self.dwollaBalanceText.textColor = [UIColor redColor];
                    }else{
                        self.dwollaBalanceText.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
                    }
                });
            }
            @catch (NSException *exception) {
                //NSLog(@"Exception getting balance");
            }
        });

        
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.bounds;
        self.view.backgroundColor = [UIColor clearColor];
        UIColor *myColor = [UIColor colorWithRed:114.0/255.0 green:168.0/255.0 blue:192.0/255.0 alpha:1.0];
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[myColor CGColor], nil];
        [self.view.layer insertSublayer:gradient atIndex:0];
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.viewDidLoad" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    @try {
        
        
        self.refundToLabel.text = [NSString stringWithFormat:@"Refund To: %@", [self.refundAccountDictionary valueForKey:@"Name"]];
        self.refundAmountLabel.text = [NSString stringWithFormat:@"Refund Amount: $%.2f", self.refundAmount];
        
        [self.hiddenText becomeFirstResponder];
        self.serverData = [NSMutableData data];
        
        if (self.fromDwolla) {
            self.fromDwolla = NO;
            
            if (self.dwollaSuccess) {
                
                //Get the Funding Sources
                
                dispatch_queue_t queue = dispatch_queue_create("dwolla.task", NULL);
                dispatch_queue_t main = dispatch_get_main_queue();
                
                dispatch_async(queue,^{
                    
                    @try {
                        DwollaFundingSources* sources = [DwollaAPI getFundingSources];
                        
                        //An array of DwollaFundingSource* objects
                        self.fundingSources = [NSMutableArray arrayWithArray:[sources getAll]];
                        self.fundingSourceStatus = @"success";
                        
                        
                    }
                    @catch (NSException *exception) {
                        self.fundingSourceStatus = @"failed";
                        
                    }
                    
                    dispatch_async(main,^{
                        [self submit:nil];
                    });
                    
                    
                    
                });
                
                
            }else{
                
                [self.activity stopAnimating];
            }
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.viewWillAppear" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}


-(void)setValues:(NSString *)newString{
    
    
    if ([newString length] < 5) {
        
        @try {
            self.checkNumOne.text = [newString substringWithRange:NSMakeRange(0, 1)];
        }
        @catch (NSException *exception) {
            self.checkNumOne.text = @"";
        }
        
        @try {
            self.checkNumTwo.text = [newString substringWithRange:NSMakeRange(1, 1)];
        }
        @catch (NSException *exception) {
            self.checkNumTwo.text = @"";
        }
        
        @try {
            self.checkNumThree.text = [newString substringWithRange:NSMakeRange(2, 1)];
        }
        @catch (NSException *exception) {
            self.checkNumThree.text = @"";
        }
        
        @try {
            self.checkNumFour.text = [newString substringWithRange:NSMakeRange(3, 1)];
        }
        @catch (NSException *exception) {
            self.checkNumFour.text = @"";
        }
        
        
        
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    @try {
        
        // Any new character added is passed in as the "text" parameter
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            
            if ([self.notesText.text isEqualToString:@""]){
                self.notesText.text = @"Transaction Notes (*optional):";
            }
            
            
            [self.hiddenText becomeFirstResponder];

            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }else{
            if ([self.notesText.text length] >= 500) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Character Limit Reached" message:@"You have reached the character limit for this field." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                return FALSE;
            }
        }
        // For any other character return TRUE so that the text gets added to the view
        return TRUE;
    }
    @catch (NSException *e) {

    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // NSLog(@"NewString: %@", string);
    //NSLog(@"RangeLength: %d", range.length);
    //NSLog(@"RangeLoc: %d", range.location);
    
    NSUInteger newLength = [self.hiddenText.text length] + [string length] - range.length;
    
    @try {
        
        
        if (newLength > 4) {
            return FALSE;
        }else{
            
            [self setValues:[self.hiddenText.text stringByReplacingCharactersInRange:range withString:string]];
            return TRUE;
            
        }
        /*
         if ([textField.text isEqualToString:@" "]) {
         
         if ([string isEqualToString:@""]) {
         
         [self performSelector:@selector(previousField) withObject:nil afterDelay:0.0];
         
         }else{
         textField.text = string;
         [self performSelector:@selector(nextField) withObject:nil afterDelay:0.0];
         }
         }else{
         
         if ([string isEqualToString:@""]) {
         textField.text = @" ";
         }
         }
         
         return FALSE;
         */
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.textField" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}


-(void)previousField{
    @try {
        
        if ([self.checkNumFour isFirstResponder]) {
            [self.checkNumThree becomeFirstResponder];
            self.checkNumThree.text = @" ";
        }else if ([self.checkNumThree isFirstResponder]){
            [self.checkNumTwo becomeFirstResponder];
            self.checkNumTwo.text = @" ";
            
        }else if ([self.checkNumTwo isFirstResponder]){
            [self.checkNumOne becomeFirstResponder];
            self.checkNumOne.text = @" ";
            
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.previousField" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}

-(void)nextField{
    @try {
        
        if ([self.checkNumOne isFirstResponder]) {
            [self.checkNumTwo becomeFirstResponder];
        }else if ([self.checkNumTwo isFirstResponder]){
            [self.checkNumThree becomeFirstResponder];
        }else if ([self.checkNumThree isFirstResponder]){
            [self.checkNumFour becomeFirstResponder];
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.nextField" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    @try {
        
        if ([self.notesText.text isEqualToString:@"Transaction Notes (*optional):"]){
            self.notesText.text = @"";
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.textViewDidBeginEditing" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}



- (IBAction)submit:(id)sender {
    @try {
        
        [rSkybox addEventToSession:@"submitForDwollaPayment"];
        
        self.errorLabel.text = @"";
        
        if ([self.checkNumOne.text isEqualToString:@" "] || [self.checkNumTwo.text isEqualToString:@" "] || [self.checkNumThree.text isEqualToString:@" "] || [self.checkNumFour.text isEqualToString:@" "]) {
            
            self.errorLabel.text = @"*Please enter your full pin.";
        }else{
            
            NSString *token = @"";
            @try {
                token = [DwollaAPI getAccessToken];
            }
            @catch (NSException *exception) {
                token = nil;
            }
            
            
            if ((token == nil) || [token isEqualToString:@""]) {
                //get the token
                [self.activity startAnimating];
                
                
                
                [self performSegueWithIdentifier:@"confirmDwolla" sender:self];
                
                
            }else{
                
                [self performSelector:@selector(createPayment)];

                /*
                if ([self.fundingSourceStatus isEqualToString:@"success"]) {
                    
                    if ([self.fundingSources count] == 0) {
                        
                    }else if ([self.fundingSources count] == 1){
                        
                        DwollaFundingSource *tmp = [self.fundingSources objectAtIndex:0];
                        self.selectedFundingSourceId = [tmp getSourceID];
                        [self performSelector:@selector(createPayment)];
                        
                    }else{
                        //display funding sources
                        
                        UIActionSheet *fundingAction = [[UIActionSheet alloc] initWithTitle:@"Select A Funding Source" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                        
                        for (int i = 0; i < [self.fundingSources count]; i++) {
                            DwollaFundingSource *tmp = [self.fundingSources objectAtIndex:i];
                            
                            [fundingAction addButtonWithTitle:[tmp getName]];
                        }
                        [fundingAction addButtonWithTitle:@"Cancel"];
                        
                        [fundingAction setCancelButtonIndex: [self.fundingSources count]];
                        
                        [fundingAction showInView:self.view];
                        
                        
                    }
                    
                    
                }else if ([self.fundingSourceStatus isEqualToString:@"failure"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dwolla Error" message:@"Unable to obtain Dwolla Funding Sources" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }else{
                    
                    self.waitingSources = YES;
                    
                    [self.activity startAnimating];
                    
                }
                
                */
                
            }
            
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.submit" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    @try {
        
        if (buttonIndex == [self.fundingSources count]) {
            //Cancel
        }else{
            
            DwollaFundingSource *tmp = [self.fundingSources objectAtIndex:buttonIndex];
            self.selectedFundingSourceId = [tmp getSourceID];
            [self performSelector:@selector(createPayment)];
        }
        
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.actionSheet" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}
-(void)createPayment{
    
    @try{        
        [self.activity startAnimating];
        
         NSString *pinNumber = [NSString stringWithFormat:@"%@%@%@%@", self.checkNumOne.text, self.checkNumTwo.text, self.checkNumThree.text, self.checkNumFour.text];
        
        NSString *dwollaToken = [DwollaAPI getAccessToken];
        
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
		NSDictionary *loginDict = [[NSDictionary alloc] init];
        

        NSNumber *amount = [NSNumber numberWithDouble:[[self.refundAccountDictionary valueForKey:@"Amount"] doubleValue]];
        NSNumber *grat = [NSNumber numberWithDouble:[[self.refundAccountDictionary valueForKey:@"Gratuity"] doubleValue]];

        [ tempDictionary setObject:grat forKey:@"Gratuity"];
        [ tempDictionary setObject:amount forKey:@"Amount"];
        
        [ tempDictionary setObject:dwollaToken forKey:@"AuthenticationToken"];
        [ tempDictionary setObject:@"" forKey:@"FundSourceAccount"];
        [ tempDictionary setObject:self.paymentId forKey:@"PaymentId"];
        [ tempDictionary setObject:self.merchantId forKey:@"MerchantId"];

 
        
        [tempDictionary setObject:[self.refundAccountDictionary valueForKey:@"Account"] forKey:@"FundTargetAccount"];
     
        NSString *customerId = [[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"];
        
        NSNumber *tmpId = @([customerId intValue]);
        [ tempDictionary setObject:tmpId forKey:@"CustomerId"];
        
        [ tempDictionary setObject:@"" forKey:@"Tag"];
        [ tempDictionary setObject:@"" forKey:@"Expiration"];
		
        NSNumber *invoice = @(self.invoiceId);
        [ tempDictionary setObject:invoice forKey:@"InvoiceId"];

        [ tempDictionary setObject:pinNumber forKey:@"Pin"];
        [ tempDictionary setObject:@"DWOLLA" forKey:@"Type"];

		loginDict = tempDictionary;
        self.payButton.enabled = NO;
        self.navigationItem.hidesBackButton = YES;
        ArcClient *client = [[ArcClient alloc] init];
        [client createPayment:loginDict];
    }
    @catch (NSException *e) {
        
        [rSkybox sendClientLog:@"DwollaPayment.createPayment" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

-(void)paymentComplete:(NSNotification *)notification{
    @try {
        
        [self.activity stopAnimating];
        self.submitButton.enabled = YES;
        self.payButton.enabled = YES;
        self.navigationItem.hidesBackButton = NO;
        
        [rSkybox addEventToSession:@"DwollaPaymentComplete"];
        
        NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];
        
        NSString *status = [responseInfo valueForKey:@"status"];
        
        [self.activity stopAnimating];
        NSString *errorMsg = @"";
        if ([status isEqualToString:@"success"]) {
            //success
            self.errorLabel.text = @"";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You have successfully refunded this payment." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else if([status isEqualToString:@"error"]){
            int errorCode = [[responseInfo valueForKey:@"error"] intValue];
            if(errorCode == CANNOT_PROCESS_PAYMENT) {
                errorMsg = @"Can not process payment.";
            } else if(errorCode == CANNOT_TRANSFER_TO_SAME_ACCOUNT) {
                errorMsg = @"Can not transfer to your own account.";
            } else if(errorCode == MERCHANT_CANNOT_ACCEPT_PAYMENT_TYPE) {
                errorMsg = @"Merchant does not accept Dwolla payment.";
            }
            else {
                errorMsg = ARC_ERROR_MSG;
            }
        } else {
            // must be failure -- user notification handled by ArcClient
            errorMsg = ARC_ERROR_MSG;
        }
        
        if([errorMsg length] > 0) {
            self.errorLabel.text = errorMsg;
        }
         
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.paymentComplete" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @try {
        
        if ([[segue identifier] isEqualToString:@"reviewTransaction"]) {
            
      
        } 
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"DwollaPayment.prepareForSegue" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
    
}

- (void)viewDidUnload {
    [self setRefundToLabel:nil];
    [self setRefundAmountLabel:nil];
    [super viewDidUnload];
}
@end
