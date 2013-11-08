//
//  InvoicePaymentTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"
#import "Invoice.h"
#import "PaymentTypeLookupTVC.h"


@interface InvoicePaymentTVC : UITableViewController<DatePickerTVCDelegate, MBProgressHUDDelegate, PaymentTypeLookupTVCDelegate> {
	MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *managedObject;
@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) Invoice *invoice;

@property (strong, nonatomic) IBOutlet UILabel *uniqueReferenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *invoiceTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *previouslyPaidLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceDueLabel;
@property (strong, nonatomic) IBOutlet UILabel *updatedBalanceLabel;

@property (strong, nonatomic) IBOutlet UITextField *currentPaymentAmountTextField;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;

@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


- (IBAction)payWithPaylevenPressed:(id)sender;

@end
