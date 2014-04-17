//
//  PlantCommissioningApplianceHeaderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlantComServiceApplianceInspection.h"
//#import "ApplianceInspectionDetailTVC.h"
#import "LACUsersHandler.h"

@interface PlantCommissioningApplianceHeaderTVC : UITableViewController

@property (nonatomic, strong) NSArray *applianceInspections;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) NSNumber *maxAppliances;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *certificateNumber;
@property (nonatomic, strong) PlantComServiceApplianceInspection *selectedApplianceInspection;

- (IBAction)refreshButtonTouched:(id)sender;

@end
