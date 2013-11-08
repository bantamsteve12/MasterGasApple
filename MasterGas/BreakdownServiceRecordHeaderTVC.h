//
//  BreakdownServiceRecordHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 17/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
//#import "PDFViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"


@interface BreakdownServiceRecordHeaderTVC : UITableViewController<DatePickerTVCDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) IBOutlet UILabel *uniqueReferenceLabel;
@property (strong, nonatomic) IBOutlet UITextField *referenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *applianceCompletionDetailsLabel;
@property (strong, nonatomic) IBOutlet UILabel *applianceCompletionChecksLabel;
@property (strong, nonatomic) IBOutlet UILabel *faultActionsCompletionRemedialLabel;
@property (strong, nonatomic) IBOutlet UILabel *additionalCompletionNotesSparesLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerSignatureCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *engineerSignoffCompletionLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *jobTypeSegmentControl;

@property (strong, nonatomic) NSString *recordPrefix;
@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *recordType;
@property (strong, nonatomic) IBOutlet UILabel *recordTypeLabel;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end
