//
//  SiteDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 30/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SiteDetailTVC.h"
#import "SDCoreDataController.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"


@interface SiteDetailTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *managedObject;

@property CGPoint originalCenter;
@end

@implementation SiteDetailTVC

@synthesize managedObjectId;

@synthesize nameTextField;
@synthesize addressLine1TextField;
@synthesize addressLine2TextField;
@synthesize addressLine3TextField;
@synthesize postcodeTextField;
@synthesize telTextField;
@synthesize mobileNumberTextField;
@synthesize emailTextField;
@synthesize notesTextView;

@synthesize customerContactSegment;

@synthesize entityName;
@synthesize addDateCompletionBlock;

@synthesize originalCenter;
@synthesize managedObjectContext;
@synthesize managedObject;

@synthesize currentSite;
@synthesize customerNo;

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
    
    // Do any additional setup after loading the view.
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
  
    if (self.currentSite == nil)
    {
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    }
    else
    {
      //  self.managedObject = self.currentSite;
        self.managedObject = [self.managedObjectContext objectWithID:self.managedObjectId];
        
        self.nameTextField.text = [self.managedObject valueForKey:@"name"];
        self.addressLine1TextField.text = [self.managedObject valueForKey:@"addressLine1"];
        self.addressLine2TextField.text = [self.managedObject valueForKey:@"addressLine2"];
        self.addressLine3TextField.text = [self.managedObject valueForKey:@"addressLine3"];
        self.postcodeTextField.text = [self.managedObject valueForKey:@"postcode"];
        self.telTextField.text = [self.managedObject valueForKey:@"tel"];
        self.mobileNumberTextField.text = [self.managedObject valueForKey:@"mobileNumber"];
        self.emailTextField.text = [self.managedObject valueForKey:@"email"];
        self.notesTextView.text = [self.managedObject valueForKey:@"notes"];
        
        NSLog(@"customer No: %@", [self.managedObject valueForKey:@"customerNo"]);
        NSLog(@"site No: %@", [self.managedObject valueForKey:@"siteReferenceNo"]);
        
    }

  
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
        
        [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
  //      [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
        
        [self.managedObject setValue:self.customerNo forKey:@"customerNo"];
        [self.managedObject setValue:[NSString stringWithFormat:@"SITE-%@", [NSString generateUniqueNumberIdentifier]]forKey:@"siteReferenceNo"];
        
        [self.managedObject setValue:[NSString checkForNilString:self.nameTextField.text] forKey:@"name"];
        [self.managedObject setValue:[NSString checkForNilString:self.addressLine1TextField.text] forKey:@"addressLine1"];
        [self.managedObject setValue:[NSString checkForNilString:self.addressLine2TextField.text] forKey:@"addressLine2"];
        [self.managedObject setValue:[NSString checkForNilString:self.addressLine3TextField.text] forKey:@"addressLine3"];
        [self.managedObject setValue:[NSString checkForNilString:self.postcodeTextField.text] forKey:@"postcode"];
        [self.managedObject setValue:[NSString checkForNilString:self.telTextField.text] forKey:@"tel"];
        [self.managedObject setValue:[NSString checkForNilString:self.mobileNumberTextField.text] forKey:@"mobileNumber"];
        [self.managedObject setValue:[NSString checkForNilString:self.emailTextField.text] forKey:@"email"];
        [self.managedObject setValue:[NSString checkForNilString:self.notesTextView.text] forKey:@"notes"];
        
        
        [self.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        addDateCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Name Required" message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == nameTextField) {
        [addressLine1TextField becomeFirstResponder];
        
    } else if(textField == addressLine1TextField) {
        [addressLine2TextField becomeFirstResponder];
    } else if(textField == addressLine1TextField) {
        [addressLine2TextField becomeFirstResponder];
    } else if(textField == addressLine2TextField) {
        [addressLine3TextField becomeFirstResponder];
    } else if(textField == addressLine3TextField) {
        [postcodeTextField becomeFirstResponder];
    } else if(textField == postcodeTextField) {
        [telTextField becomeFirstResponder];
    } else if(textField == telTextField) {
        [mobileNumberTextField becomeFirstResponder];
    } else if(textField == mobileNumberTextField) {
        [emailTextField becomeFirstResponder];
    } else if(textField == emailTextField) {
        [notesTextView becomeFirstResponder];
    }
    return NO;
}


