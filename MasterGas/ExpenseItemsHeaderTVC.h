//
//  ExpenseItemsHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 01/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseItem.h"
#import "ExpenseItemDetailTVC.h"
#import "MainWithTwoSubtitlesCell.h"

@interface ExpenseItemsHeaderTVC : UITableViewController

@property (nonatomic, strong) NSArray *expenseItems;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) NSString *uniqueClaimNumber;
@property (nonatomic, strong) ExpenseItem *selectedExpenseItem;

- (IBAction)refreshButtonTouched:(id)sender;

@end
