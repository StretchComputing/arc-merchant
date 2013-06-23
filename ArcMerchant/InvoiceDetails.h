//
//  InvoiceDetails.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 10/6/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"
#import "NVUIGradientButton.h"

@interface InvoiceDetails : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property double refundAmount;
@property (nonatomic, strong) NSDictionary *refundDictionary;
- (IBAction)refundMainAction;
@property (strong, nonatomic) IBOutlet UIView *outlineView;
@property (strong, nonatomic) IBOutlet UIView *outlineVerticalView;

@property (nonatomic, strong) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UIView *invoiceItemsView;
@property (nonatomic, strong) Invoice *myInvoice;
@property (weak, nonatomic) IBOutlet UILabel *invoiceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceDateCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceLastUpdatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceBaseAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceServiceChargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceTaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *invoiceDiscountLabel;
- (IBAction)goBack;
@property (strong, nonatomic) IBOutlet UIView *topBackView;
@property (strong, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *invoiceAdditionalChargeLabel;
- (IBAction)showInvoiceItemsAction;
- (IBAction)showPaymentsAction;
@property (weak, nonatomic) IBOutlet UITableView *invoiceItemsTable;
@property (weak, nonatomic) IBOutlet UIView *invoicePaymentsView;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *closeInvoicePaymentsView;
@property (weak, nonatomic) IBOutlet NVUIGradientButton *closeInvoiceItemsButton;

- (IBAction)closeInvoicePaymentsAction;
@property (weak, nonatomic) IBOutlet UIView *refundAmountView;
- (IBAction)refundPartialAction;
@property (weak, nonatomic) IBOutlet UITextField *refundAmountText;
- (IBAction)endText;
- (IBAction)cancelRefundAction;
@property (strong, nonatomic) IBOutlet UIView *bottomLineView;
@property (strong, nonatomic) IBOutlet UIView *midLineView;
@property (strong, nonatomic) IBOutlet NVUIGradientButton *refundButton;
@property (strong, nonatomic) IBOutlet NVUIGradientButton *itemsButton;
@property (strong, nonatomic) IBOutlet NVUIGradientButton *paymentsButton;

- (IBAction)refundAllAction;
@property (weak, nonatomic) IBOutlet UITableView *invoicePaymentsTable;
- (IBAction)closeInvoiceItemsAction;
@property (weak, nonatomic) IBOutlet UILabel *invoiceTotalLabel;
@end
