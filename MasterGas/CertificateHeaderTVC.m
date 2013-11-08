//
//  CertificateHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 04/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "CertificateHeaderTVC.h"
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


@interface CertificateHeaderTVC ()

@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSManagedObjectContext *applianceManagedObjectContext;

@end

@implementation CertificateHeaderTVC

@synthesize certificatePrefix;
@synthesize entityName;
@synthesize certificateUniqueReferenceLabel;
@synthesize certificateReferenceTextField;
@synthesize certificateDateLabel;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize addressCompletionLabel;
@synthesize applianceInspectionCompletionLabel;
@synthesize finalChecksCompletionLabel;
@synthesize customerSignatureCompletionLabel;
@synthesize engineerSignoffCompletionLabel;
@synthesize certificateType;
@synthesize certificateTypeLabel;

@synthesize applianceCountLabel;

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
    
    self.certificateTypeLabel.text = [NSString checkForNilString:self.certificateType];
    if (self.managedObjectId == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        self.certificateUniqueReferenceLabel.text =  [NSString stringWithFormat:@"%@-%@",self.certificatePrefix, [NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
     //   [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        
        
        self.certificateDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.certificateUniqueReferenceLabel.text = [self.managedObject valueForKey:@"certificateNumber"];
        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
         //   [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.certificateDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
    }
    self.certificateReferenceTextField.text = [self.managedObject valueForKey:@"referenceNumber"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadApplianceItemsDataFromCoreData];
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
    
    // final checks
    NSString *finalCheckGasTightness = [self.managedObject valueForKey:@"finalCheckGasTightness"];
    NSString *finalCheckECV = [self.managedObject valueForKey:@"finalCheckECV"];
    NSString *finalCheckPipeworkSatisfactory = [self.managedObject valueForKey:@"finalCheckGasInstallationPipework"];
    NSString *finalCheckEquipotentialBonding = [self.managedObject valueForKey:@"finalCheckEquipotentialBonding"];

    if ((finalCheckGasTightness.length > 1) &&
        (finalCheckECV.length > 1) &&
        (finalCheckPipeworkSatisfactory.length > 1) &&
        (finalCheckEquipotentialBonding.length > 1))
    {
        self.finalChecksCompletionLabel.text = @"Details entered";
    }
    else
    {
        self.finalChecksCompletionLabel.text = @"Not complete";
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
        
        if ([self.certificateType isEqualToString:@"Landlord Gas Safety Record"]) {
            [self performSegueWithIdentifier:@"FinalChecksLGSRSegue" sender:nil];
        }
        else if([self.certificateType isEqualToString:@"LPG Gas Safety Record"])
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
    else if ([segue.identifier isEqualToString:@"FinalChecksLGSRSegue"]) {
        FinalLandlordCertChecksTVC *finalChecksTVC = segue.destinationViewController;
        finalChecksTVC.managedObject = managedObject;
        finalChecksTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"FinalChecksLPGLGSRSegue"]) {
        FinalLandlordCertChecksTVC *finalChecksTVC = segue.destinationViewController;
        finalChecksTVC.managedObject = managedObject;
        finalChecksTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"EngineerSignOffSegue"]) {
        EngineerSignoffTVC *engineerSignoffTVC = segue.destinationViewController;
        engineerSignoffTVC.managedObject = managedObject;
        engineerSignoffTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"CustomerSignatureSegue"]) {
        CustomerSignoffTVC *customerSignoffTVC = segue.destinationViewController;
        customerSignoffTVC.certificateReferenceNumber = self.certificateUniqueReferenceLabel.text;
        customerSignoffTVC.managedObject = managedObject;
        customerSignoffTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"ApplianceInspectionHeaderSegue"]) {
        AppInspectionHeaderTVC *applianceInspectionHeaderTVC = segue.destinationViewController;
        applianceInspectionHeaderTVC.certificateNumber = self.certificateUniqueReferenceLabel.text;
        applianceInspectionHeaderTVC.managedObject = managedObject;
        applianceInspectionHeaderTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"ShowDateTimeSelectionSegue"]) {
        
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
    }
    else if ([segue.identifier isEqualToString:@"viewCertificateSegue"]) {
        [self SaveTest];
         [self loadApplianceItemsDataFromCoreData];
            PDFViewController *pdfView = segue.destinationViewController;
            Certificate *cert;
            pdfView.mode = @"view";
            if ([self.managedObject isKindOfClass:[Certificate class]]) {
                cert = (Certificate *) self.managedObject;
            }
            pdfView.currentCertificate = cert;
          //  pdfView.managedObjectContext = managedObjectContext;
        
        // SJL added
         //   pdfView.applianceInspections = self.applianceItems;
            
    }
    else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
        PDFViewController *pdfView = segue.destinationViewController;
        Certificate *cert;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[Certificate class]]) {
            cert = (Certificate *) self.managedObject;
        }
        pdfView.currentCertificate = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }

    else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
        PDFViewController *pdfView = segue.destinationViewController;
        Certificate *cert;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[Certificate class]]) {
            cert = (Certificate *) self.managedObject;
        }
        pdfView.currentCertificate = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }

    else if ([segue.identifier isEqualToString:@"dropboxCertificateSegue"]) {
            PDFViewController *pdfView = segue.destinationViewController;
            Certificate *cert;
            pdfView.mode = @"dropbox";
            if ([self.managedObject isKindOfClass:[Certificate class]]) {
                cert = (Certificate *) self.managedObject;
            }
            pdfView.currentCertificate = cert;
            pdfView.managedObjectContext = managedObjectContext;
        }
    }

