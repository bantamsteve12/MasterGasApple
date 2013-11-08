//
//  BreakdownServiceRecordHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 17/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "BreakdownServiceRecordHeaderTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Customer.h"
#import "MaintenanceServiceRecord.h"
#import "AddressDetailsCertificateTVC.h"
//#import "FinalLandlordCertChecksTVC.h"
#import "EngineerSignoffTVC.h"
//#import "AppInspectionHeaderTVC.h"
#import "CustomerSignoffTVC.h"
#import "BreakdownServiceRecordApplianceCheckDetailsTVC.h"
#import "BreakdownServiceChecksTVC.h"
#import "NSString+Additions.h"
#import "BreakdownServicingViewController.h"
#import "MaintenanceServiceRecord.h"
#import "BreakdownServiceAdditionalNotesTVC.h"
#import "BreakdownServiceFaultsActionsRemedialTVC.h"

#import "LACHelperMethods.h"


@interface BreakdownServiceRecordHeaderTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation BreakdownServiceRecordHeaderTVC

@synthesize recordPrefix;
@synthesize entityName;
@synthesize uniqueReferenceLabel;
@synthesize referenceTextField;
@synthesize dateLabel;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize addressCompletionLabel;
@synthesize applianceCompletionDetailsLabel;
@synthesize faultActionsCompletionRemedialLabel;
@synthesize additionalCompletionNotesSparesLabel;
@synthesize customerSignatureCompletionLabel;
@synthesize engineerSignoffCompletionLabel;
@synthesize jobTypeSegmentControl;
@synthesize recordType;
@synthesize recordTypeLabel;
@synthesize updateCompletionBlock;


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
    
    self.recordTypeLabel.text = [NSString checkForNilString:self.recordType];
    [self.managedObject setValue:[NSString checkForNilString:self.recordType] forKey:@"recordType"];
    
    if (self.managedObjectId == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        self.uniqueReferenceLabel.text =  [NSString stringWithFormat:@"%@-%@",self.recordPrefix, [NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
      // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        
        // TODO: Need to make these not default to todays date
        [self.managedObject setValue:[NSDate date] forKey:@"customerSignoffDate"];
        [self.managedObject setValue:[NSDate date] forKey:@"engineerSignoffDate"];
        
        
        self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        
        
        // Set segment control
        NSString *value = [self.managedObject valueForKey:@"jobType"];
      
        if ([value isEqualToString:@"Not Set"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 0;
        }
        else if ([value isEqualToString:@"Breakdown"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 1;
        }
        else if ([value isEqualToString:@"Service"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 2;
        }
        else {
            self.jobTypeSegmentControl.selectedSegmentIndex = 0;
        }
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueReferenceLabel.text = [self.managedObject valueForKey:@"uniqueSerialNumber"];
        
        
        // Set segment control
        NSString *value = [self.managedObject valueForKey:@"jobType"];
        
        if ([value isEqualToString:@"Not Set"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 0;
        }
        else if ([value isEqualToString:@"Breakdown"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 1;
        }
        else if ([value isEqualToString:@"Service"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 2;
        }
        else {
            self.jobTypeSegmentControl.selectedSegmentIndex = 0;
        }

        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
         //   [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
    }
    self.referenceTextField.text = [self.managedObject valueForKey:@"reference"];
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
    [self setCompletionLabels];
}




-(void)setCompletionLabels
{
   
    // check Address Details
    NSString *customerAddressName = [self.managedObject valueForKey:@"customerAddressName"];
    NSString *siteAddressName = [self.managedObject valueForKey:@"siteAddressName"];
    
    if ((customerAddressName.length > 1) && (siteAddressName.length > 1)) {
        self.addressCompletionLabel.text = @"Details entered";
    }
    else
    {
        self.addressCompletionLabel.text = @"Not complete";
    }
    
    // Appliance Details
    NSString *applianceLocation = [self.managedObject valueForKey:@"applianceLocation"];
    NSString *applianceType = [self.managedObject valueForKey:@"applianceType"];
    NSString *applianceMake = [self.managedObject valueForKey:@"applianceMake"];
    NSString *applianceModel = [self.managedObject valueForKey:@"applianceModel"];
 
    if ((applianceLocation.length > 1) && (applianceType.length > 1) &&  (applianceMake.length > 1) &&  (applianceModel.length > 1) ) {
        self.applianceCompletionDetailsLabel.text = @"Details entered";
    }
    else
    {
        self.applianceCompletionDetailsLabel.text = @"Not complete";
    }
    
        
    // customer signature
    NSString *customerSignatureName = [self.managedObject valueForKey:@"customerSignoffName"];
    
    if ((customerSignatureName.length > 1)) {
        self.customerSignatureCompletionLabel.text = @"Details entered";
    }
    else
    {
        self.customerSignatureCompletionLabel.text = @"Not complete";
    }
    
    
    // engineer signature
    NSString *engineerSignOffName = [self.managedObject valueForKey:@"engineerSignoffEngineerName"];
    NSString *engineerSignOffIDCardNumber = [self.managedObject valueForKey:@"engineerSignoffEngineerIDCardRegNumber"];
    
    if ((engineerSignOffName.length > 1) && (engineerSignOffIDCardNumber.length > 1)) {
        self.engineerSignoffCompletionLabel.text = @"Details entered";
    }
    else
    {
        self.engineerSignoffCompletionLabel.text = @"Not complete";
    }
 
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select row at index path");
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 9) {
        // TODO: set correct segues
        if ([self.recordType isEqualToString:@"Landlord Gas Safety Record"]) {
            [self performSegueWithIdentifier:@"FinalChecksLGSRSegue" sender:nil];
        }
        else if([self.recordType isEqualToString:@"LPG Gas Safety Record"])
        {
            [self performSegueWithIdentifier:@"FinalChecksLPGLGSRSegue" sender:nil];
        }
    }
}


-(void)generatingHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Generating";
    [HUD show:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"AddressDetailsSegue"]) {
        AddressDetailsCertificateTVC *addressDetailsCertificateTVC = segue.destinationViewController;
        addressDetailsCertificateTVC.managedObject = managedObject;
        addressDetailsCertificateTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"BreakdownApplianceDetailsSegue"]) {
             BreakdownServiceRecordApplianceCheckDetailsTVC *breakdownServiceRecordAplianceRecordApplianceChecksDetailTVC = segue.destinationViewController;
             breakdownServiceRecordAplianceRecordApplianceChecksDetailTVC.managedObject = managedObject;
             breakdownServiceRecordAplianceRecordApplianceChecksDetailTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"AdditionalNotesSegue"]) {
        BreakdownServiceAdditionalNotesTVC *breakdownServiceRecordAdditionalNotesTVC = segue.destinationViewController;
        breakdownServiceRecordAdditionalNotesTVC.managedObject = managedObject;
        breakdownServiceRecordAdditionalNotesTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"BreakdownServiceActionsFaultsRemedialSegue"]) {
        BreakdownServiceFaultsActionsRemedialTVC *breakdownServiceActionsFaultsTVC = segue.destinationViewController;
        breakdownServiceActionsFaultsTVC.managedObject = managedObject;
        breakdownServiceActionsFaultsTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"ApplianceChecksSegue"]) {
        BreakdownServiceChecksTVC *breakdownServiceCheckTVC = segue.destinationViewController;
        breakdownServiceCheckTVC.managedObject = managedObject;
        breakdownServiceCheckTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"EngineerSignOffSegue"]) {
        EngineerSignoffTVC *engineerSignoffTVC = segue.destinationViewController;
        engineerSignoffTVC.managedObject = managedObject;
        engineerSignoffTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"CustomerSignatureSegue"]) {
        CustomerSignoffTVC *customerSignoffTVC = segue.destinationViewController;
        customerSignoffTVC.certificateReferenceNumber = self.uniqueReferenceLabel.text;
        customerSignoffTVC.managedObject = managedObject;
        customerSignoffTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"ShowDateTimeSelectionSegue"]) {
        
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
    }
    else if ([segue.identifier isEqualToString:@"viewCertificateSegue"]) {
        [self SaveAll];
        BreakdownServicingViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceRecord *cert;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceRecord class]]) {
            cert = (MaintenanceServiceRecord *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceRecord = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
 
    else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
        [self SaveAll];
        BreakdownServicingViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceRecord *cert;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceRecord class]]) {
            cert = (MaintenanceServiceRecord *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceRecord = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
        [self SaveAll];
        BreakdownServicingViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceRecord *cert;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceRecord class]]) {
            cert = (MaintenanceServiceRecord *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceRecord = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    
    else if ([segue.identifier isEqualToString:@"dropboxCertificateSegue"]) {
        [self SaveAll];
        BreakdownServicingViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceRecord *cert;
        pdfView.mode = @"dropbox";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceRecord class]]) {
            cert = (MaintenanceServiceRecord *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceRecord = cert;
        pdfView.managedObjectContext = managedObjectContext;
    } 
}

