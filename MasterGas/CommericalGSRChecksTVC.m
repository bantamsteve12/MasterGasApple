//
//  CommericalGSRChecksTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/02/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "CommericalGSRChecksTVC.h"
#import "SDCoreDataController.h"
#import "GasSafetyNonDomestic.h"
#import "Customer.h"
#import "LACHelperMethods.h"


@interface CommericalGSRChecksTVC ()
@property CGPoint originalCenter;
@end

@implementation CommericalGSRChecksTVC

@synthesize entityName;

@synthesize meterInstallationAccessibleSegmentControl;
@synthesize meterInstallationAdequatelyVentilatedSegmentControl;
@synthesize meterInstallationClearOfCombustiblesSegmentControl;
@synthesize meterInstallationControlValveHandleFittedSegmentControl;
@synthesize meterInstallationECVWithEmergencyNoticeSegmentControl;
@synthesize meterInstallationEmergencyControlAccessibleSegmentControl;
@synthesize meterInstallationLockKeyLabelledSegmentControl;
@synthesize meterInstallationRoomSecureSegmentControl;
@synthesize meterInstallationECVLabelledDirectionSegmentControl;
@synthesize meterInstallationMeterAdequatelySupported;

@synthesize pipeworkColourCodeIdentifiedSegmentControl;
@synthesize pipeworkIsolationValveHandlesInPlaceSegmentControl;
@synthesize pipeworkIsolationValvesFittedSegmentControl;
@synthesize pipeworkLineDiagramCurrentSegmentControl;
@synthesize pipeworkLineDiagramNearMeterSegmentControl;
@synthesize pipeworkSleevedSegmentControl;
@synthesize pipeworkStrengthTightnessTestSegmentControl;
@synthesize pipeworkSupportedSegmentControl;
@synthesize pipeworkElectricalCrossBondingSegmentControl;

@synthesize safetyResponsiblePersonNotifiedSegmentControl;
@synthesize safetyWarningRaisedAndLabelsAttachedSegmentControl;
@synthesize safetyResponsiblePersonNameTextField;
@synthesize safetyWarningNoticeNumberTextField;

@synthesize remedialWorkRequiredTextViewField;
@synthesize workCarriedOutTextViewField;

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
    self.meterInstallationAccessibleSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationAccessible"]];
    self.meterInstallationAdequatelyVentilatedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationAdequatelyVentilated"]];
    self.meterInstallationClearOfCombustiblesSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationClearOfCombustibles"]];
    self.meterInstallationControlValveHandleFittedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationControlValveHandleFitted"]];
    self.meterInstallationECVWithEmergencyNoticeSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationECVWithEmergencyNotice"]];
    self.meterInstallationEmergencyControlAccessibleSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationEmergencyControlAccessible"]];
    self.meterInstallationLockKeyLabelledSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationLockKeyLabelled"]];
    self.meterInstallationRoomSecureSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationRoomSecure"]];
    self.meterInstallationECVLabelledDirectionSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationECVLabelledDirection"]];
    
    self.meterInstallationMeterAdequatelySupported.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"meterInstallationMeterAdequatelySupported"]];

    self.pipeworkColourCodeIdentifiedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkColourCodedIdentified"]];
    self.pipeworkIsolationValveHandlesInPlaceSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkIsolationValveHandlesInPlace"]];
    self.pipeworkIsolationValvesFittedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkIsolationValvesFitted"]];
    self.pipeworkLineDiagramCurrentSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkLineDiagramCurrent"]];
    self.pipeworkLineDiagramNearMeterSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkLineDiagramNearMeter"]];
    self.pipeworkSleevedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkSleeved"]];
    self.pipeworkStrengthTightnessTestSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkStrengthTightnessTest"]];
    self.pipeworkSupportedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkSupported"]];
    self.pipeworkElectricalCrossBondingSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"pipeworkElectricalCrossbonding"]];
    
    
    
    self.safetyResponsiblePersonNotifiedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyResponiblePersonNotified"]];
    self.safetyWarningRaisedAndLabelsAttachedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyWarningRaisedAndLabelsAttached"]];
    
    self.safetyResponsiblePersonNameTextField.text = [self.managedObject valueForKey:@"safetyResponiblePersonName"];
    self.safetyWarningNoticeNumberTextField.text = [self.managedObject valueForKey:@"safetyWarningNoticeNumber"];
    self.remedialWorkRequiredTextViewField.text = [self.managedObject valueForKey:@"remedialWorkRequired"];
    self.workCarriedOutTextViewField.text = [self.managedObject valueForKey:@"workCarriedOut"];
    
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
    // SAVE TODO:
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationAccessibleSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationAccessible"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationAdequatelyVentilatedSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationAdequatelyVentilated"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationClearOfCombustiblesSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationClearOfCombustibles"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationControlValveHandleFittedSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationControlValveHandleFitted"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationECVWithEmergencyNoticeSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationECVWithEmergencyNotice"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationEmergencyControlAccessibleSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationEmergencyControlAccessible"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationLockKeyLabelledSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationLockKeyLabelled"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationRoomSecureSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationRoomSecure"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationECVLabelledDirectionSegmentControl.selectedSegmentIndex] forKey:@"meterInstallationECVLabelledDirection"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.meterInstallationMeterAdequatelySupported.selectedSegmentIndex] forKey:@"meterInstallationMeterAdequatelySupported"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkColourCodeIdentifiedSegmentControl.selectedSegmentIndex] forKey:@"pipeworkColourCodedIdentified"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkIsolationValveHandlesInPlaceSegmentControl.selectedSegmentIndex] forKey:@"pipeworkIsolationValveHandlesInPlace"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkIsolationValvesFittedSegmentControl.selectedSegmentIndex] forKey:@"pipeworkIsolationValvesFitted"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkLineDiagramCurrentSegmentControl.selectedSegmentIndex] forKey:@"pipeworkLineDiagramCurrent"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkLineDiagramNearMeterSegmentControl.selectedSegmentIndex] forKey:@"pipeworkLineDiagramNearMeter"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkSleevedSegmentControl.selectedSegmentIndex] forKey:@"pipeworkSleeved"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkStrengthTightnessTestSegmentControl.selectedSegmentIndex] forKey:@"pipeworkStrengthTightnessTest"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkSupportedSegmentControl.selectedSegmentIndex] forKey:@"pipeworkSupported"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pipeworkElectricalCrossBondingSegmentControl.selectedSegmentIndex] forKey:@"pipeworkElectricalCrossbonding"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetyResponsiblePersonNotifiedSegmentControl.selectedSegmentIndex] forKey:@"safetyResponiblePersonNotified"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetyWarningRaisedAndLabelsAttachedSegmentControl.selectedSegmentIndex] forKey:@"safetyWarningRaisedAndLabelsAttached"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.safetyResponsiblePersonNameTextField.text] forKey:@"safetyResponiblePersonName"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.safetyWarningNoticeNumberTextField.text] forKey:@"safetyWarningNoticeNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.remedialWorkRequiredTextViewField.text] forKey:@"remedialWorkRequired"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.workCarriedOutTextViewField.text] forKey:@"workCarriedOut"];
    
    
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
