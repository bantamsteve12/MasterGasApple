//
//  SetupStepTwoTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import <Dropbox/Dropbox.h>
#import "LACFileHandler.h"
#import "GKImagePicker.h"

@interface SetupStepTwoTVC : UITableViewController <UIPopoverControllerDelegate, GKImagePickerDelegate>
{
    UIPopoverController *popoverController;
}


@property (strong, nonatomic) IBOutlet UITextField *companyGSRNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyVATRegNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *companiesHouseCompanyNumberTextField;

@property (strong, nonatomic) IBOutlet UIImageView *companyLogoImageView;
@property (strong, nonatomic) UIImage *rawCameraImage;

@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *companyRecords;
@property (strong, nonatomic) void (^updateCompletionBlock)(void);

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, strong) GKImagePicker *imagePicker;


-(IBAction)setCompanyLogo:(id)sender;

@end
