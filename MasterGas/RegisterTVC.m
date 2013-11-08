//
//  RegisterTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 28/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "RegisterTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "NSString+Additions.h"

@interface RegisterTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation RegisterTVC

@synthesize entityName;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize companyNameTextField;
@synthesize companyAddressLine1TextField;
@synthesize companyAddressLine2TextField;
@synthesize companyAddressLine3TextField;
@synthesize companyPostcodeTextField;
@synthesize companyTelTextField;
@synthesize companyMobileNumberTextField;
@synthesize companyEmailAddressTextField;
@synthesize companyGSRNumberTextField;
@synthesize companyVATRegNoTextField;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize companyRecords;
@synthesize updateCompletionBlock;

@synthesize activityIndicator;

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
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
     self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];

    [self.managedObject setValue:[NSString generateUniqueIdentifier] forKey:@"companyId"];
 
    [[SDSyncEngine sharedEngine] startSync];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //  self.originalCenter = self.view.center;
}


-(IBAction)cancelButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)generatingHUD:(id)data
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Registering...";
    [HUD show:YES];
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [usernameTextField becomeFirstResponder];
    [usernameTextField resignFirstResponder];
    
    [passwordTextField resignFirstResponder];
    [firstNameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    
}

-(BOOL) validEmail:(NSString*) emailString {
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}


- (IBAction)saveButtonTouched:(id)sender {
    

    
    NSString *emailValue = self.usernameTextField.text;
    NSString *passwordValue = self.passwordTextField.text;
    NSString *firstnamevalue = self.firstNameTextField.text;
    NSString *lastnameValue = self.lastNameTextField.text;
    
    
    int emailFormatErrorCount = 0;
    
    if(![self validEmail:emailValue]) {
        emailFormatErrorCount = emailFormatErrorCount+1;
    }
    else
    {
        emailFormatErrorCount = 0;
    }
    
    if(emailFormatErrorCount > 0)
    {
        
        emailFormatErrorCount = 0;
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle: @"Valid Email Required"
                                                        message: @"Please enter a valid email address"
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [error show];
        
        
    }
    else
    {
        
        int requiredFieldsErrorCount =0;
        if ([emailValue length] < 1 ) {
            requiredFieldsErrorCount = requiredFieldsErrorCount+1;
        }
        
        if ([passwordValue length] < 1) {
            requiredFieldsErrorCount = requiredFieldsErrorCount+1;
        }
        
        if ([firstnamevalue length] < 1) {
            requiredFieldsErrorCount = requiredFieldsErrorCount+1;
        }
        
        if ([lastnameValue length] < 1) {
            requiredFieldsErrorCount = requiredFieldsErrorCount+1;
        }
        
      
        if (requiredFieldsErrorCount < 1) {
            
            // check main server available, if not use back-up server
            Reachability* reachabilityServer = [Reachability reachabilityWithHostname:@"www.mastergas.co.uk"];
            NetworkStatus serverStatus = [reachabilityServer currentReachabilityStatus];
            
            if (serverStatus == NotReachable) {
                // show message
                UIAlertView *internetNotAvailable = [[UIAlertView alloc] initWithTitle: @"Internet Not Available"
                                                                               message: @"The internet is not available, please check your connection and try again."
                                                                              delegate: self
                                                                     cancelButtonTitle: @"OK"
                                                                     otherButtonTitles: nil];
                [internetNotAvailable show];
                
            }
            else
            {
    
                [self.lastNameTextField resignFirstResponder];
    
                [NSThread detachNewThreadSelector:@selector(generatingHUD:) toTarget:self withObject:nil];
    
    
                NSDictionary *newUserResponse = [self newUserServiceCall];

                NSLog(@"newUserResponse: %@", [newUserResponse valueForKey:@"subscription"]);
    
                // if registration ok
                if ([[newUserResponse valueForKey:@"subscription"] isEqualToString:@"RegisteredOK"]) {
        
                    // save username and password
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:usernameTextField.text forKey:@"Username"];
                    [prefs setObject:passwordTextField.text forKey:@"Password"];
                    [prefs setBool:YES forKey:@"loggedIn"];
                    [prefs setBool:YES forKey:@"NewRegistration"];
                    [prefs setBool:NO forKey:@"SetupComplete"];
                    [prefs synchronize];
                    
                
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.labelText = @"Registered";
                    sleep(2);
                    [HUD hide:YES];
        
                    [self dismissModalViewControllerAnimated:YES];
        
                    }
                    else if ([[newUserResponse valueForKey:@"subscription"] isEqualToString:@"AccountExists"])
                    {
        
                        // show message
                        UIAlertView *regAccountExists = [[UIAlertView alloc] initWithTitle: @"Account Already Exists"
                                                                   message: @"Sorry, the email address you entered is already registered. If this is your email address please use the forgotten password option on the login screen."
                                                                  delegate: self
                                                         cancelButtonTitle: @"OK"
                                                         otherButtonTitles: nil];
                        [regAccountExists show];
       
                        [HUD hide:YES];
                    }
            }
        }
        else
        {
            
            // show message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"All fields are required"
                                                                       message: @"Please fill out all the fields and try again."
                                                                      delegate: self
                                                             cancelButtonTitle: @"OK"
                                                             otherButtonTitles: nil];
            [alert show];
            
            [HUD hide:YES];

        }
    }
    
}



