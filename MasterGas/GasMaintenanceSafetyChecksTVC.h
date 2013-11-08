//
//  GasMaintenanceSafetyChecksTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 26/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"

@interface GasMaintenanceSafetyChecksTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) IBOutlet UISegmentedControl *safteyVentilationSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetyVentilationTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyFlueTerminationSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetyFlueTerminationTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyFlueflowTestSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetyFlueflowTestTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetySpilageTestSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetySpilageTestTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyOperatingPressureHeatInputSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetyOperatingPressureHeatInputTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyDevicesSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetyDevicesTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyOtherSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetyOtherTextField;

@property (strong, nonatomic) NSString *entityName;


@end
