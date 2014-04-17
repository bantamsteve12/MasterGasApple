//
//  JobsheetHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 04/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "JobsheetHeaderTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Customer.h"
#import "Certificate.h"
#import "AddressDetailsCertificateTVC.h"
#import "FinalLandlordCertChecksTVC.h"
#import "EngineerSignoffTVC.h"
#import "AppInspectionHeaderTVC.h"
#import "CustomerSignoffTVC.h"
#import "NSString+Additions.h"
#import "JobsheetDetailsTVC.h"

@interface JobsheetHeaderTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSManagedObjectContext *applianceManagedObjectContext;
@end

@implementation JobsheetHeaderTVC


@synthesize certificatePrefix;
@synthesize entityName;
@synthesize uniqueReferenceLabel;
@synthesize referenceTextField;
@synthesize dateLabel;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize addressCompletionLabel;
@synthesize detailsCompletionLabel;
@synthesize customerSignatureCompletionLabel;
@synthesize engineerSignoffCompletionLabel;

@synthesize arrivalTimeLabel;
@synthesize departureTimeLabel;
@synthesize hoursOnSiteTextField;
@synthesize jobStatusLabel;
@synthesize travelTimeTextField;

@synthesize updateCompletionBlock;

@synthesize applianceItems;

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
  
    if (self.managedObjectId == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        self.uniqueReferenceLabel.text =  [NSString stringWithFormat:@"%@-%@",self.certificatePrefix, [NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
       // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueReferenceLabel.text = [self.managedObject valueForKey:@"jobsheetNo"];
        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
          //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
    }
    self.referenceTextField.text = [self.managedObject valueForKey:@"referenceNumber"];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    //[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
   

    
    NSDate *timeOfArrival = [self.managedObject valueForKey:@"timeOfArrival"];
    if (timeOfArrival != nil) {
         [self.dateFormatter setDateFormat:@"HH:mm"];
               self.arrivalTimeLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"timeOfArrival"]];
    }
    
    NSDate *timeOfDeparture = [self.managedObject valueForKey:@"timeOfDeparture"];
    if (timeOfDeparture != nil) {
         [self.dateFormatter setDateFormat:@"HH:mm"];
        self.departureTimeLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"timeOfDeparture"]];
    }
    
    self.hoursOnSiteTextField.text = [self.managedObject valueForKey:@"hours"];
    self.jobStatusLabel.text = [self.managedObject valueForKey:@"jobStatus"];
    self.travelTimeTextField.text = [self.managedObject valueForKey:@"travelTime"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
   // [self loadApplianceItemsDataFromCoreData];
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
    else if ([segue.identifier isEqualToString:@"JobStatusLookupSegue"]) {
         JobstatusLookupTVC *jobStatusLookupTVC = segue.destinationViewController;
         jobStatusLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"JobsheetDetailsSegue"]) {
        JobsheetDetailsTVC *jobsheetDetailsTVC = segue.destinationViewController;
        jobsheetDetailsTVC.managedObject = managedObject;
        jobsheetDetailsTVC.managedObjectContext = managedObjectContext;
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
        dateTimePickerTVC.tag = [NSNumber numberWithInt:0];
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
    }
    else if ([segue.identifier isEqualToString:@"ShowArrivalTimeSelectionSegue"]) {
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.tag = [NSNumber numberWithInt:1];
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"timeOfArrival"];
    }
    else if ([segue.identifier isEqualToString:@"ShowDepartureTimeSelectionSegue"]) {
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.tag = [NSNumber numberWithInt:2];
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"timeOfDeparture"];
    }
    else if ([segue.identifier isEqualToString:@"viewCertificateSegue"]) {
        [self SaveAll];
        JobsheetPDFViewController *pdfView = segue.destinationViewController;
        Jobsheet *cert;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[Jobsheet class]]) {
            cert = (Jobsheet *) self.managedObject;
        }
        pdfView.currentJobsheet = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
        [self SaveAll];
        JobsheetPDFViewController *pdfView = segue.destinationViewController;
        Jobsheet *cert;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[Jobsheet class]]) {
            cert = (Jobsheet *) self.managedObject;
        }
        pdfView.currentJobsheet = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
        [self SaveAll];
        JobsheetPDFViewController *pdfView = segue.destinationViewController;
        Jobsheet *cert;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[Jobsheet class]]) {
            cert = (Jobsheet *) self.managedObject;
        }
        pdfView.currentJobsheet = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"dropboxCertificateSegue"]) {
        [self SaveAll];
        JobsheetPDFViewController *pdfView = segue.destinationViewController;
        Jobsheet *cert;
        pdfView.mode = @"dropbox";
        if ([self.managedObject isKindOfClass:[Jobsheet class]]) {
            cert = (Jobsheet *) self.managedObject;
        }
        pdfView.currentJobsheet = cert;
        pdfView.managedObjectContext = managedObjectContext;    }
}

-(void)SaveAll
{
    if (![self.uniqueReferenceLabel.text isEqualToString:@""]) {
        
        [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
        [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
        
        [self.managedObject setValue:self.uniqueReferenceLabel.text forKey:@"jobsheetNo"];
        [self.managedObject setValue:[NSString checkForNilString:self.referenceTextField.text] forKey:@"referenceNumber"];
        
        [self.managedObject setValue:self.hoursOnSiteTextField.text forKey:@"hours"];
        [self.managedObject setValue:self.jobStatusLabel.text forKey:@"jobStatus"];
        
        [self.managedObject setValue:self.travelTimeTextField.text forKey:@"travelTime"];
        
        
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

- (void)theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller
{
    //set Date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    

    if ([controller.tag intValue] == 0) {
        [formatter setDateFormat:@"d MMMM yyyy"];
        [self.managedObject setValue:controller.inputDate forKey:@"date"];
        NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
        self.dateLabel.text = dateLabelString;
    }
    else if ([controller.tag intValue] == 1)
    {
        [formatter setDateFormat:@"HH:mm"];
        [self.managedObject setValue:controller.inputDate forKey:@"timeOfArrival"];
        NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
        self.arrivalTimeLabel.text = dateLabelString;
    }
    else if([controller.tag intValue] == 2)
    {
        [formatter setDateFormat:@"HH:mm"];
        [self.managedObject setValue:controller.inputDate forKey:@"timeOfDeparture"];
        NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
        self.departureTimeLabel.text = dateLabelString;
    }
    
       
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)theJobStatusWasSelected:(JobstatusLookupTVC *)controller
{
    self.jobStatusLabel.text = controller.selectedJobStatus.name;
    [self.navigationController popViewControllerAnimated:YES];
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
