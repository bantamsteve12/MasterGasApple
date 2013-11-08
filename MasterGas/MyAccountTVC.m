//
//  MyAccountTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 01/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MyAccountTVC.h"
#import "Reachability.h"
#import "SDCoreDataController.h"


@interface MyAccountTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation MyAccountTVC

@synthesize usernameLabel;
@synthesize subscriptionTypeLabel;
@synthesize subscriptionExpiryLabel;


NSString *username;
NSString *password;
NSString *timeStamp;


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
    // get username and password from the NSUSerDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    username = [prefs objectForKey:@"Username"];
    password = [prefs objectForKey:@"Password"];
    [super viewDidLoad];
    }

-(void)viewWillAppear:(BOOL)animated
{
    [self setLabelValues];
}


-(void)setLabelValues
{
    self.usernameLabel.text = username;
    
    
    if ([LACHelperMethods fullUser]) {
        self.subscriptionTypeLabel.text = @"Pro User";
    }
    else
    {
        self.subscriptionTypeLabel.text = @"Basic User";
    }

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   
    int *timeStamp = [[prefs valueForKey:@"timeStamp"] intValue];
    
    if (timeStamp > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[prefs valueForKey:@"timeStamp"] intValue]];
                        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"d/MM/yyyy"];
        self.subscriptionExpiryLabel.text = [NSString stringWithFormat:@"%@",
                                                             [df stringFromDate:date]];
    }
    else
    {
        self.subscriptionExpiryLabel.text = @"Expired";
    }
  

}


-(IBAction)visitWebsiteButtonPressed{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mastergas.co.uk"]];
}

-(IBAction)refreshButtonPressed{
   
   
    
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
            NSDictionary *loginResponse = [self loginServiceCall];
            NSLog(@"Url feed: %@", [loginResponse valueForKey:@"account"]);
            
            NSString *loginResult = [loginResponse valueForKey:@"account"];
            
            NSString *exp = [loginResponse valueForKey:@"exp"];
            NSLog(@"exp response: %@", exp);
            
            timeStamp = exp;
            
            if ([loginResult isEqualToString:@"ValidUser"]) {
                NSLog(@"Login result is a valid user");
                
                // save timestamp
                [prefs setObject:exp forKey:@"timeStamp"];
                [prefs synchronize];
                
                
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[exp intValue]];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"d/MM/yyyy"];
                self.subscriptionExpiryLabel.text = [NSString stringWithFormat:@"%@",
                                                     [df stringFromDate:date]];

                
                if ([LACHelperMethods fullUser]) {
                    self.subscriptionTypeLabel.text = @"Pro User";
                }
                else
                {
                    self.subscriptionTypeLabel.text = @"Basic User";
                }
                
                if ([timeStamp intValue] > 0) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[prefs valueForKey:@"timeStamp"] intValue]];
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"d/MM/yyyy"];
                    self.subscriptionExpiryLabel.text = [NSString stringWithFormat:@"%@",
                                                         [df stringFromDate:date]];
                }
                else
                {
                    self.subscriptionExpiryLabel.text = @"Expired";
                }
                                
                [HUD hide:YES];
             
            }
            else
            {
                // decide which message to show.
                NSString *title;
                NSString *message;
                
                if([loginResult isEqualToString:@"NoAccount"])
                {
                    title = @"Account Details Not Recognised";
                    message = @"Your account details were not recognised, please try again or if you have not setup an account please register";
                }
                else if([loginResult isEqualToString:@"PasswordIncorrect"])
                {
                    title = @"Password Incorrect";
                    message = @"The password you entered is incorrect, please try again or use the forgot password option";
                }
                else if([loginResult isEqualToString:@"NotRegisteredForThisDevice"])
                {
                    title = @"Device Not Registered";
                    message = @"Your account is not registered for this device, if you would like to us the service on this device please purchase a subscription for this device";
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


-(NSDictionary *) loginServiceCall
{
    // calls login service on the server to login the phone.
    [self showHud];
    
    
    NSString *usernameField = username;
    NSString *passwordField = password;
    
    
    // if login ok then set values in user prefs
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // NSString *serviceLocationOne = [prefs objectForKey:@"serviceLocationOne"];
    
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
    
    // hash password
    NSString *hashPassword = [LACHelperMethods returnMD5Hash:passwordField];
    
    NSString *serviceCallPath = serverToUse;    // build up string with params
    serviceCallPath = [serviceCallPath stringByAppendingString:@"/deviceLogin.php?email="];
    serviceCallPath = [serviceCallPath stringByAppendingString:usernameField];
    serviceCallPath = [serviceCallPath stringByAppendingString:@"&password="];
    serviceCallPath = [serviceCallPath stringByAppendingString:hashPassword];
    
    
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
	HUD.labelText = @"Checking Account";
    
    [HUD show:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
