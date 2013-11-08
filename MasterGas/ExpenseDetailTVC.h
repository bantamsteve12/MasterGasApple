//
//  ExpenseDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 31/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "MBProgressHUD.h"
#import "EngineerLookupTVC.h"

@interface ExpenseDetailTVC : UITableViewController <EngineerLookupTVCDelegate, DatePickerTVCDelegate, MBProgressHUDDelegate> {
   	MBProgressHUD *HUD; 
}

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;


@property (strong, nonatomic) IBOutlet UILabel *uniqueClaimReferenceLabel;
@property (strong, nonatomic) IBOutlet UITextField *referenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *expenseClaimDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *engineerNameLabel;

@property (strong, nonatomic) NSString *entityName;


@property (strong, nonatomic) void (^updateCompletionBlock)(void);




@end
