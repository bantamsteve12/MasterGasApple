//
//  ExpenseItemCategoryLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseItemCategory.h"
#import "MBProgressHUD.h"

@class ExpenseItemCategoryLookupTVC;

@protocol ExpenseItemCategoryLookupTVCDelegate <NSObject>
- (void)theExpenseItemCategoryWasSelectedFromTheList:(ExpenseItemCategoryLookupTVC *)controller;
@end


@interface ExpenseItemCategoryLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}



@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *expenseItemCategories;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) ExpenseItemCategory *selectedExpenseItemCategory;

- (IBAction)refreshButtonTouched:(id)sender;

@end
