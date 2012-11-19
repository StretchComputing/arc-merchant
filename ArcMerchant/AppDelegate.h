//
//  AppDelegate.h
//  ArcMerchant
//
//  Created by Nick Wroblewski on 9/9/12.
//  Copyright (c) 2012 Nick Wroblewski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *logout;
@property (nonatomic, strong) NSString *pushToken;


// *** copied in for rSkybox
@property (nonatomic, strong) NSString *appActions;
@property (nonatomic, strong) NSString *appActionsTime;
@property (nonatomic, strong) NSString *crashSummary;
@property (nonatomic, strong) NSString *crashUserName;
@property (nonatomic, strong) NSDate *crashDetectDate;
@property (nonatomic, strong) NSData *crashStackData;
@property (nonatomic, strong) NSString *crashInstanceUrl;
-(void)saveUserInfo;
-(void)handleCrashReport;
// ***

@end
