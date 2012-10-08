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

@interface InvoiceDetails ()

@end

@implementation InvoiceDetails

- (void)viewDidLoad
{
    self.title = @"Details";
    
    [super viewDidLoad];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *myColor = [UIColor colorWithRed:114.0/255.0 green:168.0/255.0 blue:192.0/255.0 alpha:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[myColor CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];

    self.invoiceItemsView.layer.masksToBounds = YES;
    self.invoiceItemsView.layer.cornerRadius = 4.0;
    self.invoiceItemsView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.invoiceItemsView.layer.borderWidth = 2.0;
    self.invoiceItemsView.hidden = YES;
    
    self.invoicePaymentsView.layer.masksToBounds = YES;
    self.invoicePaymentsView.layer.cornerRadius = 4.0;
    self.invoicePaymentsView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.invoicePaymentsView.layer.borderWidth = 2.0;
    self.invoicePaymentsView.hidden = YES;
    
    self.refundAmountView.layer.masksToBounds = YES;
    self.refundAmountView.layer.cornerRadius = 4.0;
    self.refundAmountView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.refundAmountView.layer.borderWidth = 2.0;
    self.refundAmountView.hidden = YES;
    
    [self setLabels];
}


-(void)setLabels{
    
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

    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.invoiceItemsTable) {
        return [self.myInvoice.items count];
    }
    NSLog(@"Count: %d", [self.myInvoice.payments count]);
    return [self.myInvoice.payments count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.invoiceItemsTable) {
        return 40;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    if (tableView == self.invoiceItemsTable) {
        
    }else{
  
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
            priceLabel.text = [[item valueForKey:@"Value"] stringValue];

            
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

        if ([self.myInvoice.items count] == 0) {
            
        }else{
            
            NSDictionary *payment = [self.myInvoice.payments objectAtIndex:indexPath.row];
            
            nameLabel.text = [payment valueForKey:@"Name"];
            
            double amount = [[payment valueForKey:@"Amount"] doubleValue];
            priceLabel.text = [NSString stringWithFormat:@"$%.2f", amount];
            
            typeLabel.text = [payment valueForKey:@"Type"];
            
            double gratuity = [[payment valueForKey:@"Gratuity"] doubleValue];
            tipLabel.text = [NSString stringWithFormat:@"Gratuity: $%.2f", gratuity];
            
            if ([[payment valueForKey:@"Type"] isEqualToString:@"CREDIT"]){
                refundButton.hidden = NO;
                refundButton.selectedRow = indexPath.row;
                [refundButton addTarget:self action:@selector(refundPayment:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                refundButton.hidden = NO;
            }
            
        }
        return cell;
    }
}


-(void)refundPayment:(id)sender{
    
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
 
}

- (IBAction)showInvoiceItemsAction {
    
    self.invoiceItemsView.hidden = NO;
    [self.invoiceItemsTable reloadData];
}

- (IBAction)showPaymentsAction {
    self.invoicePaymentsView.hidden= NO;
    [self.invoicePaymentsTable reloadData];
}

- (IBAction)closeInvoicePaymentsAction {
    self.invoicePaymentsView.hidden = YES;
}

- (IBAction)closeInvoiceItemsAction {
    self.invoiceItemsView.hidden = YES;
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
    
    double amount = [[self.refundDictionary valueForKey:@"Amount"] doubleValue];
    double gratuity = [[self.refundDictionary valueForKey:@"Gratuity"] doubleValue];
    
    self.refundAmount = amount + gratuity;
    [self goDwollaPay];
}

-(void)goDwollaPay{
    
    DwollaPayment *tmp = [self.storyboard instantiateViewControllerWithIdentifier:@"refundDwolla"];
    tmp.refundAmount = self.refundAmount;
    tmp.refundAccountDictionary = self.refundDictionary;
    tmp.invoiceId = self.myInvoice.invoiceId;
    [self.navigationController pushViewController:tmp animated:YES];
    
}

@end
