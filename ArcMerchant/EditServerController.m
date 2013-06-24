//
//  EditServerController.m
//  ARC
//
//  Created by Nick Wroblewski on 11/8/12.
//
//

#import "EditServerController.h"
#import "rSkybox.h"
#import "ArcClient.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NVUIGradientButton.h"

@interface EditServerController ()

@end

@implementation EditServerController


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self.loadingViewController startSpin];
    self.loadingViewController.displayText.text = @"Getting Servers";
    ArcClient *tmp = [[ArcClient alloc] init];
    [tmp getListOfServers];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverListComplete:) name:@"getServerListNotification" object:nil];

    
}

-(void)serverListComplete:(NSNotification *)notification{
    
    
    @try {
        
        [self.loadingViewController stopSpin];
   
        
        NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];
        NSString *status = [responseInfo valueForKey:@"status"];
        NSDictionary *apiResponse = [responseInfo valueForKey:@"apiResponse"];
        
  
        NSLog(@"Results: %@", apiResponse);
        
        if ([status isEqualToString:@"success"]) {
            //success
            
            self.serverListArray = [apiResponse valueForKey:@"Results"];
            [self.myTableView reloadData];
            
        } else {
            // must be failure -- user notification handled by ArcClient
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Getting Servers" message:@"Dutch could not get the list of serveres at this time, please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
       
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"EditServer.merchantListComplete" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }


}




-(void)viewDidLoad{
    
    
    
    self.title = @"";
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = @"Edit Server";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.tintColor = dutchTopNavColor;
    
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];

    

    
    
    
    
    self.loadingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loadingView"];
    self.loadingViewController.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [self.loadingViewController stopSpin];
    [self.view addSubview:self.loadingViewController.view];
    
    self.serverListArray = [NSMutableArray array];
    
    self.topLineView.layer.shadowOffset = CGSizeMake(0, 1);
    self.topLineView.layer.shadowRadius = 1;
    self.topLineView.layer.shadowOpacity = 0.2;
    self.topLineView.backgroundColor = dutchTopLineColor;
    self.backView.backgroundColor = dutchTopNavColor;
    
    
    //CorbelTitleLabel *navLabel = [[CorbelTitleLabel alloc] initWithText:@"Edit Server"];
    //self.navigationItem.titleView = navLabel;
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setServerComplete:) name:@"setServerNotification" object:nil];
    
    ArcClient *tmp = [[ArcClient alloc] init];
    NSString *server = [tmp getCurrentUrl];
    
    if ([server rangeOfString:@"arc.dagher.mobi"].location != NSNotFound) {
        self.currentServer = 1;
    }else if ([server rangeOfString:@"arc.dagher.net.co"].location != NSNotFound){
        self.currentServer = 2;
    }else if ([server rangeOfString:@"dev.dagher.mobi"].location != NSNotFound){
        self.currentServer = 5;
    }else if (([server rangeOfString:@"dtnetwork"].location != NSNotFound) || ([server rangeOfString:@"68.57.205.193:8700"].location != NSNotFound)){
        self.currentServer = 8;
    }
    
    
    NVUIGradientButton *myButton = [[NVUIGradientButton alloc] initWithFrame:CGRectMake(0, 6, 60, 32)];
    myButton.text = @"Back";
    [myButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    
    self.navigationItem.leftBarButtonItem = homeButton;
    
    
    
   
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        
        NSUInteger row = [indexPath row];
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serverCell"];

        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *urlLabel = (UILabel *)[cell.contentView viewWithTag:3];

        UIImageView *checkImage = (UIImageView *)[cell.contentView viewWithTag:2];
        
        
        NSDictionary *serverDictionary = [self.serverListArray objectAtIndex:row];
        
        nameLabel.text = [serverDictionary valueForKey:@"Name"];
        urlLabel.text = [serverDictionary valueForKey:@"URL"];
        
        ArcClient *tmp = [[ArcClient alloc] init];
        NSString *server = [tmp getCurrentUrl];
        
        
        if ([server rangeOfString:urlLabel.text].location != NSNotFound) {
            checkImage.hidden = NO;
        }else{
            checkImage.hidden = YES;
        }

       /*
        checkImage.hidden = YES;
        if (row==0) {
            nameLabel.text = @"Production Cloud Server";
            if (self.currentServer == 1) {
                checkImage.hidden = NO;
            }
        }else if (row == 1){
            nameLabel.text = @"Backup Production Cloud Server";
            if (self.currentServer == 2) {
                checkImage.hidden = NO;
            }
        }else if (row == 2){
            nameLabel.text = @"Development Cloud Server";
            if (self.currentServer == 5) {
                checkImage.hidden = NO;
            }

        }else{
            nameLabel.text = @"Development Debug Server";
            if (self.currentServer == 8) {
                checkImage.hidden = NO;
            }

        }
        */
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"EditServerController.tableView" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSUInteger row = [indexPath row];
    if (!self.isCallingServer) {
        
        NSDictionary *serverDictionary = [self.serverListArray objectAtIndex:row];
        
        int sendInt = [[serverDictionary valueForKey:@"Id"] intValue];
        
        [self makeServerCallWithNumber:sendInt];
    }
 
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.serverListArray count];
}

-(void)makeServerCallWithNumber:(int)serverNumber{
    
    self.isCallingServer = YES;
    [self.loadingViewController startSpin];
    self.loadingViewController.displayText.text = @"Setting Server";
    ArcClient *tmp = [[ArcClient alloc] init];
    [tmp setServer:[NSString stringWithFormat:@"%d", serverNumber]];
}

-(void)setServerComplete:(NSNotification *)notification{
    @try {
        
        NSDictionary *responseInfo = [notification valueForKey:@"userInfo"];
        NSString *status = [responseInfo valueForKey:@"status"];
       // NSDictionary *apiResponse = [responseInfo valueForKey:@"apiResponse"];
        
        [self.loadingViewController stopSpin];
        self.isCallingServer = NO;
      
        
        if ([status isEqualToString:@"success"]) {
           
            ArcClient *tmp = [[ArcClient alloc] init];
            [tmp getServer];
            
            NSString *message = @"You are now pointing to the new server.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Server Failed" message:@"Failed to set server" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
    @catch (NSException *e) {
        [rSkybox sendClientLog:@"EditServerController.setServerComplete" logMessage:@"Exception Caught" logLevel:@"error" exception:e];
    }
}


- (void)viewDidUnload {
    [self setBackView:nil];
    [self setTopLineView:nil];
    [super viewDidUnload];
}
- (IBAction)goBackOne {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
