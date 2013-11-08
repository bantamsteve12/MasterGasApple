//
//  InvoiceItemsHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceItem.h"
#import "InvoiceItemDetailTVC.h"
#import "MainWithTwoSubtitlesCell.h"
#import "LACUsersHandler.h"


@interface InvoiceItemsHeaderTVC : UITableViewController


@property (nonatomic, strong) NSArray *invoiceItems;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) NSString *invoiceUniqueNo;
@property (nonatomic, strong) InvoiceItem *selectedInvoiceItem;

- (IBAction)refreshButtonTouched:(id)sender;

@end
