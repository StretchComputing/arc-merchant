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
#import "rSkybox.h"

@interface InvoiceActivity ()

@end

@implementation InvoiceActivity

-(void)viewWillDisappear:(BOOL)animated{
    [self.refreshTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    self.refreshTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invoiceComplete:) name:@"invoiceNotification" object:nil];
    
    [self refresh];
}

-(void)refresh{
    
    self.refreshButton.hidden = YES;
    self.iconImageView.hidden = NO;
    
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 200.0;
    
    [self.iconImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    
    NSDictionary *loginDict = [[NSDictionary alloc] init];
    ArcClient *client = [[ArcClient alloc] init];
    [client getInvoice:loginDict];
}

-(void)invoiceComplete:(NSNotification *)notification{
    
    
    
    
    [self.iconImageView.layer removeAllAnimations];

    self.refreshButton.hidden = NO;
    self.iconImageView.hidden = YES;
    [self.activity stopAnimating];
    [self.refreshControl endRefreshing];

    @try {
        

        [rSkybox addEventToSession:@"invoiceComplete"];
        
        NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];
        NSString *status = [responseInfo valueForKey:@"status"];
        
        NSString *errorMsg = @"";
        if ([status isEqualToString:@"success"]) {
            
            self.myTableView.hidden = NO;
            self.errorLabel.hidden = YES;

            self.allInvoicesArray = [NSMutableArray array];
            self.filterInvoicesArray = [NSMutableArray array];

            
            NSArray *invoices = [[responseInfo valueForKey:@"apiResponse"] valueForKey:@"Results"];
            
            NSLog(@"Invoice count: %d", [invoices count]);
            
            
            if ([invoices count] == 0) {
                errorMsg = @"No open dutch invoices found.";
            }
            
            for (int i = 0; i < [invoices count]; i++) {
                
                Invoice *myInvoice = [[Invoice alloc] init];
                
                NSDictionary *theInvoice = [invoices objectAtIndex:i];
                
                myInvoice = [[Invoice alloc] init];
                myInvoice.invoiceId = [[theInvoice valueForKey:@"Id"] intValue];
                myInvoice.status = [theInvoice valueForKey:@"Status"];
                myInvoice.number = [theInvoice valueForKey:@"Number"];
                myInvoice.merchantId = [[theInvoice valueForKey:@"MerchantId"] intValue];
                //myInvoice.customerId = [[theInvoice valueForKey:@"CustomerId"] intValue];
                myInvoice.posi = [theInvoice valueForKey:@"POSI"];
                
                myInvoice.baseAmount = [[theInvoice valueForKey:@"BaseAmount"] doubleValue];
                myInvoice.tax = [[theInvoice valueForKey:@"Tax"] doubleValue];

                
                myInvoice.serviceCharge = [[theInvoice valueForKey:@"ServiceCharge"] doubleValue];
                myInvoice.discount = [[theInvoice valueForKey:@"Discount"] doubleValue];
                myInvoice.additionalCharge = [[theInvoice valueForKey:@"AdditionalCharge"] doubleValue];
                
                myInvoice.dateCreated = [theInvoice valueForKey:@"DateCreated"];
                myInvoice.lastUpdated = [theInvoice valueForKey:@"LastUpdated"];

                
                myInvoice.tags = [NSArray arrayWithArray:[theInvoice valueForKey:@"Tags"]];
                myInvoice.items = [NSArray arrayWithArray:[theInvoice valueForKey:@"Items"]];
                myInvoice.payments = [NSArray arrayWithArray:[theInvoice valueForKey:@"Payments"]];
                myInvoice.tableNumber = [theInvoice valueForKey:@"TableNumber"];
        
              


                [self.allInvoicesArray addObject:myInvoice];
            }
        
        
            NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:NO];
            [self.allInvoicesArray sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
            
            [self setArrays];
            
            
        } else if([status isEqualToString:@"error"]){
            int errorCode = [[responseInfo valueForKey:@"error"] intValue];
            if(errorCode == 101 || errorCode == 100) {
                errorMsg = @"No open dutch invoices found.";
            } else {
                errorMsg = ARC_ERROR_MSG;
            }
        } else {
            // must be failure -- user notification handled by ArcClient
            errorMsg = ARC_ERROR_MSG;
        }
        
        if([errorMsg length] > 0) {
            self.errorLabel.text = errorMsg;
            if ([self.allInvoicesArray count] == 0) {
                self.myTableView.hidden = YES;
                self.errorLabel.hidden = NO;
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"EERROR: %@", e);
        
        //[rSkybox sendClientLog:@"Restaurant.invoiceComplete" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
    
}


-(void)setArrays{
    
    self.typeFilterInvoicesArray = [NSMutableArray array];
    if (self.segControl.selectedSegmentIndex == 0) {
        
        for (int i = 0; i < [self.allInvoicesArray count]; i++) {
            Invoice *tmp = [self.allInvoicesArray objectAtIndex:i];
            if ([tmp.status isEqualToString:@"INVOICE_UNPAID"]) {
                [self.typeFilterInvoicesArray addObject:tmp];
            }
        }
        
    }else if (self.segControl.selectedSegmentIndex == 1){
        
        for (int i = 0; i < [self.allInvoicesArray count]; i++) {
            Invoice *tmp = [self.allInvoicesArray objectAtIndex:i];
            if ([tmp.status isEqualToString:@"INVOICE_PAID"] || [tmp.status isEqualToString:@"INVOICE_PAID_IN_FULL"]) {
                [self.typeFilterInvoicesArray addObject:tmp];
            }
        }
    }else{
        self.typeFilterInvoicesArray = [NSMutableArray arrayWithArray:self.allInvoicesArray];
    }
    
    
    self.filterInvoicesArray = [NSMutableArray arrayWithArray:self.typeFilterInvoicesArray];
    
    [self.myTableView reloadData];


}
-(void)viewDidAppear:(BOOL)animated{
    AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    if ([mainDelegate.logout isEqualToString:@"true"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"merchantId"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"managerId"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"managerToken"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"admin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController dismissModalViewControllerAnimated:NO];
    }
}

-(void)refreshList:(NSNotification *)notification{
    [self refresh];
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.cancelSearchButton.text = @"Cancel";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

    
    self.topLineView.layer.shadowOffset = CGSizeMake(0, 1);
    self.topLineView.layer.shadowRadius = 2;
    self.topLineView.layer.shadowOpacity = 0.4;
    
    

    self.topLineView.backgroundColor = dutchTopLineColor;
    self.bottomLineView.backgroundColor = dutchTopLineColor;
    
    self.myTableView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:248.0/255.0 alpha:1.0];
    self.view.backgroundColor = dutchTopNavColor;
    self.segControl.tintColor = dutchDarkBlueColor;
    
    for (UIView *subview in self.searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    
    self.navigationItem.rightBarButtonItem = nil;
    
    if(NSClassFromString(@"UIRefreshControl")) {
        self.isIos6 = YES;
    }else{
        self.isIos6 = NO;
    }
    
    if (self.isIos6) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
        [self.myTableView addSubview:self.refreshControl];
    }
}


-(void)handleRefresh:(id)sender{
    
    [self refresh];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.filterInvoicesArray count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Activity" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
    
    if ([self.filterInvoicesArray count] > 0) {
        
        Invoice *myInvoice = [self.filterInvoicesArray objectAtIndex:indexPath.row];
    
        
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

    UILabel *tableNumber = (UILabel *)[cell.contentView viewWithTag:5];

    UIView *backView = (UIView *)[cell.contentView viewWithTag:6];
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:7];

    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = [dutchTopLineColor CGColor];
    backView.layer.borderWidth = 1.0;
    backView.layer.shadowOffset = CGSizeMake(0, 1);
    backView.layer.shadowRadius = 2;
    backView.layer.shadowOpacity = 0.4;
    
    if ([self.filterInvoicesArray count] == 0) {
        
    }else{
        
        
        Invoice *invoiceObject = [self.filterInvoicesArray objectAtIndex:indexPath.row];
        
        
        invoiceNumberLabel.text = [NSString stringWithFormat:@"Invoice #: %@", invoiceObject.number];
        
        double totalAmount = invoiceObject.baseAmount + invoiceObject.serviceCharge + invoiceObject.tax + invoiceObject.additionalCharge - invoiceObject.discount;
        
        invoiceAmountLabel.text = [NSString stringWithFormat:@"$%.2f", totalAmount];
        
        invoiceStatusLabel.text = invoiceObject.status;
        //if ([invoiceObject.status isEqualToString:@"INVOICE_PAID"]) {
         //   backView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0];
        //}
        
        invoiceDateLabel.text = invoiceObject.lastUpdated;
        
        NSLog(@"%@", invoiceObject.lastUpdated);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *myDate = [dateFormat dateFromString:[invoiceObject.lastUpdated substringToIndex:19]];
        
        [dateFormat setDateFormat:@"MM/dd hh:mm aa"];
        
        invoiceDateLabel.text = [dateFormat stringFromDate:myDate];
        tableNumber.text = [NSString stringWithFormat:@"Table #: %@", invoiceObject.tableNumber];
        
        if ([invoiceObject.status isEqualToString:@"INVOICE_PAID"] || [invoiceObject.status isEqualToString:@"INVOICE_PAID_IN_FULL"]) {
            imageView.image = [UIImage imageNamed:@"paid.png"];
        }else if ([invoiceObject.status isEqualToString:@"INVOICE_PAID_PARTIAL"]){
            imageView.image = [UIImage imageNamed:@"partial.png"];
        }else{
            imageView.image = [UIImage imageNamed:@"notpaid.png"];
        }

    }
    
    
    
    return cell;
        
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    self.filterInvoicesArray = [NSMutableArray array];
    if ([searchText length] > 0) {
        for (int i = 0; i < [self.typeFilterInvoicesArray count]; i++) {
            
            Invoice *tmp = [self.typeFilterInvoicesArray objectAtIndex:i];
            
            NSLog(@"Number: %@", tmp.number);
            NSLog(@"Text: %@", searchText);
            
            if ([tmp.number rangeOfString:searchText].location != NSNotFound) {
                [self.filterInvoicesArray addObject:tmp];
            }
        }
    }else{
        self.filterInvoicesArray = [NSMutableArray arrayWithArray:self.typeFilterInvoicesArray];
    }
    
    [self.myTableView reloadData];
   
}

-(void)cancelSearchAction{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.searchBar.frame;
        frame.size.width = 320;
        self.searchBar.frame = frame;
        
        self.cancelSearchButton.hidden = YES;
    }];
    
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.searchBar.frame;
        frame.size.width = 240;
        self.searchBar.frame = frame;
        
        self.cancelSearchButton.hidden = NO;
    }];
    
    
}
- (IBAction)segmentValueChanged {
    self.searchBar.text = @"";
    [self setArrays];
}

- (IBAction)doneSearchAction:(id)sender {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    [self setArrays];
}

- (IBAction)goSettings {
    [self performSegueWithIdentifier:@"goSettings" sender:self];
}

- (IBAction)refreshAction {
    
    [self refresh];
}
@end
