//
//  ExpenseItemTypeLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseItemType.h"
#import "MBProgressHUD.h"



@class ExpenseItemTypeLookupTVC;

@protocol ExpenseItemTypeLookupTVCDelegate <NSObject>
- (void)theExpenseItemTypeWasSelectedFromTheList:(ExpenseItemTypeLookupTVC *)controller;
@end

@interface ExpenseItemTypeLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *expenseItemTypes;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) ExpenseItemType *selectedExpenseItemType;

- (IBAction)refreshButtonTouched:(id)sender;

@end