- (void)theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller
{
    //set Date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM yyyy"];
    [self.managedObject setValue:controller.inputDate forKey:@"date"];
    NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
    self.dateLabel.text = dateLabelString;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
   
    if (![self.uniqueReferenceLabel.text isEqualToString:@""]) {
     
        [self SaveAll];
        [self.navigationController popViewControllerAnimated:YES];
        updateCompletionBlock();
    }
}


-(void)SaveAll
{
    
    if (![self.uniqueReferenceLabel.text isEqualToString:@""]) {
        
        [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
        [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
        
        [self.managedObject setValue:self.uniqueReferenceLabel.text forKey:@"uniqueSerialNumber"];
        
        
        [self.managedObject setValue:[NSString checkForNilString:self.referenceTextField.text] forKey:@"reference"];
        
        
        // JobTypeSegement Control
        if (self.jobTypeSegmentControl.selectedSegmentIndex == 0) {
            [self.managedObject setValue:@"Not Set" forKey:@"jobType"];
        }
        else if(self.jobTypeSegmentControl.selectedSegmentIndex == 1)
        {
            [self.managedObject setValue:@"Breakdown" forKey:@"jobType"];
        }
        else if (self.jobTypeSegmentControl.selectedSegmentIndex == 2)
        {
            [self.managedObject setValue:@"Service" forKey:@"jobType"];
        }
        else
        {
            [self.managedObject setValue:@"Not Set" forKey:@"jobType"];
        }
        
         //      [self.managedObject setValue:@"action notes" forKey:@"actionRemedialWork"];
       // [self.managedObject setValue:@"some notes" forKey:@"additionalNotes"];
        
        
        [self.managedObject setValue:[NSString checkForNilString:self.recordType] forKey:@"recordType"];
        
        
        [self.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
             
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Name required." message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
