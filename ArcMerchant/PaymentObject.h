//
//  PaymentObject.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 10/7/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentObject : NSObject

@property (nonatomic, strong) NSString *customerId, *customerName, *amount, *type, *account, *gratuity;

@end
