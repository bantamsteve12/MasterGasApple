//
//  GasMaintenanceChecklistHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "GasMaintenanceChecklistHeaderTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Customer.h"

#import "MaintenanceServiceCheck.h"
#import "AddressDetailsCertificateTVC.h"
#import "EngineerSignoffTVC.h"
#import "CustomerSignoffTVC.h"
#import "NSString+Additions.h"

#import "GasMaintenanceApplianceDetailsTVC.h"
#import "GasMaintenanceFindingsTVC.h"
#import "GasMaintenanceServiceChecksTVC.h"
#import "GasMaintenanceSafetyChecksTVC.h"
#import "PDFGasMaintenanceChecklistViewController.h"

#import "LACHelperMethods.h"

@interface GasMaintenanceChecklistHeaderTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation GasMaintenanceChecklistHeaderTVC


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
@synthesize applianceCompletionChecksLabel;
@synthesize findingsLabel;
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
        
        NSLog(@"value: %@", value);
        
        if ([value isEqualToString:@"Not Set"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 0;
        }
        else if ([value isEqualToString:@"Maintenance"]) {
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
        
        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
        
        
        // Set segment control
        NSString *value = [self.managedObject valueForKey:@"jobType"];
        
        NSLog(@"value: %@", value);
        
        if ([value isEqualToString:@"Not Set"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 0;
        }
        else if ([value isEqualToString:@"Maintenance"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 1;
        }
        else if ([value isEqualToString:@"Service"]) {
            self.jobTypeSegmentControl.selectedSegmentIndex = 2;
        }
        else {
            self.jobTypeSegmentControl.selectedSegmentIndex = 0;
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
    else if ([segue.identifier isEqualToString:@"ApplianceDetailsSegue"]) {
        GasMaintenanceApplianceDetailsTVC *gasMaintenanceApplianceDetailsTVC = segue.destinationViewController;
        gasMaintenanceApplianceDetailsTVC.managedObject = managedObject;
        gasMaintenanceApplianceDetailsTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"FindingsSegue"]) {
        GasMaintenanceFindingsTVC *findingsTVC = segue.destinationViewController;
        findingsTVC.managedObject = managedObject;
        findingsTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"gasMaintenanceServiceChecksTVC"]) {
        GasMaintenanceServiceChecksTVC *gasMaintenanceServiceChecksTVC = segue.destinationViewController;
        gasMaintenanceServiceChecksTVC.managedObject = managedObject;
        gasMaintenanceServiceChecksTVC.managedObjectContext = managedObjectContext;
    }
    
    else if ([segue.identifier isEqualToString:@"gasSafetyServiceChecksSegue"]) {
        GasMaintenanceSafetyChecksTVC *gasMaintenanceSafetyChecksTVC = segue.destinationViewController;
        gasMaintenanceSafetyChecksTVC.managedObject = managedObject;
        gasMaintenanceSafetyChecksTVC.managedObjectContext = managedObjectContext;
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
        PDFGasMaintenanceChecklistViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceCheck *cert;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceCheck class]]) {
            cert = (MaintenanceServiceCheck *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceCheck = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
        [self SaveAll];
        PDFGasMaintenanceChecklistViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceCheck *cert;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceCheck class]]) {
            cert = (MaintenanceServiceCheck *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceCheck = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
        [self SaveAll];
        PDFGasMaintenanceChecklistViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceCheck *cert;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceCheck class]]) {
            cert = (MaintenanceServiceCheck *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceCheck = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"dropboxCertificateSegue"]) {
         [self SaveAll];
        PDFGasMaintenanceChecklistViewController *pdfView = segue.destinationViewController;
        MaintenanceServiceCheck *cert;
        pdfView.mode = @"dropbox";
        if ([self.managedObject isKindOfClass:[MaintenanceServiceCheck class]]) {
            cert = (MaintenanceServiceCheck *) self.managedObject;
        }
        pdfView.currentMaintenanceServiceCheck = cert;
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
            [self.managedObject setValue:@"Maintenance" forKey:@"jobType"];
        }
        else if (self.jobTypeSegmentControl.selectedSegmentIndex == 2)
        {
            [self.managedObject setValue:@"Service" forKey:@"jobType"];
        }
        else
        {
            [self.managedObject setValue:@"Not Set" forKey:@"jobType"];
        }
        
        
        
        NSString *objectId = [self.managedObject valueForKey:@"objectId"];
        
        if (objectId.length > 1) {
            [self.managedObject setValue:[NSNumber numberWithInt:SDObjectEdited] forKey:@"syncStatus"];
        }
        else
        {
            [self.managedObject setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
        }
        
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

- (IBAction)saveButtonTouched:(id)sender {
    
    if (![self.uniqueReferenceLabel.text isEqualToString:@""]) {
        [self SaveAll];
        [self.navigationController popViewControllerAnimated:YES];
        updateCompletionBlock();
        
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
