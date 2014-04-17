//
//  EngineerSignoffTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "EngineerSignoffTVC.h"
#import "SDCoreDataController.h"
#import "Certificate.h"
#import "ApplianceInspection.h"
#import "Company.h"

@interface EngineerSignoffTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property CGPoint originalCenter;

@end

@implementation EngineerSignoffTVC

@synthesize entityName;

@synthesize engineerSignoffTradingTitleTextField;
@synthesize engineerSignoffAddressLine1TextField;
@synthesize engineerSignoffAddressLine2TextField;
@synthesize engineerSignoffAddressLine3TextField;
@synthesize engineerSignoffPostcodeTextField;
@synthesize engineerSignoffMobileNumberTextField;
@synthesize engineerSignoffTelNumberTextField;
@synthesize engineerSignoffCompanyGasSafeRegNumberTextField;
@synthesize engineerSignoffEngineerNameLabel;
@synthesize engineerSignoffEngineerIDCardRegNumberLabel;
@synthesize engineerSignoffDateLabel;

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize dateFormatter;
@synthesize companyRecords;


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
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
  //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateFormat:@"d MMMM yyyy"];

    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    // load values if present
    self.engineerSignoffTradingTitleTextField.text = [self.managedObject valueForKey:@"engineerSignoffTradingTitle"];
    self.engineerSignoffAddressLine1TextField.text = [self.managedObject valueForKey:@"engineerSignoffAddressLine1"];
    self.engineerSignoffAddressLine2TextField.text = [self.managedObject valueForKey:@"engineerSignoffAddressLine2"];
    self.engineerSignoffAddressLine3TextField.text = [self.managedObject valueForKey:@"engineerSignoffAddressLine3"];
    self.engineerSignoffPostcodeTextField.text = [self.managedObject valueForKey:@"engineerSignoffPostcode"];
    self.engineerSignoffTelNumberTextField.text = [self.managedObject valueForKey:@"engineerSignoffTelNumber"];
    self.engineerSignoffMobileNumberTextField.text = [self.managedObject valueForKey:@"engineerSignoffMobileNumber"];
    self.engineerSignoffCompanyGasSafeRegNumberTextField.text = [self.managedObject valueForKey:@"engineerSignoffCompanyGasSafeRegNumber"];
   
    
    if ([[self.managedObject valueForKey:@"engineerSignoffEngineerName"] length] < 1) {
        self.engineerSignoffEngineerNameLabel.text = @"Select Engineer";
    }
    else
    {
    self.engineerSignoffEngineerNameLabel.text = [self.managedObject valueForKey:@"engineerSignoffEngineerName"];
    }
    
    self.engineerSignoffEngineerIDCardRegNumberLabel.text = [self.managedObject valueForKey:@"engineerSignoffEngineerIDCardRegNumber"];

    // set default value date if required.
   
    NSDate *engineerSignOffDate = [self.managedObject valueForKey:@"engineerSignoffDate"];
    
    if (engineerSignOffDate == nil) {
        
        [self.managedObject setValue:[NSDate date] forKey:@"engineerSignoffDate"];
        self.engineerSignoffDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"engineerSignoffDate"]];
    }
    else
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d MMMM yyyy"];
        
        NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:engineerSignOffDate]];
        self.engineerSignoffDateLabel.text = dateLabelString;
    }
    
    NSString *tradingTitle = [self.managedObject valueForKey:@"engineerSignoffTradingTitle"];
   
    if (tradingTitle.length < 1) {
        [self loadCompanyRecordFromCoreData];
        
        if (self.companyRecords.count > 0) {
            Company *company = [self.companyRecords objectAtIndex:0];
            self.engineerSignoffTradingTitleTextField.text = [company valueForKey:@"companyName"];
            self.engineerSignoffAddressLine1TextField.text = [company valueForKey:@"companyAddressLine1"];
            self.engineerSignoffAddressLine2TextField.text = [company valueForKey:@"companyAddressLine2"];
            self.engineerSignoffAddressLine3TextField.text = [company valueForKey:@"companyAddressLine3"];
            self.engineerSignoffPostcodeTextField.text = [company valueForKey:@"companyPostcode"];
            self.engineerSignoffTelNumberTextField.text = [company valueForKey:@"companyTelNumber"];
            self.engineerSignoffMobileNumberTextField.text =  [company valueForKey:@"companyMobileNumber"]; 
            self.engineerSignoffCompanyGasSafeRegNumberTextField.text = [company valueForKey:@"companyGSRNumber"];
         
        }
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}



- (void)loadCompanyRecordFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
        self.companyRecords = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ShowDateTimeSelectionSegue"]) {
    
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
    
        // set default value date if required.
        if ([self.managedObject valueForKey:@"engineerSignoffDate"] == nil) {
            [self.managedObject setValue:[NSDate date] forKey:@"engineerSignoffDate"];
            self.engineerSignoffDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"engineerSignoffDate"]];
        }
        else
        {
            dateTimePickerTVC.inputDate =[self.managedObject valueForKey:@"engineerSignoffDate"];
        }
    }
    else if([segue.identifier isEqualToString:@"SelectEngineerSegue"]) {
        
        EngineerLookupTVC *engineerLookupTVC = segue.destinationViewController;
        engineerLookupTVC.delegate = self;
    }
}


- (void) theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller
{
    //set Date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM yyyy"];
    [self.managedObject setValue:controller.inputDate forKey:@"engineerSignoffDate"];
    NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
    self.engineerSignoffDateLabel.text = dateLabelString;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) theEngineerWasSelectedFromTheList:(EngineerLookupTVC *)controller
{
    self.engineerSignoffEngineerNameLabel.text = controller.selectedEngineer.engineerName;
    self.engineerSignoffEngineerIDCardRegNumberLabel.text = controller.selectedEngineer.engineerGSRIDNumber;
    
    [self.managedObject setValue:[NSString stringWithFormat:@"eng-%@.png", controller.selectedEngineer.engineerId] forKey:@"engineerSignatureFilename"];
    
}


- (IBAction)saveButtonTouched:(id)sender {
   
    [self SaveAll];
    [self.navigationController popViewControllerAnimated:YES];
     //  addDateCompletionBlock();
  
}


-(void)SaveAll
{
    
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffTradingTitleTextField.text] forKey:@"engineerSignoffTradingTitle"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffAddressLine1TextField.text] forKey:@"engineerSignoffAddressLine1"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffAddressLine2TextField.text] forKey:@"engineerSignoffAddressLine2"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffAddressLine3TextField.text] forKey:@"engineerSignoffAddressLine3"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffPostcodeTextField.text] forKey:@"engineerSignoffPostcode"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffTelNumberTextField.text] forKey:@"engineerSignoffTelNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffMobileNumberTextField.text] forKey:@"engineerSignoffMobileNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffCompanyGasSafeRegNumberTextField.text] forKey:@"engineerSignoffCompanyGasSafeRegNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffEngineerNameLabel.text] forKey:@"engineerSignoffEngineerName"];
    [self.managedObject setValue:[NSString checkForNilString:self.engineerSignoffEngineerIDCardRegNumberLabel.text ]forKey:@"engineerSignoffEngineerIDCardRegNumber"];
    
    [self.managedObject setValue:[NSString checkForNilString:[self.managedObject valueForKey:@"engineerSignatureFilename"]] forKey:@"engineerSignatureFilename"];
    
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
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
