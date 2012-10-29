//
//  InvoiceActivity.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/29/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceActivity : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)doneSearchAction:(id)sender;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneSearchButton;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) NSMutableArray *allInvoicesArray;
@property (nonatomic, strong) NSMutableArray *filterInvoicesArray;
@property (nonatomic, strong) NSMutableArray *typeFilterInvoicesArray;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property BOOL isIos6;

- (IBAction)segmentValueChanged;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@end
