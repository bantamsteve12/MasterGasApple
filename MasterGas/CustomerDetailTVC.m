//
//  CustomerDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "CustomerDetailTVC.h"
#import "SDCoreDataController.h"
#import "Customer.h"
#import "NSString+Additions.h"
#import "PaymentsTVC.h"
#import "InvoicesTVC.h"
#import "JobSheetsTVC.h"
#import "AppointmentTVC.h"
#import "CertificateSelectorTVC.h"
#import "SitesTVC.h"

@interface CustomerDetailTVC ()

@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObject *managedObject;

@end

@implementation CustomerDetailTVC


@synthesize nameTextField;
@synthesize addressLine1TextField;
@synthesize addressLine2TextField;
@synthesize addressLine3TextField;
@synthesize postcodeTextField;
@synthesize telTextField;
@synthesize mobileNumberTextField;
@synthesize emailTextField;
@synthesize notesTextView;

@synthesize context;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize customerContactSegment;

@synthesize updateCustomerCompletionBlock;


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
   
    self.context = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.managedObject = [context objectWithID:self.managedObjectId];
    
    self.nameTextField.text = [self.managedObject valueForKey:@"name"];
    self.addressLine1TextField.text = [self.managedObject valueForKey:@"addressLine1"];
    self.addressLine2TextField.text = [self.managedObject valueForKey:@"addressLine2"];
    self.addressLine3TextField.text = [self.managedObject valueForKey:@"addressLine3"];
    self.postcodeTextField.text = [self.managedObject valueForKey:@"postcode"];
    self.telTextField.text = [self.managedObject valueForKey:@"tel"];
    self.mobileNumberTextField.text = [self.managedObject valueForKey:@"mobileNumber"];
    
    self.emailTextField.text = [self.managedObject valueForKey:@"email"];
    self.notesTextView.text = [self.managedObject valueForKey:@"notes"];

    NSLog(@"customerNo %@", [self.managedObject valueForKey:@"customerNo"]);

}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


