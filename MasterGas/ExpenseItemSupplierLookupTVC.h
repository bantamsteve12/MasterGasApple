//
//  ExpenseItemSupplierLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseItemSupplier.h"
#import "MBProgressHUD.h"

@class ExpenseItemSupplierLookupTVC;

@protocol ExpenseItemSupplierLookupTVCDelegate <NSObject>
- (void)theExpenseItemSupplierWasSelectedFromTheList:(ExpenseItemSupplierLookupTVC *)controller;
@end


@interface ExpenseItemSupplierLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}



@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *expenseItemSuppliers;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) ExpenseItemSupplier *selectedExpenseItemSupplier;

- (IBAction)refreshButtonTouched:(id)sender;

@end
