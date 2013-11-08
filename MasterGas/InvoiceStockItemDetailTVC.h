//
//  InvoiceStockItemDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 19/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockItem.h"
#import "LACUsersHandler.h"
#import "StockCategoryLookupTVC.h"

@interface InvoiceStockItemDetailTVC : UITableViewController <UITextFieldDelegate, StockCategoryLookupTVCDelegate>

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) StockItem *selectedInvoiceStockItem;

@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) IBOutlet UITextField *itemDescriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *unitPriceTextField;
@property (strong, nonatomic) IBOutlet UITextField *discountRateTextField;
@property (strong, nonatomic) IBOutlet UITextField *vatAmountTextField;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

//@property (copy, nonatomic) void (^updateCompletionBlock)(void);



@end
