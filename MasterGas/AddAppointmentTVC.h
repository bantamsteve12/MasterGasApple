//
//  AddAppointmentTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 03/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "CustomerLookupTVC.h"
#import "CallTypeTVC.h"
#import "Appointment.h"
#import "NSString+Additions.h"
#import "SiteLookupTVC.h"

@interface AddAppointmentTVC : UITableViewController <DatePickerTVCDelegate, CustomerLookupTVCDelegate, CallTypeTVCDelegate, SiteLookupTVCDelegate>


@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *addressLine3TextField;
@property (strong, nonatomic) IBOutlet UITextField *postcodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;
@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *callTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerIdLabel;


@property (strong, nonatomic) Appointment *existingAppointment;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *entityName;
@property (copy, nonatomic) void (^addAppointmentCompletionBlock)(void);

- (IBAction)saveButtonTouched:(id)sender;

@end