- (IBAction)saveButtonTouched:(id)sender {
    
  
    if (![self.nameTextField.text isEqualToString:@""]) {
        
        [self.managedObject setValue:[NSString checkForNilString:self.nameTextField.text] forKey:@"name"];
        [self.managedObject setValue:[NSString checkForNilString:self.addressLine1TextField.text] forKey:@"addressLine1"];
        [self.managedObject setValue:[NSString checkForNilString:self.addressLine2TextField.text] forKey:@"addressLine2"];
        [self.managedObject setValue:[NSString checkForNilString:self.addressLine3TextField.text] forKey:@"addressLine3"];
        [self.managedObject setValue:[NSString checkForNilString:self.postcodeTextField.text] forKey:@"postcode"];
        [self.managedObject setValue:[NSString checkForNilString:self.telTextField.text] forKey:@"tel"];
        [self.managedObject setValue:[NSString checkForNilString:self.mobileNumberTextField.text] forKey:@"mobileNumber"];
        [self.managedObject setValue:[NSString checkForNilString:self.emailTextField.text] forKey:@"email"];
        [self.managedObject setValue:[NSString checkForNilString:self.notesTextView.text] forKey:@"notes"];

        
        [self.context performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.context save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        updateCustomerCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Uh oh..." message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"Duh" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}


- (IBAction)customerContactSegmentPressed:(id)sender
{
    if (customerContactSegment.selectedSegmentIndex == 0) {
       
        [self sendSMS];
        
    }
    else if (customerContactSegment.selectedSegmentIndex == 1) {
    
        // Call telephone
        UIDevice *device = [UIDevice currentDevice];
        if ([[device model] isEqualToString:@"iPhone"] ) {
            
         
            if ((telTextField.text.length > 0) && (mobileNumberTextField.text.length > 0)) {
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"Which number would you like to call?"
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:self.telTextField.text, self.mobileNumberTextField.text
                                          ,nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showFromToolbar:self.tabBarController.tabBar];
         
            }
            else if (telTextField.text.length > 0)
            {
                [self callPhone:self.telTextField.text];
                
            }
            else if(mobileNumberTextField.text.length > 0)
            {
                [self callPhone:self.mobileNumberTextField.text];
            }
            else
            {
                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"A valid number is not entered in the telephone or mobile number field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Notpermitted show];
            }
            
               }
        else {
            UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Notpermitted show];
        }
        
    }
    else if (customerContactSegment.selectedSegmentIndex == 2)
    {
        // Send email
        [self showComposer:self];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	//Telephone
	if(buttonIndex == 0){
        [self callPhone:self.telTextField.text];
	}
	
	//Mobile
	if (buttonIndex == 1){
        [self callPhone:self.mobileNumberTextField.text];
	}
	else
	{
	}
}



-(void)callPhone:(NSString *)phoneNumber
{
  
    if (phoneNumber.length > 0) {
        
        // strip out any non numbers.
        NSMutableString *strippedStringTel = [NSMutableString
                                              stringWithCapacity:phoneNumber.length];
        
        NSScanner *scanner = [NSScanner scannerWithString:phoneNumber];
        NSCharacterSet *numbers = [NSCharacterSet
                                   characterSetWithCharactersInString:@"0123456789"];
        
        while ([scanner isAtEnd] == NO) {
            NSString *buffer;
            if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                [strippedStringTel appendString:buffer];
            } else {
                [scanner setScanLocation:([scanner scanLocation] + 1)];
            }
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", strippedStringTel]]];
        
    }
    else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"A valid number is not entered in the telephone or mobile number field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    

}



#pragma Send SMS Methods
-(void)sendSMS
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {

    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";
        
        if (self.mobileNumberTextField.text.length > 0) {
            
            NSString *telNo = self.mobileNumberTextField.text;
            
            // strip out any non numbers.
            NSMutableString *strippedStringTel = [NSMutableString
                                                  stringWithCapacity:telNo.length];
            
            NSScanner *scanner = [NSScanner scannerWithString:telNo];
            NSCharacterSet *numbers = [NSCharacterSet
                                       characterSetWithCharactersInString:@"0123456789"];
            
            while ([scanner isAtEnd] == NO) {
                NSString *buffer;
                if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                    [strippedStringTel appendString:buffer];
                } else {
                    [scanner setScanLocation:([scanner scanLocation] + 1)];
                }
            }
            
            controller.recipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.mobileNumberTextField.text], nil];
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
        }
        else
        {
            UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"A valid number is not entered in the mobile number field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Notpermitted show];
        }
     
      }
    }
    else
    {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma Mail Methods

// Launches the Mail application on the device. Workaround
-(void)launchMailAppOnDevice:(NSString *)body{
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@", self.emailTextField.text, @""];
	NSString *mailBody = [NSString stringWithFormat:@"&body=%@", body];
    
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, mailBody];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// Call this method and pass parameters
-(void) showComposer:(id)sender{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
        [self launchMailAppOnDevice:sender];
	}
    else
    {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support the email feature. Please try setting up your emails in the Settings App on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ViewPaymentsForCustomerSegue"]) {
        PaymentsTVC *paymentsTVC = segue.destinationViewController;
        paymentsTVC.customerId = [self.managedObject valueForKey:@"customerNo"];
    }
    else if ([segue.identifier isEqualToString:@"ViewInvoicesForCustomerSegue"]) {
        InvoicesTVC *invoicesTVC = segue.destinationViewController;
        invoicesTVC.customerId = [self.managedObject valueForKey:@"customerNo"];
        invoicesTVC.limited = YES;
        
    }
    else if ([segue.identifier isEqualToString:@"ViewCustomerJobsheetsSegue"]) {
        JobSheetsTVC *jobsheetsTVC = segue.destinationViewController;
        jobsheetsTVC.customerId = [self.managedObject valueForKey:@"customerNo"];
        jobsheetsTVC.limited = YES;
        
    }
    else if ([segue.identifier isEqualToString:@"ViewDiaryAppointmentsHistorySegue"]) {
        AppointmentTVC *appointmentsTVC = segue.destinationViewController;
        appointmentsTVC.customerId = [self.managedObject valueForKey:@"customerNo"];
        appointmentsTVC.limited = YES;
        
    }
    else if ([segue.identifier isEqualToString:@"ViewCertificateHistorySegue"]) {
        CertificateSelectorTVC *certificateSelectorTVC = segue.destinationViewController;
        certificateSelectorTVC.customerId = [self.managedObject valueForKey:@"customerNo"];
     //   certificateSelectorTVC.limited = YES;
        
    }
    else if ([segue.identifier isEqualToString:@"ViewLinkedSitesSegue"]) {
        SitesTVC *sitesTVC = segue.destinationViewController;
        sitesTVC.customerNo = [self.managedObject valueForKey:@"customerNo"];
    }
    
    
    
 }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
