//
//  SiteDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "Sites.h"


@interface SiteDetailTVC : UITableViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;


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
@property (strong, nonatomic) Sites *currentSite;

@property (strong, nonatomic) IBOutlet UISegmentedControl *customerContactSegment;

@property (copy, nonatomic) void (^addDateCompletionBlock)(void);

@property (strong, nonatomic) NSString *customerNo;

- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)showPhoneBook:(id)sender;

@end
