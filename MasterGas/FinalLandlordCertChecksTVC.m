//
//  FinalLandlordCertChecksTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "FinalLandlordCertChecksTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Certificate.h"
#import "Customer.h"


@interface FinalLandlordCertChecksTVC ()
@property CGPoint originalCenter;
@end

@implementation FinalLandlordCertChecksTVC


@synthesize entityName;


@synthesize ecvSegmentControl;
@synthesize gasTightnessSegementControl;
@synthesize gasInstallationPipeworkControl;
@synthesize equipotentialBondingControl;
@synthesize coAlarmFittedSegmentControl;
@synthesize coAlarmWorkingSegementControl;
@synthesize gasTightnessInitialValueTextField;
@synthesize gasTightnessFinalValueTextField;


//LPG
@synthesize cylinderFinalConnectionControl;
@synthesize lpgRegulatorOperatingPressureTextField;
@synthesize lpgRegulatorLockupPressureTextField;

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
    
    // ECV present
    NSLog(@"ECV = %@", [self.managedObject valueForKey:@"finalCheckECV"]);
    if ([[self.managedObject valueForKey:@"finalCheckECV"] isEqualToString:@"Yes"]) {
        NSLog(@"got here");
        ecvSegmentControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"finalCheckECV"] isEqualToString:@"No"]) {
        ecvSegmentControl.selectedSegmentIndex = 2;
    }
    else {
         ecvSegmentControl.selectedSegmentIndex = 0;
    }
    
    // Gas tightness test
    if ([[self.managedObject valueForKey:@"finalCheckGasTightness"] isEqualToString:@"Yes"]) {
        gasTightnessSegementControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"finalCheckGasTightness"] isEqualToString:@"No"]) {
        gasTightnessSegementControl.selectedSegmentIndex = 2;
    } else {
        gasTightnessSegementControl.selectedSegmentIndex = 0;
    }
    
    
    if ([[self.managedObject valueForKey:@"finalCheckGasInstallationPipework"] isEqualToString:@"Yes"]) {
        gasInstallationPipeworkControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"finalCheckGasInstallationPipework"] isEqualToString:@"No"]) {
        gasInstallationPipeworkControl.selectedSegmentIndex = 2;
    } else {
          gasInstallationPipeworkControl.selectedSegmentIndex = 0;
    }
    
    
    if ([[self.managedObject valueForKey:@"finalCheckEquipotentialBonding"] isEqualToString:@"Yes"]) {
        equipotentialBondingControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"finalCheckEquipotentialBonding"] isEqualToString:@"No"]) {
        equipotentialBondingControl.selectedSegmentIndex = 2;
    } else {
          equipotentialBondingControl.selectedSegmentIndex = 0;
    }
    
    if ([[self.managedObject valueForKey:@"finalCheckCOAlarmFitted"] isEqualToString:@"Yes"]) {
        coAlarmFittedSegmentControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"finalCheckCOAlarmFitted"] isEqualToString:@"No"]) {
        coAlarmFittedSegmentControl.selectedSegmentIndex = 2;
    } else if ([[self.managedObject valueForKey:@"finalCheckCOAlarmFitted"] isEqualToString:@"n/a"]) {
        coAlarmFittedSegmentControl.selectedSegmentIndex = 3;
    }
    else {
        coAlarmFittedSegmentControl.selectedSegmentIndex = 0;
    }
    
    if ([[self.managedObject valueForKey:@"finalCheckCOAlarmWorking"] isEqualToString:@"Yes"]) {
        coAlarmWorkingSegementControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"finalCheckCOAlarmWorking"] isEqualToString:@"No"]) {
        coAlarmWorkingSegementControl.selectedSegmentIndex = 2;
    } else if ([[self.managedObject valueForKey:@"finalCheckCOAlarmWorking"] isEqualToString:@"n/a"]) {
        coAlarmWorkingSegementControl.selectedSegmentIndex = 3;
    } else {
        coAlarmWorkingSegementControl.selectedSegmentIndex = 0;
    }
    
    
    self.gasTightnessInitialValueTextField.text = [self.managedObject valueForKey:@"finalCheckGasTightnessInitialValue"];
    self.gasTightnessFinalValueTextField.text = [self.managedObject valueForKey:@"finalCheckGasTightnessFinalValue"];
    
    //LPG
    if ([[self.managedObject valueForKey:@"cylinderFinalConnection"] isEqualToString:@"Yes"]) {
        cylinderFinalConnectionControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"cylinderFinalConnection"] isEqualToString:@"No"]) {
        cylinderFinalConnectionControl.selectedSegmentIndex = 2;
    } else {
        cylinderFinalConnectionControl.selectedSegmentIndex = 0;
    }
    
    self.lpgRegulatorOperatingPressureTextField.text = [self.managedObject valueForKey:@"lpgRegulatorOperatingPressure"];

    self.lpgRegulatorLockupPressureTextField.text = [self.managedObject valueForKey:@"lpgRegulatorLockupPressure"];
    
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
    // ecv
    if (self.ecvSegmentControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"finalCheckECV"];
    }
    else if (self.ecvSegmentControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"finalCheckECV"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"finalCheckECV"];
    }
    
    // Gas tightness test
    if (self.gasTightnessSegementControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"finalCheckGasTightness"];
    }
    else if (self.gasTightnessSegementControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"finalCheckGasTightness"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"finalCheckGasTightness"];
    }
    
    
    // gas installation pipework control
    if (self.gasInstallationPipeworkControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"finalCheckGasInstallationPipework"];
    }
    else if (self.gasInstallationPipeworkControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"finalCheckGasInstallationPipework"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"finalCheckGasInstallationPipework"];
    }
    
    
    if (self.equipotentialBondingControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"finalCheckEquipotentialBonding"];
    }
    else if (self.equipotentialBondingControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"finalCheckEquipotentialBonding"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"finalCheckEquipotentialBonding"];
    }
    
    
    if (self.coAlarmFittedSegmentControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"finalCheckCOAlarmFitted"];
    }
    else if (self.coAlarmFittedSegmentControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"finalCheckCOAlarmFitted"];
    }
    else if (self.coAlarmFittedSegmentControl.selectedSegmentIndex == 3)
    {
        [self.managedObject setValue:@"n/a" forKey:@"finalCheckCOAlarmFitted"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"finalCheckCOAlarmFitted"];
    }
    
    
    if (self.coAlarmWorkingSegementControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"finalCheckCOAlarmWorking"];
    }
    else if (self.coAlarmWorkingSegementControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"finalCheckCOAlarmWorking"];
    }
    else if (self.coAlarmWorkingSegementControl.selectedSegmentIndex == 3)
    {
        [self.managedObject setValue:@"n/a" forKey:@"finalCheckCOAlarmWorking"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"finalCheckCOAlarmWorking"];
    }
    
    
    
    
    [self.managedObject setValue:[NSString checkForNilString:self.gasTightnessInitialValueTextField.text] forKey:@"finalCheckGasTightnessInitialValue"];
    [self.managedObject setValue:[NSString checkForNilString:self.gasTightnessFinalValueTextField.text] forKey:@"finalCheckGasTightnessFinalValue"];
    
    // LPG
    if (self.cylinderFinalConnectionControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"cylinderFinalConnection"];
    }
    else if (self.equipotentialBondingControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"cylinderFinalConnection"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"cylinderFinalConnection"];
    }
    
    [self.managedObject setValue:[NSString checkForNilString:self.lpgRegulatorOperatingPressureTextField.text] forKey:@"lpgRegulatorOperatingPressure"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.lpgRegulatorLockupPressureTextField.text] forKey:@"lpgRegulatorLockupPressure"];
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [self SaveAll];
}

@end
