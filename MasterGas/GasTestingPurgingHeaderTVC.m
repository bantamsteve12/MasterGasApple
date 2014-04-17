//
//  GasTestingPurgingHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 12/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "GasTestingPurgingHeaderTVC.h"
#import "SDCoreDataController.h"
#import "Customer.h"
#import "NonDomesticPurgingTesting.h"
#import "AddressDetailsCertificateTVC.h"
#import "EngineerSignoffTVC.h"
#import "CustomerSignoffTVC.h"
#import "NSString+Additions.h"
#import "TightnessTestDetailsTVC.h"
#import "PurgingChecksTVC.h"
#import "StrengthTestChecksTVC.h"
#import "GasTestingAndPurgingViewController.h"
#import "LACHelperMethods.h"


@interface GasTestingPurgingHeaderTVC ()

@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSManagedObjectContext *applianceManagedObjectContext;

@end

@implementation GasTestingPurgingHeaderTVC

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
@synthesize installationIsSafeOrUnsafeSegementControl;

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
        
        
        self.installationIsSafeOrUnsafeSegementControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"Not Set", @"Safe", @"Unsafe"] withValue:[self.managedObject valueForKey:@"installationSafeOrUnsafe"]];
        

        
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
    else if ([segue.identifier isEqualToString:@"TightnessTestChecksSegue"]) {
        TightnessTestDetailsTVC *checksTVC = segue.destinationViewController;
        checksTVC.managedObject = managedObject;
        checksTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"PurgingTestChecksSegue"]) {
        PurgingChecksTVC *checksTVC = segue.destinationViewController;
        checksTVC.managedObject = managedObject;
        checksTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"StrengthTestChecksSegue"]) {
        StrengthTestChecksTVC *checksTVC = segue.destinationViewController;
        checksTVC.managedObject = managedObject;
        checksTVC.managedObjectContext = managedObjectContext;
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
    else if ([segue.identifier isEqualToString:@"ShowDateTimeSelectionSegue"]) {
        
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
    }
     else if ([segue.identifier isEqualToString:@"viewCertificateSegue"]) {
        [self SaveTest];
        GasTestingAndPurgingViewController *pdfView = segue.destinationViewController;
        NonDomesticPurgingTesting *cert;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[NonDomesticPurgingTesting class]]) {
            cert = (NonDomesticPurgingTesting *) self.managedObject;
        }
        pdfView.currentCertificate = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
        GasTestingAndPurgingViewController *pdfView = segue.destinationViewController;
        NonDomesticPurgingTesting *cert;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[NonDomesticPurgingTesting class]]) {
            cert = (NonDomesticPurgingTesting *) self.managedObject;
        }
        pdfView.currentCertificate = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    
    else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
        GasTestingAndPurgingViewController *pdfView = segue.destinationViewController;
        NonDomesticPurgingTesting *cert;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[NonDomesticPurgingTesting class]]) {
            cert = (NonDomesticPurgingTesting *) self.managedObject;
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
      
        
        [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"Not Set", @"Safe", @"Unsafe"]withIndex:self.installationIsSafeOrUnsafeSegementControl.selectedSegmentIndex] forKey:@"installationSafeOrUnsafe"];
        
        NSLog(@"installationSafeOrUnsafe %@", [self.managedObject valueForKey:@"installationSafeOrUnsafe"]);
        
        
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
    [formatter setDateFormat:@"d MMMM yyyy"];
    [self.managedObject setValue:controller.inputDate forKey:@"date"];
    NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
    self.certificateDateLabel.text = dateLabelString;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
    
    if (![self.certificateUniqueReferenceLabel.text isEqualToString:@""]) {
        
        [self SaveTest];
        [self.navigationController popViewControllerAnimated:YES];
        updateCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Name required." message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"viewCertificateSegue"] ||
        [identifier isEqualToString:@"emailCertificateSegue"] ||
        [identifier isEqualToString:@"printCertificateSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        if (self.installationIsSafeOrUnsafeSegementControl.selectedSegmentIndex > 0) {
            
            segueShouldOccur = YES;
        }
        else
        {
            segueShouldOccur = NO;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Installation Safe / Unsafe not set"
                                         message:@"Please set the installation safety declaration status above before proceeding. (Safe or Unsafe)"
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


-(void)viewWillDisappear:(BOOL)animated
{
    [self SaveTest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
