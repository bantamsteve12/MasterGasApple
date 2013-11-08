//
//  MileageItemDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MileageItemDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"


@interface MileageItemDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation MileageItemDetailTVC


@synthesize selectedMileageItem;
@synthesize entityName;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;


@synthesize journeyDescriptionTextField;
@synthesize startMileageTextField;
@synthesize finishMilageTextField;
@synthesize totalMilesTextField;
@synthesize journeyNotesTextField;
@synthesize vehicleRegistrationTextField;
@synthesize dateLabel;

@synthesize updateCompletionBlock;

@synthesize uniqueClaimNo;

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
    
    
    NSLog(@"viewDidLoad");
    NSLog(@"claimno: %@", self.uniqueClaimNo);
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    
    if (self.selectedMileageItem == nil) {
        NSLog(@"insert new detail");
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MileageItem" inManagedObjectContext:self.managedObjectContext];
    }
    else
    {
        self.managedObject = self.selectedMileageItem;
        
        
        NSDate *expenseItemDate = [self.managedObject valueForKey:@"date"];
        
        if (expenseItemDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
           // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
        
        journeyDescriptionTextField.text = [self.managedObject valueForKey:@"journeyDescription"];
        startMileageTextField.text = [self.managedObject valueForKey:@"startMileage"];
        finishMilageTextField.text = [self.managedObject valueForKey:@"finishMileage"];
        totalMilesTextField.text = [self.managedObject valueForKey:@"totalMileage"];
        journeyNotesTextField.text = [self.managedObject valueForKey:@"journeyNotes"];
        vehicleRegistrationTextField.text = [self.managedObject valueForKey:@"vehicleRegistration"];
    }
}



- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


#pragma Delegate methods

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

- (void)theVehicleRegistrationWasSelectedFromTheList:(VehicleRegistrationLookupTVC *)controller
{
    self.vehicleRegistrationTextField.text = controller.selectedVehicleRegistration.name;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"SelectVehicleRegistrationSegue"]) {
        VehicleRegistrationLookupTVC *vehicleRegistrationLookupTVC = segue.destinationViewController;
        vehicleRegistrationLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"ShowDateTimeSelectionSegue"]) {
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
    }
}



- (IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self.managedObject setValue:[prefs valueForKey:@"companyId"] forKey:@"companyId"];
    [self.managedObject setValue:[prefs valueForKey:@"engineerId"] forKey:@"engineerId"];
    
    NSLog(@"saveButtonTouched for ApplianceInspection Detail");
    NSLog(@"uniqueClaimNo: %@", self.uniqueClaimNo);
    
    
    [self.managedObject setValue:self.uniqueClaimNo forKey:@"mileageClaimUniqueNo"];
    
    
    [self.managedObject setValue:self.journeyDescriptionTextField.text forKey:@"journeyDescription"];
    [self.managedObject setValue:self.startMileageTextField.text forKey:@"startMileage"];
    [self.managedObject setValue:self.finishMilageTextField.text forKey:@"finishMileage"];
    [self.managedObject setValue:self.totalMilesTextField.text forKey:@"totalMileage"];
    [self.managedObject setValue:self.journeyNotesTextField.text forKey:@"journeyNotes"];
    [self.managedObject setValue:self.vehicleRegistrationTextField.text forKey:@"vehicleRegistration"];


//    [self.managedObject setValue:[NSNumber numberWithInt:SDObjectEdited] forKey:@"syncStatus"];
    [self.managedObject.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObject.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
    
    

    
//    [self.managedObject setValue:[NSNumber numberWithInt:SDObjectEdited] forKey:@"syncStatus"];
    [self.navigationController popViewControllerAnimated:YES];
    updateCompletionBlock();
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
