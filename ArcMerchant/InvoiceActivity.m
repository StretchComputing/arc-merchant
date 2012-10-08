//
//  InvoiceActivity.m
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/29/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import "InvoiceActivity.h"
#import "ArcClient.h"
#import "Invoice.h"
#import <QuartzCore/QuartzCore.h>
#import "InvoiceDetails.h"
#import "AppDelegate.h"

@interface InvoiceActivity ()

@end

@implementation InvoiceActivity

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invoiceComplete:) name:@"invoiceNotification" object:nil];
    
    NSDictionary *loginDict = [[NSDictionary alloc] init];
    ArcClient *client = [[ArcClient alloc] init];
    [self.activity startAnimating];
    [client getInvoice:loginDict];
}


-(void)invoiceComplete:(NSNotification *)notification{
    
    [self.activity stopAnimating];

    @try {
        

        
        NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];
        NSString *status = [responseInfo valueForKey:@"status"];
        
        NSString *errorMsg = @"";
        if ([status isEqualToString:@"success"]) {
            
            self.allInvoicesArray = [NSMutableArray array];
            NSArray *invoices = [[responseInfo valueForKey:@"apiResponse"] valueForKey:@"Results"];
            
            for (int i = 0; i < [invoices count]; i++) {
                
                Invoice *myInvoice = [[Invoice alloc] init];
                
                NSDictionary *theInvoice = [invoices objectAtIndex:i];
                
                myInvoice = [[Invoice alloc] init];
                myInvoice.invoiceId = [[theInvoice valueForKey:@"Id"] intValue];
                myInvoice.status = [theInvoice valueForKey:@"Status"];
                myInvoice.number = [theInvoice valueForKey:@"Number"];
                myInvoice.merchantId = [[theInvoice valueForKey:@"MerchantId"] intValue];
                myInvoice.customerId = [[theInvoice valueForKey:@"CustomerId"] intValue];
                myInvoice.posi = [theInvoice valueForKey:@"POSI"];
                
                myInvoice.baseAmount = [[theInvoice valueForKey:@"BaseAmount"] doubleValue];
                myInvoice.serviceCharge = [[theInvoice valueForKey:@"ServiceCharge"] doubleValue];
                myInvoice.tax = [[theInvoice valueForKey:@"Tax"] doubleValue];
                myInvoice.discount = [[theInvoice valueForKey:@"Discount"] doubleValue];
                myInvoice.additionalCharge = [[theInvoice valueForKey:@"AdditionalCharge"] doubleValue];
                
                myInvoice.dateCreated = [theInvoice valueForKey:@"DateCreated"];
                myInvoice.lastUpdated = [theInvoice valueForKey:@"LastUpdated"];

                
                myInvoice.tags = [NSArray arrayWithArray:[theInvoice valueForKey:@"Tags"]];
                myInvoice.items = [NSArray arrayWithArray:[theInvoice valueForKey:@"Items"]];
                myInvoice.payments = [NSArray arrayWithArray:[theInvoice valueForKey:@"Payments"]];
                
                NSLog(@"Count: %d", [myInvoice.payments count]);

                [self.allInvoicesArray addObject:myInvoice];
            }
        
        NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:NO];
        [self.allInvoicesArray sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
            
        [self.myTableView reloadData];
            
        } else if([status isEqualToString:@"error"]){
            int errorCode = [[responseInfo valueForKey:@"error"] intValue];
            if(errorCode == INVOICE_NOT_FOUND) {
                errorMsg = @"Can not find invoice.";
            } else {
                errorMsg = ARC_ERROR_MSG;
            }
        } else {
            // must be failure -- user notification handled by ArcClient
            errorMsg = ARC_ERROR_MSG;
        }
        
        if([errorMsg length] > 0) {
            //self.errorLabel.text = errorMsg;
        }
    }
    @catch (NSException *e) {
        NSLog(@"EERROR: %@", e);
        
        //[rSkybox sendClientLog:@"Restaurant.invoiceComplete" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}



-(void)viewDidAppear:(BOOL)animated{
    AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    if ([mainDelegate.logout isEqualToString:@"true"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"customerId"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"customerToken"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"admin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController dismissModalViewControllerAnimated:NO];
    }
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
      self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21.0/255.0 green:80.0/255.0  blue:125.0/255.0 alpha:1.0];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    UIColor *myColor = [UIColor colorWithRed:114.0/255.0 green:168.0/255.0 blue:192.0/255.0 alpha:1.0];
    double x = 2.0;
    
    UIColor *otherColor = [UIColor colorWithRed:114.0*x/255.0 green:168.0*x/155.0 blue:192.0*x/255.0 alpha:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[otherColor CGColor], (id)[myColor CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.allInvoicesArray count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Activity" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
    
    if ([self.allInvoicesArray count] > 0) {
        
        Invoice *myInvoice = [self.allInvoicesArray objectAtIndex:indexPath.row];
        
        InvoiceDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"invoiceDetails"];
        details.myInvoice = myInvoice;
        [self.navigationController pushViewController:details animated:YES];
        
    }
   
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *invoiceCell=@"invoiceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:invoiceCell];
        

    
    UILabel *invoiceNumberLabel =  (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *invoiceAmountLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *invoiceStatusLabel = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *invoiceDateLabel = (UILabel *)[cell.contentView viewWithTag:4];

    if ([self.allInvoicesArray count] == 0) {
        
    }else{
        
        
        Invoice *invoiceObject = [self.allInvoicesArray objectAtIndex:indexPath.row];
        
        
        invoiceNumberLabel.text = [NSString stringWithFormat:@"Invoice #: %@", invoiceObject.number];
        
        double totalAmount = invoiceObject.baseAmount + invoiceObject.serviceCharge + invoiceObject.tax + invoiceObject.additionalCharge - invoiceObject.discount;
        
        invoiceAmountLabel.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
        
        invoiceStatusLabel.text = invoiceObject.status;
        
        invoiceDateLabel.text = invoiceObject.lastUpdated;
        
        NSLog(@"%@", invoiceObject.lastUpdated);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *myDate = [dateFormat dateFromString:[invoiceObject.lastUpdated substringToIndex:19]];
        
        [dateFormat setDateFormat:@"MM/dd hh:mm aa"];
        
        invoiceDateLabel.text = [dateFormat stringFromDate:myDate];

    }
    
    
    
    return cell;
        
}




@end
