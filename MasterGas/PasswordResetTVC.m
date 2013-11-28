//
//  PasswordResetTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 27/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PasswordResetTVC.h"
#import "Reachability.h"
#import "SDCoreDataController.h"


@interface PasswordResetTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation PasswordResetTVC

@synthesize usernameTextField;

NSString *username;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}



-(IBAction)resetButtonPressed{
    
    Reachability* reachabilityServer = [Reachability reachabilityWithHostname:@"www.mastergas.co.uk"];
    NetworkStatus remoteHostStatus = [reachabilityServer currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        // show message
        UIAlertView *noInternet = [[UIAlertView alloc] initWithTitle: @"No Internet Connection"
                                                             message: @"Internet connection not currently available, please check your Wifi/3G settings and try again."
                                                            delegate: self
                                                   cancelButtonTitle: @"OK"
                                                   otherButtonTitles: nil];
        [noInternet show];
        
        
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSLog(@"login button pressed");
        NSDictionary *passwordResponse = [self passwordResetCall];
        
        NSString *result = [passwordResponse valueForKey:@"account"];
        
        if ([result isEqualToString:@"ResetSent"]) {
            
            [HUD hide:YES];
            
            // show message
            NSString *title;
            NSString *message;
            title = @"Reset Email Sent";
            message = @"Check your emails for your password reset.";
            UIAlertView *error = [[UIAlertView alloc] initWithTitle: title
                                                            message: message
                                                           delegate: self
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
         //   [error show];

            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            // decide which message to show.
            NSString *title;
            NSString *message;
            
            if([result isEqualToString:@"NoAccount"])
            {
                title = @"Account Details Not Recognised";
                message = @"Your account details were not recognised, please try again or if you have not setup an account please register or contact support.";
            }
            
            // show message
            UIAlertView *error = [[UIAlertView alloc] initWithTitle: title
                                                            message: message
                                                           delegate: self
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [error show];
            
            
        }
    }
    
    
}


-(NSDictionary *) passwordResetCall
{
    // calls login service on the server to login the phone.
    [self showHud];
    
    
    NSString *usernameField = self.usernameTextField.text;
   
    
    // if login ok then set values in user prefs
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *serviceLocationOne = @"http://www.mastergas.co.uk/paypal";
    NSString *serviceLocationTwo = [prefs objectForKey:@"serviceLocationTwo"];
    
    // check main server available, if not use back-up server
    Reachability* reachabilityServer = [Reachability reachabilityWithHostname:@"www.mastergas.co.uk"];
    NetworkStatus remoteHostStatus = [reachabilityServer currentReachabilityStatus];
    
    NSString *serverToUse;
    
    if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        serverToUse = serviceLocationOne;
    }
    else
    {
        serverToUse = serviceLocationTwo;
    }
    
    
    NSString *serviceCallPath = serverToUse;    // build up string with params
    serviceCallPath = [serviceCallPath stringByAppendingString:@"/forgotPasswordFromApp.php?email="];
    serviceCallPath = [serviceCallPath stringByAppendingString:usernameField];
  
    
    NSLog(@"serviceCallPath = %@",serviceCallPath);
    
	id response = [self objectWithUrl:[NSURL URLWithString:serviceCallPath]];
    
	NSDictionary *loginResponse = (NSDictionary *)response;
	return loginResponse;
    
    
    
}

-(NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:nil
                                            timeoutInterval:30];
    // Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}


-(id) objectWithUrl:(NSURL *)url
{
	SBJsonParser *jsonParser = [SBJsonParser new];
	NSString *jsonString = [self stringWithUrl:url];
    
	// Parse the JSON into an Object
	return [jsonParser objectWithString:jsonString error:NULL];
}

-(void)showHud
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Working...";
    
    [HUD show:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

