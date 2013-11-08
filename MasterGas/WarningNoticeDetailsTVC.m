//
//  WarningNoticeDetailsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 22/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "WarningNoticeDetailsTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

@interface WarningNoticeDetailsTVC ()
@property CGPoint originalCenter;
@end

@implementation WarningNoticeDetailsTVC

@synthesize entityName;

@synthesize locationTextField;
@synthesize applianceTypeTextField;
@synthesize applianceMakeTextField;
@synthesize applianceModelTextField;
@synthesize applianceSerialNumberField;

@synthesize gasEscapeSegmentControl;
@synthesize warningLabelStatementSegmentControl;
@synthesize warningLabelAttachedSegmentControl;
@synthesize immediatelyDangeoursReasonTextView;
@synthesize atRiskReasonTextView;
@synthesize notToCurrentStandardsReasonTextView;

@synthesize gasUserNotPresentSegementControl;

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
    
    // TODO: enter field names from database.
    self.locationTextField.text = [self.managedObject valueForKey:@"applianceLocation"];
    self.applianceTypeTextField.text = [self.managedObject valueForKey:@"applianceType"];
    self.applianceMakeTextField.text = [self.managedObject valueForKey:@"applianceMake"];
    self.applianceModelTextField.text = [self.managedObject valueForKey:@"applianceModel"];
    self.applianceSerialNumberField.text = [self.managedObject valueForKey:@"applianceSerialNumber"];
    
    
     self.gasEscapeSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"gasEscape"]];
     self.warningLabelAttachedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"warningLabelAttached"]];
     self.warningLabelStatementSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"warningLabelStatement"]];
    
    self.gasUserNotPresentSegementControl.selectedSegmentIndex = [LACHelperMethods TrueFalseNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"customerNotPresent"]];
    
     self.immediatelyDangeoursReasonTextView.text = [self.managedObject valueForKey:@"immediatelyDangerousStatement"];
     self.atRiskReasonTextView.text = [self.managedObject valueForKey:@"atRiskStatement"];
     self.notToCurrentStandardsReasonTextView.text = [self.managedObject valueForKey:@"notToCurrentStandardsStatement"];
    
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
    
    // TODO: Add in name values
    [self.managedObject setValue:[NSString checkForNilString:self.locationTextField.text] forKey:@"applianceLocation"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceTypeTextField.text] forKey:@"applianceType"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceMakeTextField.text] forKey:@"applianceMake"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceModelTextField.text] forKey:@"applianceModel"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceSerialNumberField.text] forKey:@"applianceSerialNumber"];
  
    

    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.gasEscapeSegmentControl.selectedSegmentIndex] forKey:@"gasEscape"];
 
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.warningLabelAttachedSegmentControl.selectedSegmentIndex] forKey:@"warningLabelAttached"];
 
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.warningLabelStatementSegmentControl.selectedSegmentIndex] forKey:@"warningLabelStatement"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.immediatelyDangeoursReasonTextView.text] forKey:@"immediatelyDangerousStatement"];
    [self.managedObject setValue:[NSString checkForNilString:self.atRiskReasonTextView.text] forKey:@"atRiskStatement"];
    [self.managedObject setValue:[NSString checkForNilString:self.notToCurrentStandardsReasonTextView.text] forKey:@"notToCurrentStandardsStatement"];
    
        [self.managedObject setValue:[LACHelperMethods TrueFalseNASegementControlValue:self.gasUserNotPresentSegementControl.selectedSegmentIndex] forKey:@"customerNotPresent"];
    
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    //  addDateCompletionBlock();
    
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
