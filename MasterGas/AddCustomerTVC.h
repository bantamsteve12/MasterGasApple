//
//  AddCustomerTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddCustomerTVC : UITableViewController <UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine3TextField;
@property (strong, nonatomic) IBOutlet UITextField *postcodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTextField;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextView  *notesTextView;
@property (strong, nonatomic) NSString *entityName;

@property (copy, nonatomic) void (^addDateCompletionBlock)(void);

- (IBAction)saveButtonTouched:(id)sender;

- (IBAction)showPhoneBook:(id)sender;

@end
