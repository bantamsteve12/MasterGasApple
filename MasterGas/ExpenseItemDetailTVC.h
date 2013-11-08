//
//  ExpenseItemDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 01/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseItem.h"
#import "ExpenseItemTypeLookupTVC.h"
#import "ExpenseItemCategoryLookupTVC.h"
#import "ExpenseItemSupplierLookupTVC.h"
#import "DateTimePickerTVC.h"
#import "LACHelperMethods.h"

@interface ExpenseItemDetailTVC : UITableViewController <ExpenseItemTypeLookupTVCDelegate, ExpenseItemCategoryLookupTVCDelegate, ExpenseItemSupplierLookupTVCDelegate, DatePickerTVCDelegate>
@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) ExpenseItem *selectedExpenseItem;
@property (strong, nonatomic) NSString *uniqueClaimNo;

@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *typeTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UITextField *supplierTextField;
@property (strong, nonatomic) IBOutlet UITextField *subtotalAmountTextField;
@property (strong, nonatomic) IBOutlet UITextField *vatAmountTextField;
@property (strong, nonatomic) IBOutlet UITextField *totalAmountTextField;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *vatLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;



@property (strong, nonatomic) NSString *supplierId;

@property (copy, nonatomic) void (^updateCompletionBlock)(void);



@end
