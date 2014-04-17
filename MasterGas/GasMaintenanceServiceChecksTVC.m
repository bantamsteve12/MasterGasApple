//
//  GasMaintenanceServiceChecksTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 24/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "GasMaintenanceServiceChecksTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"


@interface GasMaintenanceServiceChecksTVC ()
@property CGPoint originalCenter;
@end

@implementation GasMaintenanceServiceChecksTVC


@synthesize entityName;

@synthesize serviceBurnerInjectorsSegmentControl;
@synthesize serviceBurnerInjectorsTextField;
@synthesize serviceHeatExchangerSegmentControl;
@synthesize serviceHeatExchangerTextField;
@synthesize serviceIgnitionSegmentControl;
@synthesize serviceIgnitionTextField;
@synthesize serviceElectricsSegmentControl;
@synthesize serviceElectricsTextField;
@synthesize serviceControlsSegmentControl;
@synthesize serviceControlsTextField;
@synthesize serviceGasConnectionsSegmentControl;
@synthesize serviceGasConnectionsTextField;
@synthesize serviceSealsSegmentControl;
@synthesize serviceSealsTextField;
@synthesize serviceGasPipeworkSegmentControl;
@synthesize serviceGasPipeworkTextField;
@synthesize serviceFansSegmentControl;
@synthesize serviceFansTextField;
@synthesize serviceFireplaceOpeningVoidSegmentControl;
@synthesize serviceFireplaceOpeningVoidTextField;
@synthesize serviceClosurePlateSegmentControl;
@synthesize serviceClosurePlateTextField;
@synthesize serviceFlamePictureSegmentControl;
@synthesize serviceFlamePictureTextField;
@synthesize serviceLocationSegmentControl;
@synthesize serviceLocationTextField;
@synthesize serviceStabilitySegmentControl;
@synthesize serviceStabilityTextField;
@synthesize serviceReturnAirPlenumSegmentControl;
@synthesize serviceReturnAirPlenumTextField;
@synthesize serviceGasWaterLeakSegmentControl;
@synthesize serviceGasWaterLeakTextField;



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
    self.serviceBurnerInjectorsTextField.text = [self.managedObject valueForKey:@"serviceBurnerInjectorsNotes"];
    self.serviceHeatExchangerTextField.text = [self.managedObject valueForKey:@"serviceHeatExchangerNotes"];
    self.serviceIgnitionTextField.text = [self.managedObject valueForKey:@"serviceIgnitionNotes"];
    self.serviceElectricsTextField.text = [self.managedObject valueForKey:@"serviceElectricsNotes"];
    self.serviceControlsTextField.text = [self.managedObject valueForKey:@"serviceControlsNotes"];
    self.serviceGasConnectionsTextField.text = [self.managedObject valueForKey:@"serviceGasConnectionsNotes"];
    self.serviceSealsTextField.text = [self.managedObject valueForKey:@"serviceSealsNotes"];
    self.serviceGasPipeworkTextField.text = [self.managedObject valueForKey:@"serviceGasPipeworkNotes"];
    self.serviceFansTextField.text = [self.managedObject valueForKey:@"serviceFansNotes"];
    self.serviceFireplaceOpeningVoidTextField.text = [self.managedObject valueForKey:@"serviceFireplaceOpeningVoidNotes"];
    self.serviceClosurePlateTextField.text = [self.managedObject valueForKey:@"serviceClosurePlateNotes"];
    self.serviceFlamePictureTextField.text = [self.managedObject valueForKey:@"serviceFlamePictureNotes"];
    self.serviceLocationTextField.text = [self.managedObject valueForKey:@"serviceLocationNotes"];
    self.serviceStabilityTextField.text = [self.managedObject valueForKey:@"serviceStabilityNotes"];
    self.serviceReturnAirPlenumTextField.text = [self.managedObject valueForKey:@"serviceReturnAirPlenumNotes"];
    
    self.serviceGasWaterLeakTextField.text = [self.managedObject valueForKey:@"serviceGasWaterLeaksNotes"];
    
    self.serviceBurnerInjectorsSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceBurnerInjectors"]];
    
    self.serviceHeatExchangerSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceHeatExchanger"]];
    
    self.serviceIgnitionSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceIgnition"]];
    
    self.serviceElectricsSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceElectrics"]];
    
    self.serviceControlsSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceControls"]];
    
    self.serviceGasConnectionsSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceGasConnections"]];
    
    self.serviceSealsSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceSeals"]];
    
    self.serviceGasPipeworkSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceGasPipework"]];
    
    self.serviceFansSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceFans"]];
    
    self.serviceFireplaceOpeningVoidSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceFireplaceOpeningVoid"]];
    
    self.serviceClosurePlateSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceClosurePlate"]];
    
    self.serviceFlamePictureSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceFlamePicture"]];
    
    self.serviceLocationSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceLocation"]];
    
    self.serviceStabilitySegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceStability"]];
    
    self.serviceReturnAirPlenumSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceReturnAirPlenum"]];
    
    self.serviceGasWaterLeakSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"serviceGasWaterLeaks"]];
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
    [self.managedObject setValue:[NSString checkForNilString:self.serviceBurnerInjectorsTextField.text] forKey:@"serviceBurnerInjectorsNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceHeatExchangerTextField.text] forKey:@"serviceHeatExchangerNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceIgnitionTextField.text] forKey:@"serviceIgnitionNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceElectricsTextField.text] forKey:@"serviceElectricsNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceControlsTextField.text] forKey:@"serviceControlsNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceGasConnectionsTextField.text] forKey:@"serviceGasConnectionsNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceSealsTextField.text] forKey:@"serviceSealsNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceGasPipeworkTextField.text] forKey:@"serviceGasPipeworkNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceFansTextField.text] forKey:@"serviceFansNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceFireplaceOpeningVoidTextField.text] forKey:@"serviceFireplaceOpeningVoidNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceFireplaceOpeningVoidTextField.text] forKey:@"serviceFireplaceOpeningVoidNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceClosurePlateTextField.text] forKey:@"serviceClosurePlateNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceFlamePictureTextField.text] forKey:@"serviceFlamePictureNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceLocationTextField.text] forKey:@"serviceLocationNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceStabilityTextField.text] forKey:@"serviceStabilityNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.serviceReturnAirPlenumTextField.text] forKey:@"serviceReturnAirPlenumNotes"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.serviceGasWaterLeakTextField.text] forKey:@"serviceGasWaterLeaksNotes"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceBurnerInjectorsSegmentControl.selectedSegmentIndex] forKey:@"serviceBurnerInjectors"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceHeatExchangerSegmentControl.selectedSegmentIndex] forKey:@"serviceHeatExchanger"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceIgnitionSegmentControl.selectedSegmentIndex] forKey:@"serviceIgnition"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceElectricsSegmentControl.selectedSegmentIndex] forKey:@"serviceElectrics"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceControlsSegmentControl.selectedSegmentIndex] forKey:@"serviceControls"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceGasConnectionsSegmentControl.selectedSegmentIndex] forKey:@"serviceGasConnections"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceSealsSegmentControl.selectedSegmentIndex] forKey:@"serviceSeals"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceGasPipeworkSegmentControl.selectedSegmentIndex] forKey:@"serviceGasPipework"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceFansSegmentControl.selectedSegmentIndex] forKey:@"serviceFans"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceFireplaceOpeningVoidSegmentControl.selectedSegmentIndex] forKey:@"serviceFireplaceOpeningVoid"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceClosurePlateSegmentControl.selectedSegmentIndex] forKey:@"serviceClosurePlate"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceFlamePictureSegmentControl.selectedSegmentIndex] forKey:@"serviceFlamePicture"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceLocationSegmentControl.selectedSegmentIndex] forKey:@"serviceLocation"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceStabilitySegmentControl.selectedSegmentIndex] forKey:@"serviceStability"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceReturnAirPlenumSegmentControl.selectedSegmentIndex] forKey:@"serviceReturnAirPlenum"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.serviceGasWaterLeakSegmentControl.selectedSegmentIndex] forKey:@"serviceGasWaterLeaks"];
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
