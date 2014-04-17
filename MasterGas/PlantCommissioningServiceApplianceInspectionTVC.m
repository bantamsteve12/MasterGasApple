//
//  PlantCommissioningServiceApplianceInspectionTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "PlantCommissioningServiceApplianceInspectionTVC.h"
#import "SDCoreDataController.h"
#import "PlantCommissioningService.h"
#import "LACHelperMethods.h"


@interface PlantCommissioningServiceApplianceInspectionTVC ()
@property CGPoint originalCenter;
@end

@implementation PlantCommissioningServiceApplianceInspectionTVC


@synthesize selectedApplianceInspection;

@synthesize entityName;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;


@synthesize locationTextField;
@synthesize applianceTypeTextField;
@synthesize applianceMakeTextField;
@synthesize applianceModelTextField;
@synthesize applianceFlueTypeTextField;
@synthesize applianceSerialNumberTextField;
@synthesize burnerManufacturerTextField;
@synthesize ccLHeatInputRatingTextField;
@synthesize ccHHeatInputRatingTextField;
@synthesize ccLGasBurnerPressureTextField;
@synthesize ccHGasBurnerPressureTextField;
@synthesize ccLGasRateTextField;
@synthesize ccHGasRateTextField;
@synthesize ccLAirGasRatioControlTextField;
@synthesize ccHAirGasRatioControlTextField;
@synthesize ccLAmbientRoomTempTextField;
@synthesize ccHAmbientRoomTempTextField;
@synthesize ccLFlueGasTempTextField;
@synthesize ccHFlueGasTempTextField;
@synthesize ccLFlueGasTempNetTextField;
@synthesize ccHFlueGasTempNetTextField;
@synthesize ccLFlueDraughtPressureTextField;
@synthesize ccHFlueDraughtPressureTextField;
@synthesize ccLOxygenTextField;
@synthesize ccHOxygenTextField;
@synthesize ccLCarbonMonoxideTextField;
@synthesize ccHCarbonMonoxideTextField;
@synthesize ccLCarbonDioxideTextField;
@synthesize ccHCarbonDioxideTextField;
@synthesize ccLNoxTextField;
@synthesize ccHNoxTextField;
@synthesize ccLExcessAirTextField;
@synthesize ccHExcessAirTextField;
@synthesize ccLCOCO2RatioTextField;
@synthesize ccHCOCO2RatioTextField;
@synthesize ccLGrossEfficiencyTextField;
@synthesize ccHGrossEfficiencyTextField;
@synthesize ccLCODilutionTextField;
@synthesize ccHCODilutionTextField;

@synthesize asAirGasPressureSwitchWorkingSegmentControl;
@synthesize asFlueFlowSegmentControl;
@synthesize asSpilageTestSegmentControl;
@synthesize asVentilationSatisfactorySegmentControl;
@synthesize asFlameProvingSafetyWorkingSegmentControl;
@synthesize asBurnerLockoutTimeTextField;
@synthesize asTemperatureAndLimitStatsWorkingSegmentControl;
@synthesize asApplianceServicedSegmentControl;
@synthesize asGasBoosterCompressorWorkingFlowSegmentControl;
@synthesize asGasInstallationTightnessTestCarriedOutSegmentControl;
@synthesize asGasInstallationPipeworkSleevedLabelledPaintedSegmentControl;
@synthesize asChimneyInstalledInAccordanceWithStandardsSegmentControl;
@synthesize asFanFlueInterlockWorkingSegmentControl;
@synthesize asGasInstallationPipeworkSupportedSegmentControl;

@synthesize workCarriedOutTextView;
@synthesize remedialWorkRequiredTextView;
@synthesize warningNoticeIssuedSegmentControl;
@synthesize warningNoticeNumberTextField;

@synthesize updateCompletionBlock;

