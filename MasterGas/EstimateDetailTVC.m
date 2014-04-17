//
//  EstimateDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 13/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "EstimateDetailTVC.h"
#import "SDCoreDataController.h"
#import "Estimate.h"
#import "NSString+Additions.h"
#import "PDFEstimateViewController.h"
#import "EstimateItemsHeaderTVC.h"
#import "LACHelperMethods.h"
#import "EstimateDetailTVC.h"


@interface EstimateDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation EstimateDetailTVC

@synthesize entityName;
@synthesize uniqueEstimateNoLabel;
@synthesize referenceTextField;
@synthesize workOrderReferenceTextField;
@synthesize customerNameLabel;
@synthesize customerAddressPreviewLabel;
@synthesize subtotalLabel;
@synthesize vatLabel;
@synthesize totalLabel;
@synthesize dateLabel;
@synthesize termsLabel;
@synthesize numberOfExpenseItemsLabel;
@synthesize commentsTextField;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize siteAddressPreviewLabel;
@synthesize siteNameLabel;
@synthesize typeSegmentControl;

@synthesize estimateItems;

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
    
    NSLog(@"customer id %@", [self.managedObject valueForKey:@"customerId"]);
    
    if (self.managedObjectId == nil) {
        
        NSLog(@"managed Object = nil");
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        self.uniqueEstimateNoLabel.text =  [NSString stringWithFormat:@"EST-%@",[NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        
        NSString *defaultAmount = [NSString stringWithFormat:@"%@0.00", [LACHelperMethods getDefaultCurrency]];
        
        self.subtotalLabel.text = defaultAmount;
        self.vatLabel.text = defaultAmount;
        self.totalLabel.text = defaultAmount;
     
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueEstimateNoLabel.text = [self.managedObject valueForKey:@"uniqueEstimateNo"];
        self.referenceTextField.text = [self.managedObject valueForKey:@"reference"];
        self.workOrderReferenceTextField.text = [self.managedObject valueForKey:@"workOrderReference"];
        self.siteNameLabel.text = [self.managedObject valueForKey:@"siteName"];
       
        if ([[self.managedObject valueForKey:@"type"] isEqualToString:@"Estimate"]) {
            typeSegmentControl.selectedSegmentIndex = 0;
        } else if ([[self.managedObject valueForKey:@"type"] isEqualToString:@"Quote"])  {
            typeSegmentControl.selectedSegmentIndex = 1;
        }
        else {
            typeSegmentControl.selectedSegmentIndex = 0;
        }
        

        
        NSDate *invoiceDate = [self.managedObject valueForKey:@"date"];
        
        if (invoiceDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
            //   [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
        
        
        NSLog(@"invoice Vat: = %@", [self.managedObject valueForKey:@"vat"]);
        
        self.commentsTextField.text = [self.managedObject valueForKey:@"comment"];
        self.termsLabel.text = [self.managedObject valueForKey:@"terms"];
        
        self.customerNameLabel.text = [self.managedObject valueForKey:@"customerName"];
        self.customerAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", [NSString checkForNilString:[self.managedObject valueForKey:@"customerAddressLine1"]], [NSString checkForNilString:[self.managedObject valueForKey:@"customerPostcode"]]];
        
        
        
        self.siteAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", [NSString checkForNilString:[self.managedObject valueForKey:@"siteAddressLine1"]], [NSString checkForNilString:[self.managedObject valueForKey:@"sitePostcode"]]];
        
    }
}



- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self calculateSummaryTotals];
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
    
    if ([segue.identifier isEqualToString:@"EstimateAddressSegue"]) {
        InvoiceAddressDetailsTVC *invoiceAddressDetailsTVC = segue.destinationViewController;
        invoiceAddressDetailsTVC.managedObject = managedObject;
        invoiceAddressDetailsTVC.managedObjectContext = managedObjectContext;
        invoiceAddressDetailsTVC.delegate = self;
    }
    
    else if ([segue.identifier isEqualToString:@"EstimateSiteAddressSegue"]) {
        EstimateSiteAddressTVC *estimateSiteAddressDetailsTVC = segue.destinationViewController;
        estimateSiteAddressDetailsTVC.managedObject = managedObject;
        estimateSiteAddressDetailsTVC.managedObjectContext = managedObjectContext;
        estimateSiteAddressDetailsTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"EstimateItemsSegue"]) {
        EstimateItemsHeaderTVC *estimateItemsHeaderTVC = segue.destinationViewController;
        estimateItemsHeaderTVC.managedObjectContext = managedObjectContext;
        estimateItemsHeaderTVC.estimateUniqueNo = self.uniqueEstimateNoLabel.text;
    }
    else if ([segue.identifier isEqualToString:@"SelectEstimateTermsSegue"]) {
        EstimateTermsLookupTVC *estimateTermLookupTVC = segue.destinationViewController;
        estimateTermLookupTVC.delegate = self;
    }
    
    // TO CHANGE
    else if ([segue.identifier isEqualToString:@"SelectInvoiceTaxPointDateSegue"]) {
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
        dateTimePickerTVC.tag = [NSNumber numberWithInt:1];
    }
    else if ([segue.identifier isEqualToString:@"viewEstimateSegue"]) {
        [self SaveTest];
      
        PDFEstimateViewController *pdfView = segue.destinationViewController;
        Estimate *estimate;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[Estimate class]]) {
            estimate = (Estimate *) self.managedObject;
        }
        pdfView.currentEstimate = estimate;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"emailEstimateSegue"]) {
        [self SaveTest];
        PDFEstimateViewController *pdfView = segue.destinationViewController;
        Estimate *estimate;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[Estimate class]]) {
            estimate = (Estimate *) self.managedObject;
        }
        pdfView.currentEstimate = estimate;
        pdfView.managedObjectContext = managedObjectContext;    }
    else if ([segue.identifier isEqualToString:@"printEstimateSegue"]) {
        [self SaveTest];
        PDFEstimateViewController *pdfView = segue.destinationViewController;
        Estimate *estimate;
        pdfView.mode = @"print";
        if ([self.managedObject isKindOfClass:[Estimate class]]) {
            estimate = (Estimate *) self.managedObject;
        }
        pdfView.currentEstimate = estimate;
        pdfView.managedObjectContext = managedObjectContext;
    }
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"viewEstimateSegue"] ||
        [identifier isEqualToString:@"emailEstimateSegue"] ||
        [identifier isEqualToString:@"printEstimateSegue"]
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




