//
//  InvoiceActivity.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/29/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceActivity : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) NSMutableArray *allInvoicesArray;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@end
