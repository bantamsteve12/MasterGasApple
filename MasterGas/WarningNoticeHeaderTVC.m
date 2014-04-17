//
//  WarningNoticeHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "WarningNoticeHeaderTVC.h"

#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Customer.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"
#import "AddressDetailsCertificateTVC.h"
#import "EngineerSignoffTVC.h"
#import "CustomerSignoffTVC.h"

#import "PDFWarningNoticeViewController.h"

#import "WarningNoticeDetailsTVC.h"



@interface WarningNoticeHeaderTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation WarningNoticeHeaderTVC


@synthesize recordPrefix;
@synthesize entityName;
@synthesize uniqueReferenceLabel;
@synthesize referenceTextField;
@synthesize dateLabel;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize addressCompletionLabel;
@synthesize detailsLabel;
@synthesize customerSignatureCompletionLabel;
@synthesize engineerSignoffCompletionLabel;

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
        
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueReferenceLabel.text = [self.managedObject valueForKey:@"warningNoticeNumber"];
        
        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
           //setTimeZone [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
    }
    self.referenceTextField.text = [self.managedObject valueForKey:@"referenceNumber"];
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
        self.detailsLabel.text = @"Details entered";
    }
    else
    {
        self.detailsLabel.text = @"Not complete";
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
    
    NSLog(@"prepare for segue called");
    
    if ([segue.identifier isEqualToString:@"AddressDetailsSegue"]) {
        AddressDetailsCertificateTVC *addressDetailsCertificateTVC = segue.destinationViewController;
        addressDetailsCertificateTVC.managedObject = managedObject;
        addressDetailsCertificateTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"DetailsSegue"]) {
        WarningNoticeDetailsTVC *warningNoticeDetailsTVC = segue.destinationViewController;
        warningNoticeDetailsTVC.managedObject = managedObject;
        warningNoticeDetailsTVC.managedObjectContext = managedObjectContext;
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
        PDFWarningNoticeViewController *pdfView = segue.destinationViewController;
        WarningNotice *cert;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[WarningNotice class]]) {
            cert = (WarningNotice *) self.managedObject;
        }
        pdfView.currentWarningNotice = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
       [self SaveAll];
        PDFWarningNoticeViewController *pdfView = segue.destinationViewController;
        WarningNotice *cert;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[WarningNotice class]]) {
            cert = (WarningNotice *) self.managedObject;
        }
        pdfView.currentWarningNotice = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
        [self SaveAll];
        PDFWarningNoticeViewController *pdfView = segue.destinationViewController;
        WarningNotice *cert;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[WarningNotice class]]) {
            cert = (WarningNotice *) self.managedObject;
        }
        pdfView.currentWarningNotice = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    
    else if ([segue.identifier isEqualToString:@"dropboxCertificateSegue"]) {
        [self SaveAll];
        PDFWarningNoticeViewController *pdfView = segue.destinationViewController;
        WarningNotice *cert;
        pdfView.mode = @"dropbox";
        if ([self.managedObject isKindOfClass:[WarningNotice class]]) {
            cert = (WarningNotice *) self.managedObject;
        }
        pdfView.currentWarningNotice = cert;
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
        
        [self.managedObject setValue:self.uniqueReferenceLabel.text forKey:@"warningNoticeNumber"];
        
        [self.managedObject setValue:[NSString checkForNilString:self.referenceTextField.text] forKey:@"referenceNumber"];
        
        
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
    
        [self SaveAll];
        [self.navigationController popViewControllerAnimated:YES];
        updateCompletionBlock();
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
