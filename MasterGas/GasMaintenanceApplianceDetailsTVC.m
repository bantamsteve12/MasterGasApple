//
//  GasMaintenanceApplianceDetailsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 24/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "GasMaintenanceApplianceDetailsTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

@interface GasMaintenanceApplianceDetailsTVC ()
@property CGPoint originalCenter;
@end

@implementation GasMaintenanceApplianceDetailsTVC

@synthesize entityName;


@synthesize locationTextField;
@synthesize applianceTypeTextField;
@synthesize applianceMakeTextField;
@synthesize applianceModelTextField;
@synthesize applianceSerialNumberField;
@synthesize gasTightnessTestCarriedOut;
@synthesize gasTightnessTestResult;

@synthesize managedObjectContext;
@synthesize managedObject;

@synthesize operatingPressureTextField;
@synthesize heatInputTextField;

@synthesize combustion1stCOReadingTextField;
@synthesize combustion1stCO2ReadingTextField;
@synthesize combustion1stRatioReadingTextField;
@synthesize combustion2ndCOReadingTextField;
@synthesize combustion2ndCO2ReadingTextField;
@synthesize combustion2ndRatioReadingTextField;
@synthesize combustion3rdCOReadingTextField;
@synthesize combustion3rdCO2ReadingTextField;
@synthesize combustion3rdRatioReadingTextField;



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
    
    self.locationTextField.text = [self.managedObject valueForKey:@"applianceLocation"];
    self.applianceTypeTextField.text = [self.managedObject valueForKey:@"applianceType"];
    self.applianceMakeTextField.text = [self.managedObject valueForKey:@"applianceMake"];
    self.applianceModelTextField.text = [self.managedObject valueForKey:@"applianceModel"];
    self.applianceSerialNumberField.text = [self.managedObject valueForKey:@"applianceSerialNumber"];
  
    self.gasTightnessTestCarriedOut.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"gasTightnessTestCarriedOut"]];
    
    self.gasTightnessTestResult.selectedSegmentIndex = [LACHelperMethods PassFailNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"gasTightnessTestResult"]];
    
    
    self.operatingPressureTextField.text = [self.managedObject valueForKey:@"operatingPressure"];
    self.heatInputTextField.text = [self.managedObject valueForKey:@"heatInput"];
    
    combustion1stCOReadingTextField.text = [self.managedObject valueForKey:@"combustion1stCOReading"];
    combustion1stCO2ReadingTextField.text = [self.managedObject valueForKey:@"combustion1stCO2Reading"];
    combustion1stRatioReadingTextField.text = [self.managedObject valueForKey:@"combustion1stRatioReading"];
    combustion2ndCO2ReadingTextField.text = [self.managedObject valueForKey:@"combustion2ndCO2Reading"];
    combustion2ndCOReadingTextField.text = [self.managedObject valueForKey:@"combustion2ndCOReading"];
    combustion2ndRatioReadingTextField.text = [self.managedObject valueForKey:@"combustion2ndRatioReading"];
    combustion3rdCO2ReadingTextField.text = [self.managedObject valueForKey:@"combustion3rdCO2Reading"];
    combustion3rdCOReadingTextField.text = [self.managedObject valueForKey:@"combustion3rdCOReading"];
    combustion3rdRatioReadingTextField.text = [self.managedObject valueForKey:@"combustion3rdRatioReading"];


    
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
    // TODO: Add in name values
    [self.managedObject setValue:[NSString checkForNilString:self.locationTextField.text] forKey:@"applianceLocation"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceTypeTextField.text] forKey:@"applianceType"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceMakeTextField.text] forKey:@"applianceMake"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceModelTextField.text] forKey:@"applianceModel"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceSerialNumberField.text] forKey:@"applianceSerialNumber"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.gasTightnessTestCarriedOut.selectedSegmentIndex] forKey:@"gasTightnessTestCarriedOut"];
    [self.managedObject setValue:[LACHelperMethods PassFailNASegementControlValue:self.gasTightnessTestResult.selectedSegmentIndex] forKey:@"gasTightnessTestResult"];
    [self.managedObject setValue:[NSString checkForNilString:self.operatingPressureTextField.text] forKey:@"operatingPressure"];
    [self.managedObject setValue:[NSString checkForNilString:self.heatInputTextField.text] forKey:@"heatInput"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion1stCOReadingTextField.text] forKey:@"combustion1stCOReading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion1stCO2ReadingTextField.text] forKey:@"combustion1stCO2Reading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion1stRatioReadingTextField.text] forKey:@"combustion1stRatioReading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion2ndCO2ReadingTextField.text] forKey:@"combustion2ndCO2Reading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion2ndCOReadingTextField.text] forKey:@"combustion2ndCOReading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion2ndRatioReadingTextField.text] forKey:@"combustion2ndRatioReading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion3rdCO2ReadingTextField.text] forKey:@"combustion3rdCO2Reading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion3rdCOReadingTextField.text] forKey:@"combustion3rdCOReading"];
    [self.managedObject setValue:[NSString checkForNilString:self.combustion3rdRatioReadingTextField.text] forKey:@"combustion3rdRatioReading"];
    
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


#pragma Delegate methods

-(void)theLocationWasSelectedFromTheList:(LocationLookupTVC *)controller
{
    self.locationTextField.text = controller.selectedLocation.name;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theApplianceTypeWasSelectedFromTheList:(ApplianceTypeLookupTVC *)controller
{
    self.applianceTypeTextField.text = controller.selectedApplianceType.name;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theApplianceMakeWasSelectedFromTheList:(ApplianceMakeLookupTVC *)controller
{
    self.applianceMakeTextField.text = controller.selectedApplianceMake.name;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)theApplianceModelWasSelectedFromTheList:(ModelLookupTVC *)controller
{
    self.applianceModelTextField.text = controller.selectedApplianceModel.name;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SelectLocationLookupSegue"]) {
        LocationLookupTVC *locationLookupTVC = segue.destinationViewController;
        locationLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectApplianceTypeLookupSegue"]) {
        ApplianceTypeLookupTVC *applianceTypeLookupTVC = segue.destinationViewController;
        applianceTypeLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectApplianceMakeLookupSegue"]) {
        ApplianceMakeLookupTVC *applianceMakeLookupTVC = segue.destinationViewController;
        applianceMakeLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectApplianceModelLookupSegue"]) {
        ModelLookupTVC *modelLookupTVC = segue.destinationViewController;
        modelLookupTVC.delegate = self;
    }
    
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