-(void)theSaveButtonPressedOnTheEstimateAddressDetails:(EstimateSiteAddressTVC *)controller
{
    self.siteAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", controller.siteAddressLine1.text, controller.sitePostcode.text];
    self.siteNameLabel.text = [self.managedObject valueForKey:@"siteName"];
}


-(void)calculateSummaryTotals
{
   
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"EstimateItem"];
    
    NSLog(@"entity: %@", self.entityName);
    
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (estimateNo == %@)", SDObjectDeleted, self.uniqueEstimateNoLabel.text]];
    
    items = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    
    if ([items count] > 0) {
        
        
        NSMutableArray * totalArray = [[NSMutableArray alloc] init];
        NSMutableArray * vatArray = [[NSMutableArray alloc] init];
        
        float vat = 0;
        
        for (int i = 0; i < [items count]; ++i) {
            EstimateItem *estimateItem = [items objectAtIndex:i];
            
            
            [totalArray addObject:[NSNumber numberWithFloat:[estimateItem.total floatValue]]];
            
           
            [vatArray addObject:[NSNumber numberWithFloat:[estimateItem.vatAmount floatValue]]];
            
            float itemVat = [estimateItem.vatAmount floatValue];
            vat = vat + itemVat;
        }
        
        NSLog(@"invoice total array count = %i", [totalArray count]);
        
        double totalSum = 0;
        for (NSNumber * n in totalArray) {
            totalSum += [n doubleValue];
        }
        
        
        float totalFloat = 0.0;
        for (NSNumber * n in totalArray) {
            totalFloat += [n doubleValue];
        }
        
        NSLog(@"totalFloat: %.2f", totalFloat);
        
        double totalVatSum = 0;
        for (NSNumber * n in vatArray) {
            
            NSLog(@"vat %@", n);
            
            totalVatSum += [n doubleValue];
        }
        
        double subTotalSum = 0;
        subTotalSum = totalSum - totalVatSum;
        
        
        self.totalLabel.text = [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency] ,totalSum]];
        
        
        [self.managedObject setValue:[NSString checkForNilString:[NSString stringWithFormat:@"%.2f",totalSum]] forKey:@"total"];
        
        
        self.vatLabel.text = [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f", [LACHelperMethods getDefaultCurrency], totalVatSum]];
        
        [self.managedObject setValue:[NSString checkForNilString:[NSString stringWithFormat:@"%.2f",totalVatSum]] forKey:@"vat"];
        
        
        self.subtotalLabel.text = [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], subTotalSum]];
        
        
        [self.managedObject setValue:[NSString checkForNilString:[NSString stringWithFormat:@"%.2f",subTotalSum]] forKey:@"subtotal"];
        //[self.managedObject setValue:self.subtotalLabel.text forKey:@"subtotal"];
        
        
     
        
        self.numberOfExpenseItemsLabel.text = [NSString stringWithFormat:@"%i items", [items count]];
        
    }
    
    [self SaveTest];
    
}

