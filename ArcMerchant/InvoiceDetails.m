//
//  InvoiceDetails.m
//  ArcMerchant
//
//  Created by Nick Wroblewski on 10/6/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import "InvoiceDetails.h"
#import <QuartzCore/QuartzCore.h>
#import "RefundButton.h"
#import "DwollaPayment.h"
#import "DwollaAPI.h"
#import "rSkybox.h"
#import "AppDelegate.h"

@interface InvoiceDetails ()

@end


@implementation InvoiceDetails

- (void)viewDidLoad
{
    @try {
        
        self.closeInvoicePaymentsView.text = @"Close";
        self.closeInvoiceItemsButton.text = @"Close";
        self.title = @"Details";
        [rSkybox addEventToSession:@"viewInvoiceDetails"];
        
        self.outlineVerticalView.backgroundColor = dutchDarkBlueColor;
        self.outlineView.backgroundColor = dutchDarkBlueColor;
        
        [super viewDidLoad];
        self.topLineView.layer.shadowOffset = CGSizeMake(0, 1);
        self.topLineView.layer.shadowRadius = 2;
        self.topLineView.layer.shadowOpacity = 0.4;
  
        self.topBackView.backgroundColor = dutchTopNavColor;
        self.topLineView.backgroundColor = dutchTopLineColor;
        self.midLineView.backgroundColor = dutchTopLineColor;
        self.bottomLineView.backgroundColor = dutchTopLineColor;

        self.refundButton.text = @"Refund Invoice";
        self.itemsButton.text = @"View Items";
        self.paymentsButton.text = @"View Payments";
        
        self.alphaView.hidden = YES;
       // self.invoiceItemsView.layer.masksToBounds = YES;
        self.invoiceItemsView.layer.cornerRadius = 3.0;
        self.invoiceItemsView.layer.borderColor = [dutchTopLineColor CGColor];
        self.invoiceItemsView.layer.borderWidth = 1.0;
        self.invoiceItemsView.hidden = YES;
        self.invoiceItemsView.layer.shadowOffset = CGSizeMake(0, 0);
        self.invoiceItemsView.layer.shadowRadius = 10;
        self.invoiceItemsView.layer.shadowOpacity = 0.4;
        
        //self.invoicePaymentsView.layer.masksToBounds = YES;
        self.invoicePaymentsView.layer.cornerRadius = 3.0;
        self.invoicePaymentsView.layer.borderColor = [dutchTopLineColor CGColor];
        self.invoicePaymentsView.layer.borderWidth = 1.0;
        self.invoicePaymentsView.hidden = YES;
        self.invoicePaymentsView.layer.shadowOffset = CGSizeMake(0, 0);
        self.invoicePaymentsView.layer.shadowRadius = 10;
        self.invoicePaymentsView.layer.shadowOpacity = 0.4;
        
        self.refundAmountView.layer.masksToBounds = YES;
        self.refundAmountView.layer.cornerRadius = 4.0;
        self.refundAmountView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.refundAmountView.layer.borderWidth = 2.0;
        self.refundAmountView.hidden = YES;
        
        [self setLabels];
        
        NSMutableArray *paymentArray = [NSMutableArray arrayWithArray:self.myInvoice.payments];
        
        for (int i = 0; i < [paymentArray count]; i++) {
            
            NSDictionary *payment = [paymentArray objectAtIndex:i];
            
            
            if ([[payment valueForKey:@"Status"] isEqualToString:@"VOID"]) {
                
                [paymentArray removeObjectAtIndex:i];
                i--;
            }
            
        }
        
        self.myInvoice.payments = [NSArray arrayWithArray:paymentArray];
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.viewDidLoad" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}



-(void)setLabels{
    @try {
        
        double totalAmount = self.myInvoice.baseAmount + self.myInvoice.serviceCharge + self.myInvoice.tax + self.myInvoice.additionalCharge - self.myInvoice.discount;
        
        
        self.invoiceNumberLabel.text = [NSString stringWithFormat:@"Invoice #: %@", self.myInvoice.number];
        self.invoiceTotalLabel.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
        self.invoiceStatusLabel.text = self.myInvoice.status;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *created = [dateFormat dateFromString:[self.myInvoice.dateCreated substringToIndex:19]];
        NSDate *lastUpdated = [dateFormat dateFromString:[self.myInvoice.lastUpdated substringToIndex:19]];
        
        [dateFormat setDateFormat:@"MM/dd hh:mm aa"];
        
        self.invoiceDateCreatedLabel.text = [dateFormat stringFromDate:created];
        self.invoiceLastUpdatedLabel.text = [dateFormat stringFromDate:lastUpdated];
        
        self.invoiceBaseAmountLabel.text = [NSString stringWithFormat:@"$%.2f", self.myInvoice.baseAmount];
        self.invoiceServiceChargeLabel.text = [NSString stringWithFormat:@"$%.2f", self.myInvoice.serviceCharge];
        self.invoiceTaxLabel.text = [NSString stringWithFormat:@"$%.2f", self.myInvoice.tax];
        self.invoiceDiscountLabel.text = [NSString stringWithFormat:@"$%.2f", self.myInvoice.discount];
        self.invoiceAdditionalChargeLabel.text = [NSString stringWithFormat:@"$%.2f", self.myInvoice.additionalCharge];
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.setLabels" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @try {
        
        if (tableView == self.invoiceItemsTable) {
            return [self.myInvoice.items count];
        }
        NSLog(@"Count: %d", [self.myInvoice.payments count]);
        return [self.myInvoice.payments count];
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.tableView:numberOfRowsInSection" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if (tableView == self.invoiceItemsTable) {
            return 25;
        }
        return 70;
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.tableView:heightForRowAtIndexPath" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    @try {
        
        if (tableView == self.invoiceItemsTable) {
            
        }else{
            
        }
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.tableView:didSelectRowAtIndexPath" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        if (tableView == self.invoiceItemsTable) {
            static NSString *invoiceCell=@"itemCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:invoiceCell];
            
            
            
            UILabel *amountLabel =  (UILabel *)[cell.contentView viewWithTag:1];
            UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:2];
            UILabel *priceLabel = (UILabel *)[cell.contentView viewWithTag:3];
            
            if ([self.myInvoice.items count] == 0) {
                
            }else{
                
                NSDictionary *item = [self.myInvoice.items objectAtIndex:indexPath.row];
                
                amountLabel.text = [[item valueForKey:@"Amount"] stringValue];
                descriptionLabel.text = [item valueForKey:@"Description"];
                
                double priceDouble = [[item valueForKey:@"Value"] doubleValue];
                priceLabel.text = [NSString stringWithFormat:@"%.2f", priceDouble ];
                
                
            }
            
            
            
            return cell;
            
            
        }else{
            
            static NSString *invoiceCell=@"paymentCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:invoiceCell];
            
            
            UILabel *nameLabel =  (UILabel *)[cell.contentView viewWithTag:1];
            UILabel *priceLabel = (UILabel *)[cell.contentView viewWithTag:2];
            UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *tipLabel = (UILabel *)[cell.contentView viewWithTag:4];
            RefundButton *refundButton = (RefundButton *)[cell.contentView viewWithTag:5];
            
            UILabel *voidLabel = (UILabel *)[cell.contentView viewWithTag:6];
            
            
            if ([self.myInvoice.items count] == 0) {
                voidLabel.text = @"";
            }else{
                voidLabel.hidden = YES;
                NSDictionary *payment = [self.myInvoice.payments objectAtIndex:indexPath.row];
                
                nameLabel.text = [payment valueForKey:@"Name"];
                
                double amount = [[payment valueForKey:@"Amount"] doubleValue];
                priceLabel.text = [NSString stringWithFormat:@"$%.2f", amount];
                
                typeLabel.text = [payment valueForKey:@"Type"];
                
                double gratuity = [[payment valueForKey:@"Gratuity"] doubleValue];
                tipLabel.text = [NSString stringWithFormat:@"Gratuity: $%.2f", gratuity];
                
                if ([[payment valueForKey:@"Type"] isEqualToString:@"DWOLLA"]){
                    
                    if (![[payment valueForKey:@"Status"] isEqualToString:@"PAID"]) {
                        refundButton.hidden = YES;
                        voidLabel.hidden = NO;
                        voidLabel.text = [NSString stringWithFormat:@"*%@*", [payment valueForKey:@"Status"]];
                    }else{
                        refundButton.hidden = NO;
                        refundButton.selectedRow = indexPath.row;
                        [refundButton addTarget:self action:@selector(refundPayment:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                }else{
                    voidLabel.hidden = NO;
                    voidLabel.text = [NSString stringWithFormat:@"*%@*", [payment valueForKey:@"Status"]];
                    
                    refundButton.hidden = YES;
                }
                
            }
            return cell;
        }
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.tableView:cellForRowAtIndexPath" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}


-(void)refundPayment:(id)sender{
    @try {
        
        NSString *token = @"";
        @try {
            token = [DwollaAPI getAccessToken];
        }
        @catch (NSException *exception) {
            token = nil;
        }
        
        
        if ([token length] > 0) {
            RefundButton *tmpButton = (RefundButton *)sender;
            
            NSDictionary *payment = [self.myInvoice.payments objectAtIndex:tmpButton.selectedRow];
            
            self.refundDictionary = [NSDictionary dictionary];
            self.refundDictionary = payment;
            
            
            [self refundAllAction];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Dwolla Accout" message:@"Please log into your Dwolla Account in the ArcMerchant Settings before issuing refunds." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.refundPayment" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
 
}

- (IBAction)showInvoiceItemsAction {
    @try {
        
        if ([self.myInvoice.items count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"None Found" message:@"There were no items found on this invoice." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }else{
            
            self.invoiceItemsView.hidden = NO;
            self.alphaView.hidden = NO;
            [self.invoiceItemsTable reloadData];
        }
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.showInvoiceItemsAction" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
  
}

- (IBAction)showPaymentsAction {
    @try {
        if ([self.myInvoice.payments count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"None Found" message:@"There were no payments found on this invoice." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }else{
            self.invoicePaymentsView.hidden= NO;
            self.alphaView.hidden = NO;
            [self.invoicePaymentsTable reloadData];
        }
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.showPaymentsAction" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}

- (IBAction)closeInvoicePaymentsAction {
    self.invoicePaymentsView.hidden = YES;
    self.alphaView.hidden = YES;
}

- (IBAction)closeInvoiceItemsAction {
    self.invoiceItemsView.hidden = YES;
    self.alphaView.hidden = YES;
}


- (IBAction)refundPartialAction {
    
    self.refundAmount = [self.refundAmountText.text doubleValue];
    [self goDwollaPay];
}

- (IBAction)endText {
}

- (IBAction)cancelRefundAction {
    [self.refundAmountText resignFirstResponder];
    self.refundAmountView.hidden = YES;
}

- (IBAction)refundAllAction {
    @try {
        [rSkybox addEventToSession:@"refundRequested"];
        double amount = [[self.refundDictionary valueForKey:@"Amount"] doubleValue];
        double gratuity = [[self.refundDictionary valueForKey:@"Gratuity"] doubleValue];
        
        self.refundAmount = amount + gratuity;
        [self goDwollaPay];
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.refundAllAction" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}

-(void)goDwollaPay{
    @try {
        
        DwollaPayment *tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"refundDwolla"];
        tmp.refundAmount = self.refundAmount;
        tmp.refundAccountDictionary = self.refundDictionary;
        tmp.invoiceId = self.myInvoice.invoiceId;
        tmp.paymentId = [self.refundDictionary valueForKey:@"PaymentId"];
        
        
        tmp.merchantId = [NSString stringWithFormat:@"%d", self.myInvoice.merchantId];
        [self.navigationController pushViewController:tmp animated:YES];
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.goDwollaPay" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

- (IBAction)refundMainAction {
    @try {
        
        NSString *token = @"";
        @try {
            token = [DwollaAPI getAccessToken];
        }
        @catch (NSException *exception) {
            token = nil;
        }
        
        
        if ([token length] > 0) {
            
            
            if ([self.myInvoice.payments count] > 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Multiple Payments" message:@"Multiple payments were found on this invoice, please select which you would like to refund" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                [self showPaymentsAction];
                
            }else{
                
                NSDictionary *payment = [self.myInvoice.payments objectAtIndex:0];
                
                if ([[payment valueForKey:@"Type"] isEqualToString:@"DWOLLA"]) {
                    self.refundDictionary = [NSDictionary dictionary];
                    self.refundDictionary = payment;
                    
                    [self refundAllAction];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Dwolla Payments" message:@"The payment on this invoice was not made with Dwolla, and therefore is not refundable" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
                
                
            }
            
            
            
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Dwolla Accout" message:@"Please log into your Dwolla Account in the ArcMerchant Settings before issuing refunds." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"InvoiceDetails.refundMainAction" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}
- (IBAction)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setTopBackView:nil];
    [self setTopLineView:nil];
    [self setBottomLineView:nil];
    [self setMidLineView:nil];
    [self setRefundButton:nil];
    [self setItemsButton:nil];
    [self setPaymentsButton:nil];
    [self setOutlineView:nil];
    [self setOutlineVerticalView:nil];
    [super viewDidUnload];
}
@end
