//
//  TightnessTestDetailsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 13/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "TightnessTestDetailsTVC.h"
#import "SDCoreDataController.h"
#import "GasSafetyNonDomestic.h"
#import "Customer.h"
#import "LACHelperMethods.h"

@interface TightnessTestDetailsTVC ()
@property CGPoint originalCenter;
@end

@implementation TightnessTestDetailsTVC

@synthesize entityName;

@synthesize ttGasTypeSegmentControl;
@synthesize ttInstallationTypeSegmentControl;
@synthesize ttWeatherOrTempChangesSegmentControl;
@synthesize ttMeterType1TextField;
@synthesize ttMeterType2TextField;
@synthesize ttMeterBypassSegmentControl;
@synthesize ttInstallationVolumeTextField;
@synthesize ttPipeworkFittingsTextField;
@synthesize ttTotalInstallationVolumeTextField;
@synthesize ttTestMediumSegmentControl;
@synthesize ttTightnessTestPressureValueTextField;
@synthesize ttTightnessPressureUnitSegmentControl;
@synthesize ttPressureGuageTypeTextField;
@synthesize ttMPLRorMAPDValueTextField;
@synthesize ttMPLRorMAPDUnitSegmentControl;
@synthesize ttLetbyTestPeriodTextField;
@synthesize ttStabilisationPeriodTextField;
@synthesize ttTightnessTestDurationTextField;
@synthesize ttInadequateAreasToCheckSegmentControl;
@synthesize ttBarometricPressureConnectionNecessarySegmentControl;
@synthesize ttActualLeakRateTextField;
@synthesize ttActualPressureDropTextField;
@synthesize ttInadequatelyVentilatedAreasCheckedSegmentControl;
@synthesize ttPassOrFailSegmentControl;

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