-(NSDictionary *) newUserServiceCall
{
    NSLog(@"newUserServiceCall called");
    
    // calls login service on the server to login the phone.
    
    NSString *usernameField = usernameTextField.text;
    NSString *passwordField = passwordTextField.text;
    
    // if login ok then set values in user prefs
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // check main server available, if not use back-up server
    Reachability* reachabilityServer = [Reachability reachabilityWithHostname:@"www.mastergas.co.uk"];
    NetworkStatus serverStatus = [reachabilityServer currentReachabilityStatus];
    
    NSString *serverToUse;
    
  /*  if (serverStatus == ReachableViaWiFi || serverStatus == ReachableViaWWAN) {
        serverToUse = serviceLocationOne;
    }
    else
    {
        serverToUse = serviceLocationTwo;
    }*/
    
    serverToUse = @"http://www.mastergas.co.uk/paypal";
    
    // hash password
    NSString *hashPassword = [LACHelperMethods returnMD5Hash:passwordField];
   
    
    // build up string to call service may be abe to improve in the future with params?
    NSString *serviceCallPath = serverToUse;
    serviceCallPath = [serviceCallPath stringByAppendingString:@"/newUser.php?email="];
    serviceCallPath = [serviceCallPath stringByAppendingString:usernameTextField.text];
    serviceCallPath = [serviceCallPath stringByAppendingString:@"&password="];
    serviceCallPath = [serviceCallPath stringByAppendingString:hashPassword];
    serviceCallPath = [serviceCallPath stringByAppendingString:@"&firstname="];
    serviceCallPath = [serviceCallPath stringByAppendingString:firstNameTextField.text];
    serviceCallPath = [serviceCallPath stringByAppendingString:@"&lastname="];
    serviceCallPath = [serviceCallPath stringByAppendingString:lastNameTextField.text];
  
    NSString *encodedServiceCallPath = [serviceCallPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
     NSLog(@"encodedServiceCallPath %@", encodedServiceCallPath);
    
	id response = [self objectWithUrl:[NSURL URLWithString:encodedServiceCallPath]];
    
	NSDictionary *newUserResponse = (NSDictionary *)response;
	return newUserResponse;
}

-(id) objectWithUrl:(NSURL *)url
{
	SBJsonParser *jsonParser = [SBJsonParser new];
	NSString *jsonString = [self stringWithUrl:url];
    
    NSLog(@"jsonString = %@", jsonString);
    
	// Parse the JSON into an Object
	return [jsonParser objectWithString:jsonString error:NULL];
}


- (void)dismissKeyboard {
    NSLog(@"dismiss keyboard called");
    [self.view endEditing:TRUE];
}


-(NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
   
    NSLog(@"response code: = %@", response);
    
    
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
