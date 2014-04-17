//
//  ExpenseDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 31/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ExpenseDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Expense.h"
#import "ExpenseItemsHeaderTVC.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"
#import "ExpensesViewController.h"

@interface ExpenseDetailTVC ()

@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation ExpenseDetailTVC

@synthesize entityName;

@synthesize uniqueClaimReferenceLabel;
@synthesize referenceTextField;
@synthesize expenseClaimDateLabel;
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
        
        self.uniqueClaimReferenceLabel.text =  [NSString stringWithFormat:@"EXPS-%@",[NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
       // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        self.expenseClaimDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueClaimReferenceLabel.text = [self.managedObject valueForKey:@"uniqueClaimNo"];
        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
          //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.expenseClaimDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
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
    
   else if ([segue.identifier isEqualToString:@"SelectEngineerSegue"]) {
        
        EngineerLookupTVC *engineerLookupTVC = segue.destinationViewController;
        engineerLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"ExpenseItemsHeaderSegue"]) {
        ExpenseItemsHeaderTVC *expenseItemsHeaderTVC = segue.destinationViewController;
        expenseItemsHeaderTVC.uniqueClaimNumber = self.uniqueClaimReferenceLabel.text;
        expenseItemsHeaderTVC.managedObject = managedObject;
        expenseItemsHeaderTVC.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"viewCertificateSegue"]) {
        [self SaveAll];
        ExpensesViewController *pdfView = segue.destinationViewController;
        Expense *cert;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[Expense class]]) {
            cert = (Expense *) self.managedObject;
        }
        pdfView.currentExpense = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"emailCertificateSegue"]) {
        ExpensesViewController *pdfView = segue.destinationViewController;
        Expense *cert;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[Expense class]]) {
            cert = (Expense *) self.managedObject;
        }
        pdfView.currentExpense = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"printCertificateSegue"]) {
        [self SaveAll];
        ExpensesViewController *pdfView = segue.destinationViewController;
        Expense *cert;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[Expense class]]) {
            cert = (Expense *) self.managedObject;
        }
        pdfView.currentExpense = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"dropboxCertificateSegue"]) {
        [self SaveAll];
        ExpensesViewController *pdfView = segue.destinationViewController;
        Expense *cert;
        pdfView.mode = @"dropbox";
        if ([self.managedObject isKindOfClass:[Expense class]]) {
            cert = (Expense *) self.managedObject;
        }
        pdfView.currentExpense = cert;
        pdfView.managedObjectContext = managedObjectContext;
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"viewCertificateSegue"] ||
        [identifier isEqualToString:@"emailCertificateSegue"] ||
        [identifier isEqualToString:@"printCertificateSegue"]
        ) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        if ( [LACHelperMethods companyRecordPresent:self.managedObjectContext ]) {
            
            segueShouldOccur = YES;
        }
        else
        {
            segueShouldOccur = NO;
            
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"No Company Details set"
                                         message:@"You need to set your company details, go to Settings -> Company Details and fill them out. Then return back here and select the view option again."
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
    self.expenseClaimDateLabel.text = dateLabelString;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theEngineerWasSelectedFromTheList:(EngineerLookupTVC *)controller
{
    self.engineerNameLabel.text = controller.selectedEngineer.engineerName;
    
}

-(void)SaveAll
{
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.uniqueClaimReferenceLabel.text] forKey:@"uniqueClaimNo"];
    [self.managedObject setValue:[NSString checkForNilString:self.referenceTextField.text] forKey:@"reference"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.engineerNameLabel.text] forKey:@"engineerName"];
    
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
