//
//  JobsheetHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "JobsheetPDFViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"
#import "JobstatusLookupTVC.h"


@interface JobsheetHeaderTVC : UITableViewController <DatePickerTVCDelegate, MBProgressHUDDelegate, JobstatusLookupTVCDelegate> {
	MBProgressHUD *HUD;
}


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;


//@property (strong, nonatomic) IBOutlet UITextField *certificateReferenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *uniqueReferenceLabel;
@property (strong, nonatomic) IBOutlet UITextField *referenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (strong, nonatomic) IBOutlet UITextField *hoursOnSiteTextField;
@property (strong, nonatomic) IBOutlet UILabel *jobStatusLabel;

@property (strong, nonatomic) IBOutlet UITextField *travelTimeTextField;


@property (strong, nonatomic) IBOutlet UILabel *addressCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerSignatureCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *engineerSignoffCompletionLabel;

@property (strong, nonatomic) NSString *certificatePrefix;
@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *applianceItems;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end