@synthesize certificateNumber;

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
    
    
    NSLog(@"selectedApplianceInspection: %@", self.selectedApplianceInspection.location);
    
    if (self.selectedApplianceInspection == nil) {
        NSLog(@"insert new appliance detail");
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"PlantComServiceApplianceInspection" inManagedObjectContext:self.managedObjectContext];
        
        NSLog(@"selected cert no = %@", self.certificateNumber);
    }
    else
    {
        self.managedObject = self.selectedApplianceInspection;
        
        self.locationTextField.text = [self.managedObject valueForKey:@"location"];
        
        self.applianceMakeTextField.text = [self.managedObject valueForKey:@"manufacturer"];
        self.applianceModelTextField.text = [self.managedObject valueForKey:@"model"];
        
        self.applianceTypeTextField.text = [self.managedObject valueForKey:@"type"];
        self.applianceFlueTypeTextField.text = [self.managedObject valueForKey:@"flueType"];
        
        self.applianceSerialNumberTextField.text = [self.managedObject valueForKey:@"serialNumber"];
        
        self.burnerManufacturerTextField.text = [self.managedObject valueForKey:@"burnerManufacturer"];
        self.ccLHeatInputRatingTextField.text = [self.managedObject valueForKey:@"ccLHeatInputRating"];
        self.ccHHeatInputRatingTextField.text = [self.managedObject valueForKey:@"ccHHeatInputRating"];
        self.ccLCarbonMonoxideTextField.text = [self.managedObject valueForKey:@"ccLCarbonMonoxide"];
        self.ccHCarbonMonoxideTextField.text = [self.managedObject valueForKey:@"ccHCarbonMonoxide"];
        self.ccLCOCO2RatioTextField.text = [self.managedObject valueForKey:@"ccLCOCO2Ratio"];
        self.ccHCOCO2RatioTextField.text = [self.managedObject valueForKey:@"ccHCOCO2Ratio"];
        self.ccLCODilutionTextField.text = [self.managedObject valueForKey:@"ccLCOFlueDilution"];
        self.ccHCODilutionTextField.text = [self.managedObject valueForKey:@"ccHCOFlueDilution"];
        
        self.ccLExcessAirTextField.text = [self.managedObject valueForKey:@"ccLExcessAir"];
        self.ccHExcessAirTextField.text = [self.managedObject valueForKey:@"ccHExcessAir"];
        self.ccLFlueDraughtPressureTextField.text = [self.managedObject valueForKey:@"ccLFlueDraughtPressure"];
        self.ccHFlueDraughtPressureTextField.text = [self.managedObject valueForKey:@"ccHFlueDraughtPressure"];
        self.ccLFlueGasTempTextField.text = [self.managedObject valueForKey:@"ccLFlueGasTemp"];
        self.ccLCarbonMonoxideTextField.text = [self.managedObject valueForKey:@"ccLCarbonMonoxide"];
        self.ccHCarbonMonoxideTextField.text = [self.managedObject valueForKey:@"ccHCarbonMonoxide"];
        self.ccLFlueGasTempTextField.text = [self.managedObject valueForKey:@"ccLFlueGasTemp"];
        self.ccHFlueGasTempTextField.text = [self.managedObject valueForKey:@"ccHFlueGasTemp"];
        self.ccLFlueGasTempNetTextField.text = [self.managedObject valueForKey:@"ccLFlueGasTempNet"];
        self.ccHFlueGasTempNetTextField.text = [self.managedObject valueForKey:@"ccHFlueGasTempNet"];
        self.ccLGasBurnerPressureTextField.text = [self.managedObject valueForKey:@"ccLGasBurnerPressure"];
        self.ccHGasBurnerPressureTextField.text = [self.managedObject valueForKey:@"ccHGasBurnerPressure"];
        self.ccLGasRateTextField.text = [self.managedObject valueForKey:@"ccLGasRate"];
        self.ccHGasRateTextField.text = [self.managedObject valueForKey:@"ccHGasRate"];
        self.ccLGrossEfficiencyTextField.text = [self.managedObject valueForKey:@"ccLGrossEfficiency"];
        self.ccHGrossEfficiencyTextField.text = [self.managedObject valueForKey:@"ccHGrossEfficiency"];
        self.ccLHeatInputRatingTextField.text = [self.managedObject valueForKey:@"ccLHeatInputRating"];
        self.ccHHeatInputRatingTextField.text = [self.managedObject valueForKey:@"ccHHeatInputRating"];
        self.ccLNoxTextField.text = [self.managedObject valueForKey:@"ccLNOX"];
        self.ccHNoxTextField.text = [self.managedObject valueForKey:@"ccHNOX"];
        self.ccLOxygenTextField.text = [self.managedObject valueForKey:@"ccLOxygen"];
        self.ccHOxygenTextField.text = [self.managedObject valueForKey:@"ccHOxygen"];
        self.ccLAirGasRatioControlTextField.text = [self.managedObject valueForKey:@"ccLAirGasRatioSetting"];
        self.ccHAirGasRatioControlTextField.text = [self.managedObject valueForKey:@"ccHAirGasRatioSetting"];
        self.ccLAmbientRoomTempTextField.text = [self.managedObject valueForKey:@"ccLAmbientRoomTemp"];
        self.ccHAmbientRoomTempTextField.text = [self.managedObject valueForKey:@"ccHAmbientRoomTemp"];
        self.ccLCarbonDioxideTextField.text = [self.managedObject valueForKey:@"ccLCarbonDioxide"];
        self.ccHCarbonDioxideTextField.text = [self.managedObject valueForKey:@"ccHCarbonDioxide"];
        self.asBurnerLockoutTimeTextField.text = [self.managedObject valueForKey:@"acBurnerLockoutTime"];
 
        self.asAirGasPressureSwitchWorkingSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acAirGasPressureSwitchWorking"]];
        
        self.asApplianceServicedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acApplianceServiced"]];

        self.asChimneyInstalledInAccordanceWithStandardsSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acChimneyInstalledwithStandards"]];
        
        self.asFanFlueInterlockWorkingSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acFanFlueInterlockWorking"]];
        
        self.asFlameProvingSafetyWorkingSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acFlameProvingSafetyDevicesWorking"]];
        
        self.asFlueFlowSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acFlueFlowSatisfactory"]];
        
        self.asGasBoosterCompressorWorkingFlowSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acGasBoostersCompressorsWorking"]];
        
        self.asGasInstallationPipeworkSleevedLabelledPaintedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acGasInstallationPipeworkSleevedLabelledPainted"]];
        
        self.asGasInstallationPipeworkSupportedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acGasInstallationPipeworkSupported"]];
        
        self.asGasInstallationTightnessTestCarriedOutSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acGasInstallationTightnessTestCarriedOut"]];
        
        self.asSpilageTestSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acSpilageTestSatisfactory"]];

        self.asTemperatureAndLimitStatsWorkingSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acTempAndThermostatsWorking"]];
        
        self.asVentilationSatisfactorySegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"acVentilationSatisfactory"]];

        self.workCarriedOutTextView.text = [self.managedObject valueForKey:@"workCarriedOut"];

        self.remedialWorkRequiredTextView.text = [self.managedObject valueForKey:@"remedialWorkRequired"];
        
        self.warningNoticeIssuedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"warningNoticeIssued"]];

        self.warningNoticeNumberTextField.text = [self.managedObject valueForKey:@"warningNoticeNumber"];
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
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



