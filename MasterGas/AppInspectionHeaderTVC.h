//
//  AppInspectionHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 13/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplianceInspection.h"
#import "ApplianceInspectionDetailTVC.h"
#import "LACUsersHandler.h"


@interface AppInspectionHeaderTVC : UITableViewController

@property (nonatomic, strong) NSArray *applianceInspections;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *certificateNumber;
@property (nonatomic, strong) ApplianceInspection *selectedApplianceInspection;

- (IBAction)refreshButtonTouched:(id)sender;

@end
