//
//  EstimateDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 13/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "MBProgressHUD.h"
#import "InvoiceAddressDetailsTVC.h"
#import "EstimateTermsLookupTVC.h"
#import "LACUsersHandler.h"
#import "EstimateSiteAddressTVC.h"


@interface EstimateDetailTVC : UITableViewController <DatePickerTVCDelegate, MBProgressHUDDelegate, InvoiceAddressDetailsTVCDelegate, EstimateTermsLookupTVCDelegate, EstimateSiteAddressDetailsTVCDelegate> {
   	MBProgressHUD *HUD;
}


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (strong, nonatomic) IBOutlet UILabel *uniqueEstimateNoLabel;
@property (strong, nonatomic) IBOutlet UITextField *referenceTextField;
@property (strong, nonatomic) IBOutlet UITextField *workOrderReferenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerAddressPreviewLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *vatLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *siteAddressPreviewLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfExpenseItemsLabel;
@property (strong, nonatomic) IBOutlet UITextField *commentsTextField;

@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegmentControl;


@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);
@property (nonatomic, strong) NSMutableArray *estimateItems;


@end
