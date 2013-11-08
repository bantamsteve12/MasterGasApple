//
//  ApplianceInspectionDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "ApplianceInspectionDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Certificate.h"


@interface ApplianceInspectionDetailTVC ()
@property CGPoint originalCenter;

@end

@implementation ApplianceInspectionDetailTVC

@synthesize selectedApplianceInspection;

@synthesize entityName;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;


@synthesize locationTextField;

@synthesize applianceTypeTextField; //
@synthesize applianceMakeTextField; //
@synthesize applianceModelTextField; //
@synthesize landlordsApplianceSegmentControl; //
@synthesize applianceInspectedSegmentControl; //
@synthesize operatingPressureTextField; //
@synthesize heatInputTextField; //
@synthesize safetyDeviceInCorrectOperationSegmentControl; //
@synthesize ventilationProvisionSegmentControl; //
@synthesize visualConditionOfFlueSatisfactorySegmentControl; //
@synthesize fluePerformanceTestsSegmentControl; //
@synthesize applianceServicedSegmentControl; //
@synthesize applianceSafeToUseSegmentControl; //
@synthesize faultDetailsTextView;
@synthesize remedialActionTakenTextView;
@synthesize warningNoticeLabelIssuedSegmentControl; //
@synthesize warningNoticeNumberTextField;
@synthesize flueTypeSegmentControl; //