- (void)loadEstimateItemsDataFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        
        [self.estimateItems removeAllObjects];
        
        //  [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ExpenseItem"];
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (estimateNo == %@)", SDObjectDeleted, self.uniqueEstimateNoLabel.text]];
        
        
        self.estimateItems = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
      
    }];
}





- (IBAction)saveButtonTouched:(id)sender {
    
    [self SaveTest];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveTest
{
    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.uniqueEstimateNoLabel.text] forKey:@"uniqueEstimateNo"];
    [self.managedObject setValue:[NSString checkForNilString:self.referenceTextField.text] forKey:@"reference"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.workOrderReferenceTextField.text] forKey:@"workOrderReference"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.commentsTextField.text] forKey:@"comment"];
    [self.managedObject setValue:[NSString checkForNilString:self.termsLabel.text] forKey:@"terms"];
    
    
    
    if (self.typeSegmentControl.selectedSegmentIndex == 0) {
        [self.managedObject setValue:@"Estimate" forKey:@"type"];
    }
    else if (self.typeSegmentControl.selectedSegmentIndex == 1) {
        [self.managedObject setValue:@"Quote" forKey:@"type"];
    }
    else
    {
        [self.managedObject setValue:@"Estimate" forKey:@"type"];
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


-(void)theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller
{
    // CHECK TAG is set
    
    //set Date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM yyyy"];
    NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
    
    if (controller.tag == [NSNumber numberWithInt:1]) {
        [self.managedObject setValue:controller.inputDate forKey:@"date"];
        self.dateLabel.text = dateLabelString;
    }
   
    
    [self.navigationController popViewControllerAnimated:YES];
}


// TO CHANGE
-(void)theSaveButtonPressedOnTheInvoiceAddressDetails:(InvoiceAddressDetailsTVC *)controller
{
    self.customerNameLabel.text = controller.customerAddressName.text;
    self.customerAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", controller.customerAddressLine1.text, controller.customerPostcode.text];
    
    [self.managedObject setValue:controller.customerIdLabel.text forKey:@"customerId"];
}

// TO CHANGE
-(void)theEstimateTermWasSelectedFromTheList:(EstimateTermsLookupTVC *)controller
{
    self.termsLabel.text = controller.selectedEstimateTerm.name;
    [self.managedObject setValue:controller.selectedEstimateTerm.name forKey:@"terms"];
    [self.navigationController popViewControllerAnimated:YES];
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
