//
//  BreakdownServiceChecksTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 23/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"
#import "LACHelperMethods.h"

@interface BreakdownServiceChecksTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UISegmentedControl *prelimFlueSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prelimVentilationSizeSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prelimWaterFuelSoundSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prelimElectricalFusedSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prelimValvingArrangementsSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prelimIsolationAvailableSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prelimBoilerRoomClearegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceHeatExchangerSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceIgnitionrSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceGasValveSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceFanSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceSafetyDeviceSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceControlBoxSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceBurnersPilotSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceFuelPressureAndTypeSegementControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceOpsBurnerCleanedSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceOpsPilotCleanedSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceOpsIgnitionCleanedSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceOpsBurnerFanAndAirwaysCleanedSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceOpsHeatExchangerFlueWaysCleanedSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceOpsFuelAndElecConnectedSoundSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceOpsInterlocksSegementControl;


@property (strong, nonatomic) NSString *entityName;


@end
