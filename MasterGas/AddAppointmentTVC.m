//
//  AddAppointmentTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 03/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "AddAppointmentTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACUsersHandler.h"


@interface AddAppointmentTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *appointment;

@end

@implementation AddAppointmentTVC

@synthesize commentsTextView;
@synthesize nameTextField;
@synthesize addressLine1TextField;
@synthesize addressLine2TextField;
@synthesize addressLine3TextField;
@synthesize postcodeTextField;
@synthesize telTextField;
@synthesize mobileNumberTextField;
@synthesize emailTextField;
@synthesize dateLabel;
@synthesize date;
@synthesize entityName;
@synthesize addAppointmentCompletionBlock;
@synthesize customerIdLabel;

@synthesize existingAppointment;

@synthesize originalCenter;
@synthesize managedObjectContext;
@synthesize appointment;



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
   
    if (self.existingAppointment == nil)
    {
        self.appointment = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    }
    else
    {
        //  self.managedObject = [context objectWithID:self.managedObjectId];
        
        self.appointment = self.existingAppointment;
        self.nameTextField.text = [self.appointment valueForKey:@"name"];
        self.addressLine1TextField.text = [self.appointment valueForKey:@"addressLine1"];
        self.addressLine2TextField.text = [self.appointment valueForKey:@"addressLine2"];
        self.addressLine3TextField.text = [self.appointment valueForKey:@"addressLine3"];
        self.postcodeTextField.text = [self.appointment valueForKey:@"postcode"];
        self.commentsTextView.text = [self.appointment valueForKey:@"notes"];
        self.telTextField.text = [self.appointment valueForKey:@"tel"];
        self.mobileNumberTextField.text = [self.appointment valueForKey:@"mobileNumber"];
        self.emailTextField.text = [self.appointment valueForKey:@"email"];
        self.callTypeLabel.text = [self.appointment valueForKey:@"callType"];
        self.customerIdLabel.text = [self.appointment valueForKey:@"customerId"];
        
        NSLog(@"customer no = %@", [self.appointment valueForKey:@"customerId"]);
        
        self.date = [self.appointment valueForKey:@"date"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm - d MMMM yyyy"];
     
        NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:[self.appointment valueForKey:@"date"]]];
        self.dateLabel.text = dateLabelString;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowDateTimeSelectionSegue"]) {

        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = self.date;
    }
    else if ([segue.identifier isEqualToString:@"ShowCustomersLookupSegue"]) {
        
        CustomerLookupTVC *customerLookupTVC = segue.destinationViewController;
        customerLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectCallTypeSegue"]) {
        CallTypeTVC *callTypeLookupTVC = segue.destinationViewController;
        callTypeLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"OnMyWaySegue"]) {
        OnMYWayLookupTVC *onMyWayLookupTVC = segue.destinationViewController;
        onMyWayLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"ShowSitesLookupSegue"]) {
        SiteLookupTVC *siteLookupTVC = segue.destinationViewController;
        siteLookupTVC.customerNo = self.customerIdLabel.text;
        siteLookupTVC.delegate = self;
    }

  
}





- (IBAction)saveButtonTouched:(id)sender {
    
    
    if (![self.nameTextField.text isEqualToString:@""]) {
        [self SaveAll];
        [self.navigationController popViewControllerAnimated:YES];
        addAppointmentCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Required Fields" message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}


-(void)SaveAll
{
    
    [self.appointment setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.appointment setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    [self.appointment setValue:[NSString checkForNilString:self.nameTextField.text] forKey:@"name"];
    [self.appointment setValue:[NSString checkForNilString:self.commentsTextView.text] forKey:@"notes"];
    [self.appointment setValue:[NSString checkForNilString:self.addressLine1TextField.text] forKey:@"addressLine1"];
    [self.appointment setValue:[NSString checkForNilString:self.addressLine2TextField.text] forKey:@"addressLine2"];
    [self.appointment setValue:[NSString checkForNilString:self.addressLine3TextField.text] forKey:@"addressLine3"];
    [self.appointment setValue:[NSString checkForNilString:self.postcodeTextField.text] forKey:@"postcode"];
    [self.appointment setValue:[NSString checkForNilString:self.telTextField.text] forKey:@"tel"];
    [self.appointment setValue:[NSString checkForNilString:self.mobileNumberTextField.text] forKey:@"mobileNumber"];
    [self.appointment setValue:[NSString checkForNilString:self.emailTextField.text] forKey:@"email"];
    [self.appointment setValue:[NSString checkForNilString:self.callTypeLabel.text] forKey:@"callType"];
    [self.appointment setValue:[NSString checkForNilString:self.customerIdLabel.text] forKey:@"customerId"];
    
    [self.appointment setValue:self.date forKey:@"date"];
    
    
    [self.appointment.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.appointment.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
    

}



#pragma Send SMS Methods
-(void)sendSMS:(NSString *)message
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = message;
            
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


- (void) theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller
{
    //set Date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm - d MMMM yyyy"];
    self.date = controller.inputDate;
    NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
    self.dateLabel.text = dateLabelString;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)theSiteWasSelectedFromTheList:(SiteLookupTVC *)controller
{
    self.addressLine1TextField.text = controller.selectedSite.addressLine1;
    self.addressLine2TextField.text = controller.selectedSite.addressLine2;
    self.addressLine3TextField.text = controller.selectedSite.addressLine3;
    self.postcodeTextField.text = controller.selectedSite.postcode;
    self.telTextField.text = controller.selectedSite.tel;
    self.mobileNumberTextField.text = controller.selectedSite.mobileNumber;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) theCustomerWasSelectedFromTheList:(CustomerLookupTVC *)controller
{
    self.nameTextField.text = controller.selectedCustomer.name;
    self.addressLine1TextField.text = controller.selectedCustomer.addressLine1;
    self.addressLine2TextField.text = controller.selectedCustomer.addressLine2;
    self.addressLine3TextField.text = controller.selectedCustomer.addressLine3;
    self.postcodeTextField.text = controller.selectedCustomer.postcode;
    self.telTextField.text = controller.selectedCustomer.tel;
    self.mobileNumberTextField.text = controller.selectedCustomer.mobileNumber;
    self.emailTextField.text = controller.selectedCustomer.email;
    self.customerIdLabel.text = controller.selectedCustomer.customerNo;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) theCallTypeWasSelectedFromTheList:(CallTypeTVC *)controller
{
    self.callTypeLabel.text = controller.selectedCallType.name;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theOnMyWayLookupWasSelectedFromTheList:(OnMYWayLookupTVC *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *name =  controller.selectedOnMyWayItem.name;
    
    if (name.length > 0) {
        [self sendSMS:name];
    }
    else
    {
        [self sendSMS:@""];
    }
    
  
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    if (![self.nameTextField.text isEqualToString:@""]) {
        [self SaveAll];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
