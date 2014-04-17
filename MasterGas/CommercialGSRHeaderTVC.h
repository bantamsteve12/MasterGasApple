//
//  CommercialGSRHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 19/02/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "PDFViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"

@interface CommercialGSRHeaderTVC : UITableViewController <DatePickerTVCDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;



//@property (strong, nonatomic) IBOutlet UITextField *certificateReferenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *certificateUniqueReferenceLabel;
@property (strong, nonatomic) IBOutlet UITextField *certificateReferenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *certificateDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *applianceInspectionCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *finalChecksCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerSignatureCompletionLabel;
@property (strong, nonatomic) IBOutlet UILabel *engineerSignoffCompletionLabel;

@property (strong, nonatomic) IBOutlet UILabel *applianceCountLabel;

@property (strong, nonatomic) NSString *certificatePrefix;
@property (strong, nonatomic) NSString *entityName;

//@property (strong, nonatomic) NSString *certificateType;
//@property (strong, nonatomic) IBOutlet UILabel *certificateTypeLabel;

@property (nonatomic, strong) NSArray *applianceItems;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end
