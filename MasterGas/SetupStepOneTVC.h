//
//  SetupStepOneTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import <Dropbox/Dropbox.h>

@interface SetupStepOneTVC : UITableViewController



@property (strong, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyAddressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *companyAddressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *companyAddressLine3TextField;
@property (strong, nonatomic) IBOutlet UITextField *companyPostcodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyTelTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyMobileNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyEmailAddressTextField;

@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *companyRecords;
@property (strong, nonatomic) void (^updateCompletionBlock)(void);


- (IBAction)nextButtonTouched:(id)sender;

@end
