//
//  AddCustomerTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "AddCustomerTVC.h"
#import "SDCoreDataController.h"
#import "SitesTVC.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"

@interface AddCustomerTVC ()

@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *customer;
@end

@implementation AddCustomerTVC

@synthesize nameTextField;
@synthesize addressLine1TextField;
@synthesize addressLine2TextField;
@synthesize addressLine3TextField;
@synthesize postcodeTextField;
@synthesize telTextField;
@synthesize mobileNumberTextField;
@synthesize emailTextField;
@synthesize notesTextView;

@synthesize entityName;

@synthesize addDateCompletionBlock;

@synthesize originalCenter;
@synthesize managedObjectContext;
@synthesize customer;


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
    self.customer = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
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
        
        [self SaveAll];
        [self.navigationController popViewControllerAnimated:YES];
        addDateCompletionBlock();

    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Name Required" message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    } 
}


-(void)SaveAll
{
    if ([[self.customer valueForKey:@"customerNo"] length] < 1) {
          [self.customer setValue:[NSString stringWithFormat:@"CUST-%@", [NSString generateUniqueNumberIdentifier]]forKey:@"customerNo"];
    }
    
    [self.customer setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.customer setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    
    [self.customer setValue:[NSString checkForNilString:self.nameTextField.text] forKey:@"name"];
    [self.customer setValue:[NSString checkForNilString:self.addressLine1TextField.text] forKey:@"addressLine1"];
    [self.customer setValue:[NSString checkForNilString:self.addressLine2TextField.text] forKey:@"addressLine2"];
    [self.customer setValue:[NSString checkForNilString:self.addressLine3TextField.text] forKey:@"addressLine3"];
    [self.customer setValue:[NSString checkForNilString:self.postcodeTextField.text] forKey:@"postcode"];
    [self.customer setValue:[NSString checkForNilString:self.telTextField.text] forKey:@"tel"];
    [self.customer setValue:[NSString checkForNilString:self.mobileNumberTextField.text] forKey:@"mobileNumber"];
    [self.customer setValue:[NSString checkForNilString:self.emailTextField.text] forKey:@"email"];
    [self.customer setValue:[NSString checkForNilString:self.notesTextView.text] forKey:@"notes"];
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
    
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

    self.nameTextField.text = fullName;
    
    
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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ViewLinkedSitesSegue"]) {
        [self SaveAll];
        SitesTVC *sitesTVC = segue.destinationViewController;
        sitesTVC.customerNo = [self.customer valueForKey:@"customerNo"];
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
