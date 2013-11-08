//
//  ContactTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 06/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ContactTVC.h"
#import "Reachability.h"
#import "SDCoreDataController.h"

@interface ContactTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation ContactTVC

@synthesize usernameLabel;
@synthesize deviceTypeLabel;
@synthesize nameTextField;
@synthesize contactNumberTextField;
@synthesize subjectTextField;
@synthesize messageTextTextView;


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
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    // get username and password from the NSUSerDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    username = [prefs objectForKey:@"Username"];
    self.deviceTypeLabel.text =  [UIDevice currentDevice].model;
    
    // get device type
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setLabelValues];
}

- (void)dismissKeyboard {
    NSLog(@"dismiss keyboard called");
    [self.view endEditing:TRUE];
}


-(void)setLabelValues
{
    self.usernameLabel.text = username;
    
    
    
}


-(IBAction)sendButtonPressed{
    
    
    
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
        if (self.messageTextTextView.text.length < 1 ||
            self.contactNumberTextField.text.length < 1 ||
            self.subjectTextField.text.length < 1 ||
            self.nameTextField.text.length < 1) {
           
            // show message
            UIAlertView *msg = [[UIAlertView alloc] initWithTitle: @"Details required"
                                                                 message: @"Please fill out the details before submitting."
                                                                delegate: self
                                                       cancelButtonTitle: @"OK"
                                                       otherButtonTitles: nil];
            [msg show];
            

        }
        else
        {
        
            [self showHud];

            
            NSDictionary *serviceResponse = [self serviceCall];
            NSString *serviceResult = [serviceResponse valueForKey:@"response"];
        
        
            // decide which message to show.
            NSString *title;
            NSString *message;
            
            if([serviceResult isEqualToString:@"Sent"])
            {
                title = @"Request Sent";
                message = @"Your request was sent successfully. We will respond soon.";
            }
            else
            {
                title = @"Error";
                message = @"Your message could not be sent at this time, please try again or visit our website to contact us.";
            }
        
        [HUD hide:YES];
        
        self.nameTextField.text = @"";
        self.contactNumberTextField.text = @"";
        self.subjectTextField.text = @"";
        self.messageTextTextView.text = @"";
        
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



-(NSDictionary *) serviceCall
{
    // calls login service on the server to login the phone.

    NSString *usernameField = username;
    NSString *subject = @"";
    NSString *text = @"";
    
    
    if(self.subjectTextField.text.length > 0)
    {
        subject = self.subjectTextField.text;
    }
    
    if (self.messageTextTextView.text.length > 0) {
    
        text = [NSString stringWithFormat:@"Device Type:%@  Name:%@ Contact Number:%@ Message: %@", self.deviceTypeLabel.text, self.nameTextField.text, self.contactNumberTextField.text, self.messageTextTextView.text];
        
    }
      
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
    

    
    NSString *base = [NSString stringWithFormat:@"%@%@",serverToUse, @"/messageSupport.php?username="];
    base = [base stringByAppendingString:usernameField];
    base = [base stringByAppendingString:@"&subject="];
    base = [base stringByAppendingString:subject];
    base = [base stringByAppendingString:@"&text="];
    base = [base stringByAppendingString:text];
    
    NSURL *sendToServer = [NSURL URLWithString: [base
 stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
     NSLog(@"serviceCallPath = %@",sendToServer);
    
   id response = [self objectWithUrl:sendToServer];
    
    
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
	HUD.labelText = @"Sending Message";
    
    [HUD show:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
