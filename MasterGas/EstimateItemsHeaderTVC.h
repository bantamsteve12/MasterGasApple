//
//  EstimateItemsHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstimateItem.h"
#import "EstimateItemDetailTVC.h"
#import "MainWithTwoSubtitlesCell.h"
#import "LACUsersHandler.h"


@interface EstimateItemsHeaderTVC : UITableViewController


@property (nonatomic, strong) NSArray *estimateItems;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) NSString *estimateUniqueNo;
@property (nonatomic, strong) EstimateItem *selectedEstimateItem;

- (IBAction)refreshButtonTouched:(id)sender;

@end
