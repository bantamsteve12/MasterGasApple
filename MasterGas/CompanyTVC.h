//
//  CompanyTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import <Dropbox/Dropbox.h>
#import "GKImagePicker.h"
#import "LACFileHandler.h"


@interface CompanyTVC : UITableViewController <UIPopoverControllerDelegate, GKImagePickerDelegate>
{
    UIPopoverController *popoverController;
}


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
@property (strong, nonatomic) IBOutlet UITextField *standardCompanyVatAmount;
@property (strong, nonatomic) IBOutlet UITextField *companiesHouseCompanyNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *currencyTextField;


@property (strong, nonatomic) IBOutlet UIImageView *companyLogoImageView;
@property (strong, nonatomic) UIImage *rawCameraImage;
@property (nonatomic, strong) GKImagePicker *imagePicker;

@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *companyRecords;
@property (strong, nonatomic) void (^updateCompletionBlock)(void);

@property (nonatomic, retain) UIPopoverController *popoverController;

@end