- (IBAction) showPhoneBook: (id)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    
    
    NSString *firstName = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    
    NSString *lastname = (NSString *)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    NSString *fullName = @"";
    
    if ((firstName.length > 0) && (lastname.length > 0)) {
        fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastname];
    }
    else if ((firstName.length > 0) && (lastname.length < 1))
    {
        fullName = firstName;
    }
    else if ((firstName.length < 1) && (lastname.length > 0))
    {
        fullName = lastname;
    }
    
    self.nameTextField.text = firstName;
    
    // reset fields first
    self.mobileNumberTextField.text = @"";
    self.telTextField.text = @"";
    
    ABMutableMultiValueRef multi;
    int multiCount=0;
    multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    multiCount=ABMultiValueGetCount(multi);
    
    if (multiCount > 0) {
        
        for(int i=0; i < multiCount; i++)
        {   NSString *descriptionString = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(multi, i); NSString *theNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, i);
            
            NSLog(@"description; %@", descriptionString);
            
            if ([descriptionString isEqualToString:@"_$!<Home>!$_"]) {
                self.telTextField.text = theNumber;
            }
            else if ([descriptionString isEqualToString:@"_$!<Mobile>!$_"] || [descriptionString isEqualToString:@"iPhone"] ) {
                self.mobileNumberTextField.text = theNumber;
            }
        }
    }
    
    
    ABMutableMultiValueRef multiEmail;
    int multiEmailCount=0;
    multiEmail = ABRecordCopyValue(person, kABPersonEmailProperty);
    multiEmailCount=ABMultiValueGetCount(multiEmail);
    
    
    if (multiEmailCount > 0) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for(int i=0; i < multiEmailCount; i++)
        {
            NSString *theEmail = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiEmail, i);
            [array addObject:theEmail];
        }
        
        // if one email then put it in the text field
        if ([array count] == 1) {
            self.emailTextField.text = [array objectAtIndex:0];
        }
        else // ask the user to select the email
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Multiple Emails"
                                                         message:@"The contact has multiple emails. Which email would you like to assign?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:nil];
            
            // ObjC Fast Enumeration
            for (NSString *title in array) {
                [alert addButtonWithTitle:title];
            }
            
            alert.cancelButtonIndex = [array count];
            
            [alert show];
        }
    }
    else
    {
        self.emailTextField.text = @"";
    }
    
    
    
    ABMultiValueRef st = ABRecordCopyValue(person, kABPersonAddressProperty);
    if (ABMultiValueGetCount(st) > 0) {
        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(st, 0);
        
        NSString *street =  CFBridgingRelease(CFDictionaryGetValue(dict, kABPersonAddressStreetKey));
        
        NSArray *arr = [street componentsSeparatedByString:@"\n"];
        
        if ([arr count] > 0) {
            self.addressLine1TextField.text = [arr objectAtIndex:0];
        }
        
        if ([arr count] > 1) {
            self.addressLine2TextField.text = [arr objectAtIndex:1];
        }
        
        
        NSString *city = CFBridgingRelease(CFDictionaryGetValue(dict, kABPersonAddressCityKey));
        NSString *county = CFBridgingRelease(CFDictionaryGetValue(dict, kABPersonAddressStateKey));
        
        NSString *addressLineThree = @"";
        
        if ((city.length > 0) && (county.length > 0)) {
            addressLineThree = [NSString stringWithFormat:@"%@, %@", city, county];
        }
        else if ((city.length > 0) && (county.length < 1))
        {
            addressLineThree = city;
        }
        else if ((city.length < 1) && (county.length > 0))
        {
            addressLineThree = county;
        }
        
        
        self.addressLine3TextField.text = addressLineThree;
        
        self.postcodeTextField.text = CFBridgingRelease(CFDictionaryGetValue(dict, kABPersonAddressZIPKey));
        
    }
    else
    {
        self.addressLine1TextField.text = @"";
        self.addressLine2TextField.text = @"";
        self.addressLine3TextField.text = @"";
        self.postcodeTextField.text = @"";
    }
    
    
    
    
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    self.emailTextField.text = title;
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
