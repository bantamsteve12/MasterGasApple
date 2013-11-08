//
//  CustomerDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface CustomerDetailTVC : UITableViewController <MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine3TextField;
@property (strong, nonatomic) IBOutlet UITextField *postcodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *customerContactSegment;


@property (copy, nonatomic) void (^updateCustomerCompletionBlock)(void);

@end
