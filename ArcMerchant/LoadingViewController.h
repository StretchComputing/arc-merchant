//
//  LoadingViewController.h
//  ARC
//
//  Created by Nick Wroblewski on 2/21/13.
//
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *backAlphaView;
@property (strong, nonatomic) IBOutlet UIView *mainBackView;
@property (strong, nonatomic) IBOutlet UILabel *displayText;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;


-(void)startSpin;
-(void)stopSpin;
@end
