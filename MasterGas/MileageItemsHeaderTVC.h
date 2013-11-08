//
//  MileageItemsHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MileageItem.h"
#import "MileageItemDetailTVC.h"
#import "MainWithTwoSubtitlesCell.h"

@interface MileageItemsHeaderTVC : UITableViewController

@property (nonatomic, strong) NSArray *mileageItems;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) NSString *uniqueClaimNumber;
@property (nonatomic, strong) MileageItem *selectedMileageItem;

- (IBAction)refreshButtonTouched:(id)sender;

@end
