//
//  RegisterTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 28/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "LACHelperMethods.h"
#import "SBJson.h"
#import "MBProgressHUD.h"

@class Reachability;

@interface RegisterTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyAddressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *companyAddressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *companyAddressLine3TextField;
@property (strong, nonatomic) IBOutlet UITextField *companyPostcodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyTelTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyMobileNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyEmailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyGSRNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyVATRegNoTextField;


@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *companyRecords;
@property (strong, nonatomic) void (^updateCompletionBlock)(void);

@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)saveButtonTouched:(id)sender;
-(IBAction)dismissKeyboard:(id)sender;

@end