- (IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
    
    [self SaveAll];
    [self.navigationController popViewControllerAnimated:YES];  
   // updateCompletionBlock();
    
}


-(void)SaveAll
{
    [self.managedObject setValue:[NSString checkForNilString:self.certificateNumber] forKey:@"certificateReference"];
    [self.managedObject setValue:[NSString checkForNilString:self.locationTextField.text] forKey:@"location"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceMakeTextField.text] forKey:@"manufacturer"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceModelTextField.text] forKey:@"model"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceFlueTypeTextField.text] forKey:@"flueType"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceTypeTextField.text] forKey:@"type"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceSerialNumberTextField.text] forKey:@"serialNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.burnerManufacturerTextField.text] forKey:@"burnerManufacturer"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLHeatInputRatingTextField.text] forKey:@"ccLHeatInputRating"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHHeatInputRatingTextField.text] forKey:@"ccHHeatInputRating"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLCarbonMonoxideTextField.text] forKey:@"ccLCarbonMonoxide"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHCarbonMonoxideTextField.text] forKey:@"ccHCarbonMonoxide"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLCOCO2RatioTextField.text] forKey:@"ccLCOCO2Ratio"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHCOCO2RatioTextField.text] forKey:@"ccHCOCO2Ratio"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLCODilutionTextField.text] forKey:@"ccLCOFlueDilution"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHCODilutionTextField.text] forKey:@"ccHCOFlueDilution"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLExcessAirTextField.text] forKey:@"ccLExcessAir"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHExcessAirTextField.text] forKey:@"ccHExcessAir"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLFlueDraughtPressureTextField.text] forKey:@"ccLFlueDraughtPressure"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHFlueDraughtPressureTextField.text] forKey:@"ccHFlueDraughtPressure"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLFlueGasTempTextField.text] forKey:@"ccLFlueGasTemp"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHFlueGasTempTextField.text] forKey:@"ccHFlueGasTemp"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLFlueGasTempNetTextField.text] forKey:@"ccLFlueGasTempNet"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHFlueGasTempNetTextField.text] forKey:@"ccHFlueGasTempNet"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLGasBurnerPressureTextField.text] forKey:@"ccLGasBurnerPressure"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHGasBurnerPressureTextField.text] forKey:@"ccHGasBurnerPressure"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLGasRateTextField.text] forKey:@"ccLGasRate"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHGasRateTextField.text] forKey:@"ccHGasRate"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLGrossEfficiencyTextField.text] forKey:@"ccLGrossEfficiency"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHGrossEfficiencyTextField.text] forKey:@"ccHGrossEfficiency"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLHeatInputRatingTextField.text] forKey:@"ccLHeatInputRating"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHHeatInputRatingTextField.text] forKey:@"ccHHeatInputRating"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLNoxTextField.text] forKey:@"ccLNOX"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHNoxTextField.text] forKey:@"ccHNOX"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLOxygenTextField.text] forKey:@"ccLOxygen"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHOxygenTextField.text] forKey:@"ccHOxygen"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLAirGasRatioControlTextField.text] forKey:@"ccLAirGasRatioSetting"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHAirGasRatioControlTextField.text] forKey:@"ccHAirGasRatioSetting"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLAmbientRoomTempTextField.text] forKey:@"ccLAmbientRoomTemp"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHAmbientRoomTempTextField.text] forKey:@"ccHAmbientRoomTemp"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccLCarbonDioxideTextField.text] forKey:@"ccLCarbonDioxide"];
    [self.managedObject setValue:[NSString checkForNilString:self.ccHCarbonDioxideTextField.text] forKey:@"ccHCarbonDioxide"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.asBurnerLockoutTimeTextField.text] forKey:@"acBurnerLockoutTime"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asChimneyInstalledInAccordanceWithStandardsSegmentControl.selectedSegmentIndex] forKey:@"acChimneyInstalledwithStandards"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asFanFlueInterlockWorkingSegmentControl.selectedSegmentIndex] forKey:@"acFanFlueInterlockWorking"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asFlameProvingSafetyWorkingSegmentControl.selectedSegmentIndex] forKey:@"acFlameProvingSafetyDevicesWorking"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asApplianceServicedSegmentControl.selectedSegmentIndex] forKey:@"acApplianceServiced"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asFlueFlowSegmentControl.selectedSegmentIndex] forKey:@"acFlueFlowSatisfactory"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asGasBoosterCompressorWorkingFlowSegmentControl.selectedSegmentIndex] forKey:@"acGasBoostersCompressorsWorking"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asGasInstallationPipeworkSleevedLabelledPaintedSegmentControl.selectedSegmentIndex] forKey:@"acGasInstallationPipeworkSleevedLabelledPainted"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asGasInstallationPipeworkSupportedSegmentControl.selectedSegmentIndex] forKey:@"acGasInstallationPipeworkSupported"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asGasInstallationTightnessTestCarriedOutSegmentControl.selectedSegmentIndex] forKey:@"acGasInstallationTightnessTestCarriedOut"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asSpilageTestSegmentControl.selectedSegmentIndex] forKey:@"acSpilageTestSatisfactory"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asTemperatureAndLimitStatsWorkingSegmentControl.selectedSegmentIndex] forKey:@"acTempAndThermostatsWorking"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asVentilationSatisfactorySegmentControl.selectedSegmentIndex] forKey:@"acVentilationSatisfactory"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.asAirGasPressureSwitchWorkingSegmentControl.selectedSegmentIndex] forKey:@"acAirGasPressureSwitchWorking"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.warningNoticeIssuedSegmentControl.selectedSegmentIndex] forKey:@"warningNoticeIssued"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.warningNoticeNumberTextField.text] forKey:@"warningNoticeNumber"];
    
    
    [self.managedObject setValue:[NSString checkForNilString:self.workCarriedOutTextView.text] forKey:@"workCarriedOut"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.remedialWorkRequiredTextView.text] forKey:@"remedialWorkRequired"];
    
    
    [self.managedObject.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObject.managedObjectContext save:&error];
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
