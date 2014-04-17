//
//  PurgingChecksTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 15/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "PurgingChecksTVC.h"
#import "SDCoreDataController.h"
#import "LACHelperMethods.h"

@interface PurgingChecksTVC ()
@property CGPoint originalCenter;
@end

@implementation PurgingChecksTVC

@synthesize entityName;

@synthesize pRiskAssessmentCarriedOutSegmentControl;
@synthesize pWrittenProcedurePreparedSegmentControl;
@synthesize pPersonsInVicinityNotifiedSegmentControl;
@synthesize pNoSmokingSignsDisplayedSegmentControl;
@synthesize pAppropiateValvesLabelledSegmentControl;
@synthesize pNitrogenGasCheckedVerifiedSegmentControl;
@synthesize pFireExtinguishersAvailableSegmentControl;
@synthesize pTwoWayRadiosAvailableSegmentControl;
@synthesize pElectricalBondsFittedSegmentControl;
@synthesize pPurgeVolumeGasMeterTextField;
@synthesize pPurgeVolumePipeworkAndFittingsTextField;
@synthesize pTotalPurgeVolumeTextField;
@synthesize pGasDetectorIntrinsicallySafeSegmentControl;
@synthesize pPurgeFinalTestValueTextField;
@synthesize pPurgeFinalTestUnitSegmentControl;
@synthesize pPurgeResultSegmentControl;

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
    self.pRiskAssessmentCarriedOutSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppRiskAssessmentCarriedOut"]];
    
    self.pWrittenProcedurePreparedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppWrittenProcedurePrepared"]];

    self.pPersonsInVicinityNotifiedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppPersonsVicinityAdvised"]];
    
    self.pNoSmokingSignsDisplayedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppNoSmokingSigns"]];
    
     self.pAppropiateValvesLabelledSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppValvesToFromSectionLabelled"]];

    self.pNitrogenGasCheckedVerifiedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppNitrogenCylindersCheckedforCorrectContent"]];
  
    self.pFireExtinguishersAvailableSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppSuitableFireExtinguishersAvailable"]];

    self.pTwoWayRadiosAvailableSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppTwoWayRadiosAvailable"]];

    self.pElectricalBondsFittedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppElecticalBondsFitted"]];
    
    self.pPurgeVolumeGasMeterTextField.text = [self.managedObject valueForKey:@"ppPurgeVolumeGasMeter"];
    
    self.pPurgeVolumePipeworkAndFittingsTextField.text = [self.managedObject valueForKey:@"ppPurgeVolumeInstallationPipeworkFittings"];
    
    self.pTotalPurgeVolumeTextField.text = [self.managedObject valueForKey:@"ppTotalPurgeVolume"];
 
    self.pGasDetectorIntrinsicallySafeSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ppGasDetector"]];

    self.pPurgeFinalTestValueTextField.text = [self.managedObject valueForKey:@"ppCompletePurgeNotingFinalCriteriaReadings"];
    
    self.pPurgeFinalTestUnitSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"O2 %", @"LFL %"] withValue:[self.managedObject valueForKey:@"ppCompletePurgeNotingFinalCriteriaReadingsUnit"]];
    
    self.pPurgeResultSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"Pass", @"Fail"] withValue:[self.managedObject valueForKey:@"ppPurgePassFail"]];
    
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
    // SAVE
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pRiskAssessmentCarriedOutSegmentControl.selectedSegmentIndex] forKey:@"ppRiskAssessmentCarriedOut"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pWrittenProcedurePreparedSegmentControl.selectedSegmentIndex] forKey:@"ppWrittenProcedurePrepared"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pPersonsInVicinityNotifiedSegmentControl.selectedSegmentIndex] forKey:@"ppPersonsVicinityAdvised"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pNoSmokingSignsDisplayedSegmentControl.selectedSegmentIndex] forKey:@"ppNoSmokingSigns"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pAppropiateValvesLabelledSegmentControl.selectedSegmentIndex] forKey:@"ppValvesToFromSectionLabelled"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pNitrogenGasCheckedVerifiedSegmentControl.selectedSegmentIndex] forKey:@"ppNitrogenCylindersCheckedforCorrectContent"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pFireExtinguishersAvailableSegmentControl.selectedSegmentIndex] forKey:@"ppSuitableFireExtinguishersAvailable"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pTwoWayRadiosAvailableSegmentControl.selectedSegmentIndex] forKey:@"ppTwoWayRadiosAvailable"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pElectricalBondsFittedSegmentControl.selectedSegmentIndex] forKey:@"ppElecticalBondsFitted"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.pPurgeVolumeGasMeterTextField.text] forKey:@"ppPurgeVolumeGasMeter"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.pPurgeVolumePipeworkAndFittingsTextField.text] forKey:@"ppPurgeVolumeInstallationPipeworkFittings"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.pTotalPurgeVolumeTextField.text] forKey:@"ppTotalPurgeVolume"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.pGasDetectorIntrinsicallySafeSegmentControl.selectedSegmentIndex] forKey:@"ppGasDetector"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.pPurgeFinalTestValueTextField.text] forKey:@"ppCompletePurgeNotingFinalCriteriaReadings"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"O2 %", @"LFL %"] withIndex:self.pPurgeFinalTestUnitSegmentControl.selectedSegmentIndex] forKey:@"ppCompletePurgeNotingFinalCriteriaReadingsUnit"];
    
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"Pass", @"Fail"]withIndex:self.pPurgeResultSegmentControl.selectedSegmentIndex] forKey:@"ppPurgePassFail"];
    
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
