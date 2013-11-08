//
//  GasMaintenanceFindingsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 24/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"


@interface GasMaintenanceFindingsTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UISegmentedControl *applianceInstallationSafeToUseSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *warningLabelAttachedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *installationConformToMIandISSegementControl;
@property (strong, nonatomic) IBOutlet UITextView *remedialWorkRequiredTextView;


@property (strong, nonatomic) NSString *entityName;


@end