/*
 + (NSString *)PassFailNASegementControlValue:(int)selectedIndex;
 + (int)PassFailNASegementControlSelectedIndexForValue:(NSString *)value;
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    // load values if present
    self.ttGasTypeSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"Not Set", @"Natural", @"LPG", @"n/a"] withValue:[self.managedObject valueForKey:@"ttGasType"]];
    
    NSLog(@"Installation Type = %@", [self.managedObject valueForKey:@"ttInstallationType"]);
    
    self.ttInstallationTypeSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"New", @"Extension", @"Existing", @"n/a"] withValue:[self.managedObject valueForKey:@"ttInstallationType"]];
    
    self.ttWeatherOrTempChangesSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ttTempAffectTest"]];
  
    self.ttMeterType1TextField.text = [self.managedObject valueForKey:@"ttMeterType"];
    self.ttMeterType2TextField.text = [self.managedObject valueForKey:@"ttMeterType2"];
    
    self.ttMeterBypassSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ttMeterBypassInstalled"]];

    self.ttInstallationVolumeTextField.text = [self.managedObject valueForKey:@"ttInstallationVolume"];

    self.ttPipeworkFittingsTextField.text = [self.managedObject valueForKey:@"ttInstallationPipeworkAndFittings"];
    
    self.ttTotalInstallationVolumeTextField.text = [self.managedObject valueForKey:@"ttTotalIV"];
  
    self.ttTestMediumSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"Not Set", @"Fuel Gas", @"Air", @"n/a"] withValue:[self.managedObject valueForKey:@"ttTestMedium"]];

    self.ttTightnessTestPressureValueTextField.text = [self.managedObject valueForKey:@"ttTightnessTestPressure"];
    
    self.ttTightnessPressureUnitSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"mbar", @"bar"] withValue:[self.managedObject valueForKey:@"ttTightnessTestPressureUnit"]];
    
    self.ttPressureGuageTypeTextField.text = [self.managedObject valueForKey:@"ttPressureGuageType"];
    self.ttMPLRorMAPDValueTextField.text = [self.managedObject valueForKey:@"ttMPLR"];
    
    self.ttMPLRorMAPDUnitSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"mbar (MPLRP)", @"bar (MAPD)"] withValue:[self.managedObject valueForKey:@"ttMPLRUnit"]];
    
    self.ttLetbyTestPeriodTextField.text = [self.managedObject valueForKey:@"ttLetByTestPeriod"];
    self.ttStabilisationPeriodTextField.text = [self.managedObject valueForKey:@"ttStabilisationPeriod"];
    self.ttTightnessTestDurationTextField.text = [self.managedObject valueForKey:@"ttTightnessTestDuration"];
    self.ttInadequateAreasToCheckSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ttInAdequatelyVentAreasToCheck"]];
  
    self.ttBarometricPressureConnectionNecessarySegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ttBarometricPressureCorrectionNecessary"]];
    
    self.ttActualLeakRateTextField.text = [self.managedObject valueForKey:@"ttActualLeakRate"];
    self.ttActualPressureDropTextField.text = [self.managedObject valueForKey:@"ttActualPressureDrop"];
    
    self.ttInadequatelyVentilatedAreasCheckedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ttInadequatelyVentAreasChecked"]];
    
    self.ttPassOrFailSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"Pass", @"Fail"] withValue:[self.managedObject valueForKey:@"ttTightnessTestPassFail"]];
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
    //  addDateCompletionBlock();
    
    
}

-(void)SaveAll
{
    
    // SAVE TODO:
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"Not Set",@"Natural",@"LPG",@"n/a"] withIndex:self.ttGasTypeSegmentControl.selectedSegmentIndex] forKey:@"ttGasType"];
    
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"New", @"Extension", @"Existing", @"n/a"] withIndex:self.ttInstallationTypeSegmentControl.selectedSegmentIndex] forKey:@"ttInstallationType"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ttWeatherOrTempChangesSegmentControl.selectedSegmentIndex] forKey:@"ttTempAffectTest"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttMeterType1TextField.text] forKey:@"ttMeterType"];
    [self.managedObject setValue:[NSString checkForNilString:self.ttMeterType2TextField.text] forKey:@"ttMeterType2"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ttMeterBypassSegmentControl.selectedSegmentIndex] forKey:@"ttMeterBypassInstalled"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttInstallationVolumeTextField.text] forKey:@"ttInstallationVolume"];
    [self.managedObject setValue:[NSString checkForNilString:self.ttPipeworkFittingsTextField.text] forKey:@"ttInstallationPipeworkAndFittings"];
    [self.managedObject setValue:[NSString checkForNilString:self.ttTotalInstallationVolumeTextField.text] forKey:@"ttTotalIV"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"Not Set", @"Fuel Gas", @"Air", @"n/a"] withIndex:self.ttTestMediumSegmentControl.selectedSegmentIndex] forKey:@"ttTestMedium"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttTightnessTestPressureValueTextField.text] forKey:@"ttTightnessTestPressure"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"mbar", @"bar"] withIndex:self.ttTightnessPressureUnitSegmentControl.selectedSegmentIndex] forKey:@"ttTightnessTestPressureUnit"];
    [self.managedObject setValue:[NSString checkForNilString:self.ttPressureGuageTypeTextField.text] forKey:@"ttPressureGuageType"];
    [self.managedObject setValue:[NSString checkForNilString:self.ttMPLRorMAPDValueTextField.text] forKey:@"ttMPLR"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"mbar (MPLRP)", @"bar (MAPD)"] withIndex:self.ttMPLRorMAPDUnitSegmentControl.selectedSegmentIndex] forKey:@"ttMPLRUnit"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttLetbyTestPeriodTextField.text] forKey:@"ttLetByTestPeriod"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttStabilisationPeriodTextField.text] forKey:@"ttStabilisationPeriod"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttTightnessTestDurationTextField.text] forKey:@"ttTightnessTestDuration"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ttInadequateAreasToCheckSegmentControl.selectedSegmentIndex] forKey:@"ttInAdequatelyVentAreasToCheck"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ttBarometricPressureConnectionNecessarySegmentControl.selectedSegmentIndex] forKey:@"ttBarometricPressureCorrectionNecessary"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttActualLeakRateTextField.text] forKey:@"ttActualLeakRate"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ttActualPressureDropTextField.text] forKey:@"ttActualPressureDrop"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ttInadequatelyVentilatedAreasCheckedSegmentControl.selectedSegmentIndex] forKey:@"ttInadequatelyVentAreasChecked"];
    
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"Pass", @"Fail"] withIndex:self.ttPassOrFailSegmentControl.selectedSegmentIndex] forKey:@"ttTightnessTestPassFail"];
    
    
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