-(void)SaveTest
{
    
    if (![self.certificateUniqueReferenceLabel.text isEqualToString:@""]) {
        
        [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
        [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
        
         
        [self.managedObject setValue:self.certificateUniqueReferenceLabel.text forKey:@"certificateNumber"];
        [self.managedObject setValue:[NSString checkForNilString:self.certificateReferenceTextField.text] forKey:@"referenceNumber"];
        [self.managedObject setValue:[NSString checkForNilString:self.certificateType] forKey:@"certificateType"];
        
        
        [self.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
     //   [self.navigationController popViewControllerAnimated:YES];
      //  updateCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Name required." message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"viewCertificateSegue"]||
        [identifier isEqualToString:@"emailCertificateSegue"]||
        [identifier isEqualToString:@"printCertificateSegue"]||
        [identifier isEqualToString:@"dropboxCertificateSegue"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = NO; // you determine this
     
        if (applianceItems.count > 0) {
            segueShouldOccur = YES;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"No Appliance Inspections"
                                         message:@"Enter at least one appliance inspection."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}

- (void)theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller
{
    //set Date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM yyyy"];
    [self.managedObject setValue:controller.inputDate forKey:@"date"];
    NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
    self.certificateDateLabel.text = dateLabelString;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
    
     if (![self.certificateUniqueReferenceLabel.text isEqualToString:@""]) {
     
    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    [self.managedObject setValue:self.certificateUniqueReferenceLabel.text forKey:@"certificateNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.certificateReferenceTextField.text] forKey:@"referenceNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.certificateType] forKey:@"certificateType"];
    
         
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
     updateCompletionBlock();
    
     } else {
     UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Name required." message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [cannotSaveAlert show];
     } 
}


- (void)loadApplianceItemsDataFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
    //    [self.applianceManagedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ApplianceInspection"];
      
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (certificateReference == %@)", SDObjectDeleted, self.certificateUniqueReferenceLabel.text]];
      
        self.applianceItems = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
    
    if ([self.applianceItems count] > 0) {
        self.applianceCountLabel.text = [NSString stringWithFormat:@"%i Appliances", [self.applianceItems count]];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
