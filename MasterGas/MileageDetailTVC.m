//
//  MileageDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MileageDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "MileageItemsHeaderTVC.h"
#import "NSString+Additions.h"
#import "Mileage.h"
#import "MileageViewController.h"

@interface MileageDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation MileageDetailTVC

@synthesize entityName;
@synthesize uniqueClaimReferenceTextField;
@synthesize referenceTextField;
@synthesize mileageClaimDateLabel;
@synthesize engineerNameLabel;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;


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
        
        self.uniqueClaimReferenceTextField.text =  [NSString stringWithFormat:@"MILE-%@",[NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
       // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        self.mileageClaimDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueClaimReferenceTextField.text = [self.managedObject valueForKey:@"uniqueClaimNo"];
        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
          //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.mileageClaimDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
    }
    self.referenceTextField.text = [self.managedObject valueForKey:@"reference"];
    self.engineerNameLabel.text = [self.managedObject valueForKey:@"engineerName"];
}




- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
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
   
    
    if ([segue.identifier isEqualToString:@"ShowDateTimeSelectionSegue"]) {
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
    }
    else if ([segue.identifier isEqualToString:@"MileageItemsHeaderSegue"]) {
        MileageItemsHeaderTVC *mileageItemsHeaderTVC = segue.destinationViewController;
        mileageItemsHeaderTVC.uniqueClaimNumber = self.uniqueClaimReferenceTextField.text;
        mileageItemsHeaderTVC.managedObject = managedObject;
        mileageItemsHeaderTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"SelectEngineerSegue"]) {
        
        EngineerLookupTVC *engineerLookupTVC = segue.destinationViewController;
        engineerLookupTVC.delegate = self;
    }
     else if ([segue.identifier isEqualToString:@"viewCertificateSegue"]) {
         [self SaveAll];
         MileageViewController *pdfView = segue.destinationViewController;
         Mileage *mileage;
         pdfView.mode = @"view";
         if ([self.managedObject isKindOfClass:[Mileage class]]) {
             mileage = (Mileage *) self.managedObject;
         }
         pdfView.currentMileage = mileage;
         pdfView.managedObjectContext = managedObjectContext;
     }
     else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
        [self SaveAll];
         MileageViewController *pdfView = segue.destinationViewController;
         Mileage *mileage;
         pdfView.mode = @"email";
         if ([self.managedObject isKindOfClass:[Mileage class]]) {
             mileage = (Mileage *) self.managedObject;
         }
         pdfView.currentMileage = mileage;
         pdfView.managedObjectContext = managedObjectContext;
     }
     else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
         [self SaveAll];
         MileageViewController *pdfView = segue.destinationViewController;
         Mileage *mileage;
         pdfView.mode = @"print";
         if ([self.managedObject isKindOfClass:[Mileage class]]) {
             mileage = (Mileage *) self.managedObject;
         }
         pdfView.currentMileage = mileage;
         pdfView.managedObjectContext = managedObjectContext;
     }
     else if ([segue.identifier isEqualToString:@"dropboxCertificateSegue"]) {
         [self SaveAll];
         MileageViewController *pdfView = segue.destinationViewController;
         Mileage *mileage;
         pdfView.mode = @"dropbox";
         if ([self.managedObject isKindOfClass:[Mileage class]]) {
             mileage = (Mileage *) self.managedObject;
         }
         pdfView.currentMileage = mileage;
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
    self.mileageClaimDateLabel.text = dateLabelString;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theEngineerWasSelectedFromTheList:(EngineerLookupTVC *)controller
{
    self.engineerNameLabel.text = controller.selectedEngineer.engineerName;
    
}


-(void)SaveAll
{
    if (![self.uniqueClaimReferenceTextField.text isEqualToString:@""]) {
        
        [self.managedObject setValue:self.uniqueClaimReferenceTextField.text forKey:@"uniqueClaimNo"];
        [self.managedObject setValue:self.engineerNameLabel.text forKey:@"engineerName"];
        
        
        if (self.referenceTextField.text.length < 1) {
            [self.managedObject setValue:@"" forKey:@"reference"];
        }
        else
        {
            [self.managedObject setValue:self.referenceTextField.text forKey:@"reference"];
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
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Required" message:@"Unique Reference Field is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }

}

- (IBAction)saveButtonTouched:(id)sender {
    
    
    if (![self.uniqueClaimReferenceTextField.text isEqualToString:@""]) {
        
        [self SaveAll];
        [self.navigationController popViewControllerAnimated:YES];
        updateCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Required" message:@"Unique Reference Field is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
