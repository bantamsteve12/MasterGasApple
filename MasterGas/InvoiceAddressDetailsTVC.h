//
//  InvoiceAddressDetailsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerLookupTVC.h"


@class InvoiceAddressDetailsTVC;

@protocol InvoiceAddressDetailsTVCDelegate <NSObject>
- (void)theSaveButtonPressedOnTheInvoiceAddressDetails:(InvoiceAddressDetailsTVC *)controller;
@end



@interface InvoiceAddressDetailsTVC : UITableViewController <CustomerLookupTVCDelegate>

@property (nonatomic, weak) id delegate;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextField *customerAddressName;
@property (strong, nonatomic) IBOutlet UITextField *customerAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *customerAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *customerAddressLine3;
@property (strong, nonatomic) IBOutlet UITextField *customerPostcode;
@property (strong, nonatomic) IBOutlet UITextField *customerTelNumber;
@property (strong, nonatomic) IBOutlet UITextField *customerMobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *customerEmailAddress;

@property (strong, nonatomic) IBOutlet UILabel *customerIdLabel;

@property (strong, nonatomic) NSString *entityName;

@end
