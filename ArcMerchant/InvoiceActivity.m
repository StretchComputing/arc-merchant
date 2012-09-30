//
//  InvoiceActivity.m
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/29/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import "InvoiceActivity.h"
#import "ArcClient.h"
@interface InvoiceActivity ()

@end

@implementation InvoiceActivity


-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *loginDict = [[NSDictionary alloc] init];
    ArcClient *client = [[ArcClient alloc] init];
    [client getInvoiceList:loginDict];
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    
      self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21.0/255.0 green:80.0/255.0  blue:125.0/255.0 alpha:1.0];
}

@end
