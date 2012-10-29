//
//  RefundButton.m
//  ArcMerchant
//
//  Created by Nick Wroblewski on 10/7/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import "RefundButton.h"
#import "rSkybox.h"

@implementation RefundButton


- (id)initWithCoder:(NSCoder *)decoder {
    @try {
        
        if ((self = [super initWithCoder: decoder])) {
            
            
        }
        return self;
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"RefundButton.initWithCoder" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        return self;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    @try {
        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
        }
        return self;
        
    } @catch (NSException *e) {
        [rSkybox sendClientLog:@"RefundButton.initWithFrame" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
        return self;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
