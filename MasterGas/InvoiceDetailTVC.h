//
//  InvoiceDetail.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "MBProgressHUD.h"
#import "InvoiceAddressDetailsTVC.h"
#import "InvoiceTermsLookupTVC.h"
#import "LACUsersHandler.h"


@interface InvoiceDetailTVC : UITableViewController <DatePickerTVCDelegate, MBProgressHUDDelegate, InvoiceAddressDetailsTVCDelegate, InvoiceTermsLookupTVCDelegate> {
   	MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) IBOutlet UILabel *uniqueInvoiceNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerAddressPreviewLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *vatLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *paidLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceDueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfInvoiceItemsLabel;
@property (strong, nonatomic) IBOutlet UITextField *commentsTextField;

@property (strong, nonatomic) NSString *entityName;


@property (strong, nonatomic) void (^updateCompletionBlock)(void);

@property (nonatomic, strong) NSMutableArray *invoiceItems;


@end
