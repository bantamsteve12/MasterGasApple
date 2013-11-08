//
//  GasWarningHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 23/04/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "PDFViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"


@interface GasWarningHeaderTVC : UITableViewController <DatePickerTVCDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;


@property (strong, nonatomic) IBOutlet UILabel *uniqueReferenceLabel;
@property (strong, nonatomic) IBOutlet UITextField *userReferenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressCompletionLabel;

//@property (strong, nonatomic) IBOutlet UILabel *applianceInspectionCompletionLabel;
//@property (strong, nonatomic) IBOutlet UILabel *finalChecksCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerSignatureCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *engineerSignoffCompletionLabel;

@property (strong, nonatomic) NSString *prefix;
@property (strong, nonatomic) NSString *entityName;
//@property (strong, nonatomic) NSString *certificateType;
//@property (strong, nonatomic) IBOutlet UILabel *certificateTypeLabel;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end