@synthesize combustion1stCOReadingTextField;
@synthesize combustion1stCO2ReadingTextField;
@synthesize combustion1stRatioReadingTextField;
@synthesize combustion2ndCOReadingTextField;
@synthesize combustion2ndCO2ReadingTextField;
@synthesize combustion2ndRatioReadingTextField;
@synthesize combustion3rdCOReadingTextField;
@synthesize combustion3rdCO2ReadingTextField;
@synthesize combustion3rdRatioReadingTextField;

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
   
     self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"ApplianceInspection" inManagedObjectContext:self.managedObjectContext];
    
        NSLog(@"selected cert no = %@", self.certificateNumber);
    }
    else
    {
    
    
    self.managedObject = self.selectedApplianceInspection;
     
    // location label
    NSString *location = [self.managedObject valueForKey:@"location"];
    if (location.length > 0) {
        locationTextField.text = [self.managedObject valueForKey:@"location"];
    }
        
    // appliance Make Label
    NSString *applianceMake = [self.managedObject valueForKey:@"applianceMake"];
    if (applianceMake.length > 0) {
        applianceMakeTextField.text = [self.managedObject valueForKey:@"applianceMake"];
    }
            
    // appliance Model Label
    NSString *applianceModel = [self.managedObject valueForKey:@"applianceModel"];
    if (applianceModel.length > 0) {
        applianceModelTextField.text = [self.managedObject valueForKey:@"applianceModel"];
    }
        
    // appliance Type Label
    NSString *applianceType = [self.managedObject valueForKey:@"applianceType"];
    if (applianceType.length > 0) {
        applianceTypeTextField.text = [self.managedObject valueForKey:@"applianceType"];
    }
        
    // flue type
    if ([[self.managedObject valueForKey:@"flueType"] isEqualToString:@"FL"]) {
        flueTypeSegmentControl.selectedSegmentIndex = 1;
        NSLog(@"FL");
    }
    else if ([[self.managedObject valueForKey:@"flueType"] isEqualToString:@"OF"]) {
        flueTypeSegmentControl.selectedSegmentIndex = 2;
        NSLog(@"OF");
    }
    else if ([[self.managedObject valueForKey:@"flueType"] isEqualToString:@"RS-BF"]) {
        flueTypeSegmentControl.selectedSegmentIndex = 3;
    }
    else if ([[self.managedObject valueForKey:@"flueType"] isEqualToString:@"RS-FF"]) {
        flueTypeSegmentControl.selectedSegmentIndex = 4;
    }
    else
    {
         flueTypeSegmentControl.selectedSegmentIndex = 0;
    }
        
    // landlords appliance
    if ([[self.managedObject valueForKey:@"landlordsAppliance"] isEqualToString:@"Yes"]) {
        landlordsApplianceSegmentControl.selectedSegmentIndex = 1;
    } else if ([[self.managedObject valueForKey:@"landlordsAppliance"] isEqualToString:@"No"])  {
        landlordsApplianceSegmentControl.selectedSegmentIndex = 2;
    } else if ([[self.managedObject valueForKey:@"landlordsAppliance"] isEqualToString:@"n/a"])  {
        landlordsApplianceSegmentControl.selectedSegmentIndex = 3;
    }
    else {
        landlordsApplianceSegmentControl.selectedSegmentIndex = 0;
    }
    
    // appliance inspected
    if ([[self.managedObject valueForKey:@"applianceInspected"] isEqualToString:@"Yes"]) {
        applianceInspectedSegmentControl.selectedSegmentIndex = 1;
    }
    else if ([[self.managedObject valueForKey:@"applianceInspected"] isEqualToString:@"No"]) {
        applianceInspectedSegmentControl.selectedSegmentIndex = 2;
    }
    else if ([[self.managedObject valueForKey:@"applianceInspected"] isEqualToString:@"n/a"]) {
        applianceInspectedSegmentControl.selectedSegmentIndex = 3;
    }
    else {
        applianceInspectedSegmentControl.selectedSegmentIndex = 0;
    }
    
    // operatingPressureTextField
        operatingPressureTextField.text = [self.managedObject valueForKey:@"operatingPressure"];
        
          
    // heatInputTextField
        heatInputTextField.text = [self.managedObject valueForKey:@"heatInput"];
    
    
    // safety device in correct operation
    if ([[self.managedObject valueForKey:@"safetyDeviceInCorrectOperation"] isEqualToString:@"Yes"]) {
        safetyDeviceInCorrectOperationSegmentControl.selectedSegmentIndex = 1;
    }
    else if ([[self.managedObject valueForKey:@"safetyDeviceInCorrectOperation"] isEqualToString:@"No"]) {
        safetyDeviceInCorrectOperationSegmentControl.selectedSegmentIndex = 2;
    }
    else if ([[self.managedObject valueForKey:@"safetyDeviceInCorrectOperation"] isEqualToString:@"n/a"]) {
        safetyDeviceInCorrectOperationSegmentControl.selectedSegmentIndex = 3;
    }
    else {
        safetyDeviceInCorrectOperationSegmentControl.selectedSegmentIndex = 0;
    }
    
    // ventilation provision
    if ([[self.managedObject valueForKey:@"ventilationProvision"] isEqualToString:@"Yes"]) {
        ventilationProvisionSegmentControl.selectedSegmentIndex = 1;
    }
    else if ([[self.managedObject valueForKey:@"ventilationProvision"] isEqualToString:@"No"]) {
        ventilationProvisionSegmentControl.selectedSegmentIndex = 2;
    }
    else
    {
         ventilationProvisionSegmentControl.selectedSegmentIndex = 0;
    }
    
    //  visual condition of flue satisfactory
    if ([[self.managedObject valueForKey:@"visualConditionOfFlueSatisfactory"] isEqualToString:@"Yes"]) {
        visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex = 1;
    }
    else if ([[self.managedObject valueForKey:@"visualConditionOfFlueSatisfactory"] isEqualToString:@"No"]) {
        visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex = 2;
    }
    else if ([[self.managedObject valueForKey:@"visualConditionOfFlueSatisfactory"] isEqualToString:@"n/a"]) {
         visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex = 3;
    }
    else
    {
        visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex = 0;
    }
    
    //  flue performance tests
    if ([[self.managedObject valueForKey:@"fluePerformanceTests"] isEqualToString:@"Pass"]) {
        fluePerformanceTestsSegmentControl.selectedSegmentIndex = 1;
    }
    else if ([[self.managedObject valueForKey:@"fluePerformanceTests"] isEqualToString:@"Fail"]) {
        fluePerformanceTestsSegmentControl.selectedSegmentIndex = 2;
    }
    else if ([[self.managedObject valueForKey:@"fluePerformanceTests"] isEqualToString:@"n/a"]) {
        fluePerformanceTestsSegmentControl.selectedSegmentIndex = 3;
    }
    else {
        visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex = 0;
    }

    //  appliance serviced
    if ([[self.managedObject valueForKey:@"applianceServiced"] isEqualToString:@"Yes"]) {
        applianceServicedSegmentControl.selectedSegmentIndex = 1;
    }
    else if ([[self.managedObject valueForKey:@"applianceServiced"] isEqualToString:@"No"]) {
        applianceServicedSegmentControl.selectedSegmentIndex = 2;
    }
    else  if ([[self.managedObject valueForKey:@"applianceServiced"] isEqualToString:@"n/a"]) {
        applianceServicedSegmentControl.selectedSegmentIndex = 3;
    }
    else
    {
         applianceServicedSegmentControl.selectedSegmentIndex = 0;
    }
    
    //  appliance safe to use
    if ([[self.managedObject valueForKey:@"applianceSafeToUse"] isEqualToString:@"Yes"]) {
        applianceSafeToUseSegmentControl.selectedSegmentIndex = 1;
    }
    else if ([[self.managedObject valueForKey:@"applianceSafeToUse"] isEqualToString:@"No"]) {
        applianceSafeToUseSegmentControl.selectedSegmentIndex = 2;
    }
    else{
        applianceSafeToUseSegmentControl.selectedSegmentIndex = 0;
    }

    // faultDetailsTextView
        faultDetailsTextView.text = [self.managedObject valueForKey:@"faultDetails"];
    
    // remedialDetailsTextView
        remedialActionTakenTextView.text = [self.managedObject valueForKey:@"remedialActionTaken"];
        
    //  Warning notice issued
    if ([[self.managedObject valueForKey:@"warningNoticeLabelIssued"] isEqualToString:@"Yes"]) {
        warningNoticeLabelIssuedSegmentControl.selectedSegmentIndex = 0;
    }
    else if ([[self.managedObject valueForKey:@"warningNoticeLabelIssued"] isEqualToString:@"No"]) {
        warningNoticeLabelIssuedSegmentControl.selectedSegmentIndex = 1;
    }
    else {
        warningNoticeLabelIssuedSegmentControl.selectedSegmentIndex = 2;
    }
        
    // warning notice number
        warningNoticeNumberTextField.text = [self.managedObject valueForKey:@"warningNoticeNumber"];
    }

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
    

    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    NSLog(@"saveButtonTouched for ApplianceInspection Detail");
    NSLog(@"certificateNumber: %@", self.certificateNumber);

    if (self.applianceInspectedSegmentControl.selectedSegmentIndex == 1) {
         [self.managedObject setValue:@"Yes" forKey:@"applianceInspected"];
    }
    else if (self.applianceInspectedSegmentControl.selectedSegmentIndex == 2) {
        [self.managedObject setValue:@"No" forKey:@"applianceInspected"];
    }
    else if (self.applianceInspectedSegmentControl.selectedSegmentIndex == 3) {
        [self.managedObject setValue:@"n/a" forKey:@"applianceInspected"];
    }
    else {
         [self.managedObject setValue:@"" forKey:@"applianceInspected"];
    }

     [self.managedObject setValue:[NSString checkForNilString:self.applianceMakeTextField.text] forKey:@"applianceMake"];
     [self.managedObject setValue:[NSString checkForNilString:self.applianceModelTextField.text] forKey:@"applianceModel"];
    
   
    [self.managedObject setValue:[NSString checkForNilString:self.combustion1stCOReadingTextField.text] forKey:@"combustion1stCOReading"];
    
     [self.managedObject setValue:[NSString checkForNilString:self.combustion1stCO2ReadingTextField.text] forKey:@"combustion1stCO2Reading"];
     [self.managedObject setValue:[NSString checkForNilString:self.combustion1stRatioReadingTextField.text] forKey:@"combustion1stRatioReading"];
     [self.managedObject setValue:[NSString checkForNilString:self.combustion2ndCO2ReadingTextField.text] forKey:@"combustion2ndCO2Reading"];
     [self.managedObject setValue:[NSString checkForNilString:self.combustion2ndCOReadingTextField.text] forKey:@"combustion2ndCOReading"];
     [self.managedObject setValue:[NSString checkForNilString:self.combustion2ndRatioReadingTextField.text] forKey:@"combustion2ndRatioReading"];
     [self.managedObject setValue:[NSString checkForNilString:self.combustion3rdCO2ReadingTextField.text] forKey:@"combustion3rdCO2Reading"];
     [self.managedObject setValue:[NSString checkForNilString:self.combustion3rdCOReadingTextField.text] forKey:@"combustion3rdCOReading"];
     [self.managedObject setValue:[NSString checkForNilString:self.combustion3rdRatioReadingTextField.text] forKey:@"combustion3rdRatioReading"];

    
    if (self.applianceSafeToUseSegmentControl.selectedSegmentIndex == 1) {
       [self.managedObject setValue:@"Yes" forKey:@"applianceSafeToUse"];
    }
    else if (self.applianceSafeToUseSegmentControl.selectedSegmentIndex == 2) {
        [self.managedObject setValue:@"No" forKey:@"applianceSafeToUse"];
    }
    else {
        [self.managedObject setValue:@"" forKey:@"applianceSafeToUse"];
    }
    
    if (self.applianceServicedSegmentControl.selectedSegmentIndex == 1) {
       [self.managedObject setValue:@"Yes" forKey:@"applianceServiced"]; 
    }
    else if(self.applianceServicedSegmentControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"applianceServiced"];
    }
    else if(self.applianceServicedSegmentControl.selectedSegmentIndex == 3)
    {
        [self.managedObject setValue:@"n/a" forKey:@"applianceServiced"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"applianceServiced"];
    }
    
    
     [self.managedObject setValue:[NSString checkForNilString:self.applianceTypeTextField.text] forKey:@"applianceType"];
     [self.managedObject setValue:[NSString checkForNilString:self.certificateNumber] forKey:@"certificateReference"];
    
    NSLog(@"certificate Ref: %@", self.certificateNumber);
    
     [self.managedObject setValue:[NSString checkForNilString:self.faultDetailsTextView.text] forKey:@"faultDetails"];
    
    
    if (self.fluePerformanceTestsSegmentControl.selectedSegmentIndex == 1) {
           [self.managedObject setValue:@"Pass" forKey:@"fluePerformanceTests"];
    }
    else if(self.fluePerformanceTestsSegmentControl.selectedSegmentIndex == 2)
    {
           [self.managedObject setValue:@"Fail" forKey:@"fluePerformanceTests"];
    }
    else if(self.fluePerformanceTestsSegmentControl.selectedSegmentIndex == 3)
    {
           [self.managedObject setValue:@"n/a" forKey:@"fluePerformanceTests"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"fluePerformanceTests"];
    }
    
    if (self.flueTypeSegmentControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"FL" forKey:@"flueType"];
    }
    else if(self.flueTypeSegmentControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"OF" forKey:@"flueType"];
    }
    else if(self.flueTypeSegmentControl.selectedSegmentIndex == 3)
    {
        [self.managedObject setValue:@"RS-BF" forKey:@"flueType"];
    }
    else if(self.flueTypeSegmentControl.selectedSegmentIndex == 4)
    {
        [self.managedObject setValue:@"RS-FF" forKey:@"flueType"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"flueType"];
    }
 

     [self.managedObject setValue:[NSString checkForNilString:self.heatInputTextField.text] forKey:@"heatInput"];
    
    if (self.landlordsApplianceSegmentControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"landlordsAppliance"];
    }
    else if (self.landlordsApplianceSegmentControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"landlordsAppliance"];
    }
    else if (self.landlordsApplianceSegmentControl.selectedSegmentIndex == 3)
    {
        [self.managedObject setValue:@"n/a" forKey:@"landlordsAppliance"];
    }
    else
    {
          [self.managedObject setValue:@"" forKey:@"landlordsAppliance"];
    }
    
     [self.managedObject setValue:[NSString checkForNilString:self.locationTextField.text] forKey:@"location"];
     [self.managedObject setValue:[NSString checkForNilString:self.operatingPressureTextField.text] forKey:@"operatingPressure"];
     [self.managedObject setValue:[NSString checkForNilString:self.remedialActionTakenTextView.text] forKey:@"remedialActionTaken"];
    
    
    if (self.safetyDeviceInCorrectOperationSegmentControl.selectedSegmentIndex == 1) {
         [self.managedObject setValue:@"Yes" forKey:@"safetyDeviceInCorrectOperation"];
    }
    else if (self.safetyDeviceInCorrectOperationSegmentControl.selectedSegmentIndex == 2)
    {
         [self.managedObject setValue:@"No" forKey:@"safetyDeviceInCorrectOperation"];
    }
       else if (self.safetyDeviceInCorrectOperationSegmentControl.selectedSegmentIndex == 3)
    {
         [self.managedObject setValue:@"n/a" forKey:@"safetyDeviceInCorrectOperation"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"safetyDeviceInCorrectOperation"];
    }
    
    
    if (self.ventilationProvisionSegmentControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Yes" forKey:@"ventilationProvision"];
    }
    else if (self.ventilationProvisionSegmentControl.selectedSegmentIndex == 2)
    {
        [self.managedObject setValue:@"No" forKey:@"ventilationProvision"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"ventilationProvision"];
    }
    
    
    if (self.visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex == 1) {
         [self.managedObject setValue:@"Yes" forKey:@"visualConditionOfFlueSatisfactory"];
    }
    else if(self.visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex == 2)
    {
         [self.managedObject setValue:@"No" forKey:@"visualConditionOfFlueSatisfactory"];
    }
     else if(self.visualConditionOfFlueSatisfactorySegmentControl.selectedSegmentIndex == 3)
    {
         [self.managedObject setValue:@"n/a" forKey:@"visualConditionOfFlueSatisfactory"];
    }
    else
    {
        [self.managedObject setValue:@"" forKey:@"visualConditionOfFlueSatisfactory"];
    }

    if (self.warningNoticeLabelIssuedSegmentControl.selectedSegmentIndex == 1) {
         [self.managedObject setValue:@"Yes" forKey:@"warningNoticeLabelIssued"];
    }
    else  if (self.warningNoticeLabelIssuedSegmentControl.selectedSegmentIndex == 2)
    {
         [self.managedObject setValue:@"No" forKey:@"warningNoticeLabelIssued"];
    }
    else
    {
          [self.managedObject setValue:@"" forKey:@"warningNoticeLabelIssued"];
    }
    
    [self.managedObject setValue:[NSString checkForNilString:self.warningNoticeNumberTextField.text] forKey:@"warningNoticeNumber"];
    
    
    [self.managedObject.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObject.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];

    
    [self.navigationController popViewControllerAnimated:YES];  
   updateCompletionBlock();
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
