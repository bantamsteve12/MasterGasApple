//
//  EstimateItemDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstimateItem.h"
#import "StockItemLookupTVC.h"

#import "LACUsersHandler.h"


@interface EstimateItemDetailTVC : UITableViewController <UITextFieldDelegate, StockItemLookupTVCDelegate>

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) EstimateItem *selectedEstimateItem;
@property (strong, nonatomic) NSString *estimateUniqueNo;

@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) IBOutlet UITextField *itemDescriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UITextField *unitPriceTextField;
@property (strong, nonatomic) IBOutlet UITextField *discountRateTextField;
@property (strong, nonatomic) IBOutlet UITextField *vatAmountTextField;
@property (strong, nonatomic) IBOutlet UITextField *totalAmountTextField;

@property (strong, nonatomic) IBOutlet UILabel *currencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyLabel2;

@property (strong, nonatomic) IBOutlet UIStepper *quantityStepper;

@property (copy, nonatomic) void (^updateCompletionBlock)(void);



@end
