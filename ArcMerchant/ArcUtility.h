//
//  ArcUtility.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 10/28/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcUtility : NSObject

@property (nonatomic, strong) NSMutableData *serverData;
-(void)updatePushToken;

@end
