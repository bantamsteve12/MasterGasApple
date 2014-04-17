//
//  BreakdownServiceChecksTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 23/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "BreakdownServiceChecksTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"

@interface BreakdownServiceChecksTVC ()
@property CGPoint originalCenter;
@end

@implementation BreakdownServiceChecksTVC


@synthesize entityName;


@synthesize prelimFlueSegementControl;
@synthesize prelimVentilationSizeSegementControl;
@synthesize prelimWaterFuelSoundSegementControl;
@synthesize prelimElectricalFusedSegementControl;
@synthesize prelimValvingArrangementsSegementControl;
@synthesize prelimIsolationAvailableSegementControl;
@synthesize prelimBoilerRoomClearegementControl;
@synthesize serviceHeatExchangerSegementControl;
@synthesize serviceIgnitionrSegementControl;
@synthesize serviceGasValveSegementControl;
@synthesize serviceFanSegementControl;
@synthesize serviceSafetyDeviceSegementControl;
@synthesize serviceControlBoxSegementControl;
@synthesize serviceBurnersPilotSegementControl;
@synthesize serviceFuelPressureAndTypeSegementControl;
@synthesize serviceOpsBurnerCleanedSegementControl;
@synthesize serviceOpsPilotCleanedSegementControl;
@synthesize serviceOpsIgnitionCleanedSegementControl;
@synthesize serviceOpsBurnerFanAndAirwaysCleanedSegementControl;
@synthesize serviceOpsHeatExchangerFlueWaysCleanedSegementControl;
@synthesize serviceOpsFuelAndElecConnectedSoundSegementControl;
@synthesize serviceOpsInterlocksSegementControl;

@synthesize managedObjectContext;
@synthesize managedObject;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    // load values if present
    self.prelimFlueSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"prelimFlue"]];
    self.prelimVentilationSizeSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"prelimVentilationSize"]];
    self.prelimWaterFuelSoundSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"prelimWaterFuelSound"]];
    self.prelimElectricalFusedSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"prelimElectricallyFused"]];
    self.prelimValvingArrangementsSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"prelimValvingArrangements"]];
    self.prelimIsolationAvailableSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"prelimValvingArrangements"]];
    self.prelimBoilerRoomClearegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"prelimBoilerRoomClear"]];
    self.serviceHeatExchangerSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceHeatExchanger"]];
    self.serviceIgnitionrSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceIgnition"]];
    self.serviceGasValveSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceGasValve"]];
    self.serviceFanSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceFan"]];
    self.serviceSafetyDeviceSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceSafetyDevice"]];
    self.serviceControlBoxSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceControlBox"]];
    self.serviceBurnersPilotSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceBurnerPilot"]];
    self.serviceFuelPressureAndTypeSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceFuelPressureType"]];
    self.serviceOpsBurnerCleanedSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceBurnerWashedCleaned"]];
    self.serviceOpsPilotCleanedSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"servicePilotAssembley"]];
    self.serviceOpsIgnitionCleanedSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceIgnitionSystemCleaned"]];
    self.serviceOpsBurnerFanAndAirwaysCleanedSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceBurnerFanAirwaysCleaned"]];
    self.serviceOpsHeatExchangerFlueWaysCleanedSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceHeatExchangerFluewaysClean"]];
    self.serviceOpsFuelAndElecConnectedSoundSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceFuelElectricalSupplySound"]];
    self.serviceOpsInterlocksSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceInterlocksInPlace"]];
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


- (IBAction)cancelButtonPressed:(id)sender {
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
    [self SaveAll];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveAll
{
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.prelimFlueSegementControl.selectedSegmentIndex] forKey:@"prelimFlue"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.prelimVentilationSizeSegementControl.selectedSegmentIndex] forKey:@"prelimVentilationSize"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.prelimWaterFuelSoundSegementControl.selectedSegmentIndex] forKey:@"prelimWaterFuelSound"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.prelimElectricalFusedSegementControl.selectedSegmentIndex] forKey:@"prelimElectricallyFused"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.prelimValvingArrangementsSegementControl.selectedSegmentIndex] forKey:@"prelimValvingArrangements"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.prelimIsolationAvailableSegementControl.selectedSegmentIndex] forKey:@"prelimIsolationAvailable"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.prelimBoilerRoomClearegementControl.selectedSegmentIndex] forKey:@"prelimBoilerRoomClear"];
    
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceHeatExchangerSegementControl.selectedSegmentIndex] forKey:@"serviceHeatExchanger"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceIgnitionrSegementControl.selectedSegmentIndex] forKey:@"serviceIgnition"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceGasValveSegementControl.selectedSegmentIndex] forKey:@"serviceGasValve"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceFanSegementControl.selectedSegmentIndex] forKey:@"serviceFan"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceSafetyDeviceSegementControl.selectedSegmentIndex] forKey:@"serviceSafetyDevice"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceControlBoxSegementControl.selectedSegmentIndex] forKey:@"serviceControlBox"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceBurnersPilotSegementControl.selectedSegmentIndex] forKey:@"serviceBurnerPilot"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceFuelPressureAndTypeSegementControl.selectedSegmentIndex] forKey:@"serviceFuelPressureType"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceOpsBurnerFanAndAirwaysCleanedSegementControl.selectedSegmentIndex] forKey:@"serviceBurnerFanAirwaysCleaned"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceOpsBurnerCleanedSegementControl.selectedSegmentIndex] forKey:@"serviceBurnerWashedCleaned"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceOpsFuelAndElecConnectedSoundSegementControl.selectedSegmentIndex] forKey:@"serviceFuelElectricalSupplySound"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceOpsHeatExchangerFlueWaysCleanedSegementControl.selectedSegmentIndex] forKey:@"serviceHeatExchangerFluewaysClean"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceOpsIgnitionCleanedSegementControl.selectedSegmentIndex] forKey:@"serviceIgnitionSystemCleaned"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceOpsInterlocksSegementControl.selectedSegmentIndex] forKey:@"serviceInterlocksInPlace"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceOpsPilotCleanedSegementControl.selectedSegmentIndex] forKey:@"servicePilotAssembley"];
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [self SaveAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
