//
//  InvoiceDetail.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//


#import "InvoiceDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Invoice.h"
#import "NSString+Additions.h"
#import "PDFInvoiceViewController.h"
#import "InvoiceItemsHeaderTVC.h"
#import "InvoicePaymentTVC.h"
#import "PaymentsTVC.h"
#import "LACHelperMethods.h"


@interface InvoiceDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *invoiceItemsManagedObjectContext;

@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation InvoiceDetailTVC


@synthesize entityName;
@synthesize uniqueInvoiceNoLabel;
@synthesize referenceTextField;
@synthesize workOrderReferenceTextField;
@synthesize customerNameLabel;
@synthesize customerAddressPreviewLabel;
@synthesize siteNameLabel;
@synthesize siteAddressPreviewLabel;
@synthesize subtotalLabel;
@synthesize vatLabel;
@synthesize totalLabel;
@synthesize paidLabel;
@synthesize balanceDueLabel;
@synthesize dateLabel;
@synthesize termsLabel;
@synthesize dueDateLabel;
@synthesize numberOfInvoiceItemsLabel;
@synthesize commentsTextField;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize existingEstimate;
@synthesize estimateItems;

@synthesize invoiceItems;

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
        
        self.uniqueInvoiceNoLabel.text =  [NSString stringWithFormat:@"INV-%@",[NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
      // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
    
        NSString *defaultAmount = [NSString stringWithFormat:@"%@0.00", [LACHelperMethods getDefaultCurrency]];
        
        self.subtotalLabel.text = defaultAmount;
        self.vatLabel.text = defaultAmount;
        self.totalLabel.text = defaultAmount;
        self.paidLabel.text = defaultAmount;
        self.balanceDueLabel.text = defaultAmount;
        
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueInvoiceNoLabel.text = [self.managedObject valueForKey:@"uniqueInvoiceNo"];
        self.referenceTextField.text = [self.managedObject valueForKey:@"reference"];
        
        self.workOrderReferenceTextField.text = [self.managedObject valueForKey:@"workOrderReference"];
        
        NSDate *invoiceDate = [self.managedObject valueForKey:@"date"];
        
        if (invoiceDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
         //   [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        } 
    
    
        NSLog(@"invoice Vat: = %@", [self.managedObject valueForKey:@"vat"]);
        
    self.commentsTextField.text = [self.managedObject valueForKey:@"comment"];
    self.paidLabel.text = [self.managedObject valueForKey:@"paid"];
    self.balanceDueLabel.text = [self.managedObject valueForKey:@"balanceDue"];
    self.termsLabel.text = [self.managedObject valueForKey:@"terms"];

    NSDate *dueDate = [self.managedObject valueForKey:@"due"];
    
    if (dueDate != nil) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        self.dueDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"due"]];
    }

    self.customerNameLabel.text = [self.managedObject valueForKey:@"customerName"];
    self.customerAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", [NSString checkForNilString:[self.managedObject valueForKey:@"customerAddressLine1"]], [NSString checkForNilString:[self.managedObject valueForKey:@"customerPostcode"]]];
    
    self.siteNameLabel.text = [self.managedObject valueForKey:@"siteName"];
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
    
    if ([segue.identifier isEqualToString:@"InvoiceAddressSegue"]) {
        InvoiceAddressDetailsTVC *invoiceAddressDetailsTVC = segue.destinationViewController;
        invoiceAddressDetailsTVC.managedObject = managedObject;
        invoiceAddressDetailsTVC.managedObjectContext = managedObjectContext;
        invoiceAddressDetailsTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SiteAddressSegue"]) {
        EstimateSiteAddressTVC *estimateSiteAddressDetailsTVC = segue.destinationViewController;
        estimateSiteAddressDetailsTVC.managedObject = managedObject;
        estimateSiteAddressDetailsTVC.managedObjectContext = managedObjectContext;
        estimateSiteAddressDetailsTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"InvoiceItemsSegue"]) {
        InvoiceItemsHeaderTVC *invoiceItemsHeaderTVC = segue.destinationViewController;
        invoiceItemsHeaderTVC.managedObjectContext = managedObjectContext;
        invoiceItemsHeaderTVC.invoiceUniqueNo = self.uniqueInvoiceNoLabel.text;
    }
    else if ([segue.identifier isEqualToString:@"SelectInvoiceTermsSegue"]) {
        InvoiceTermsLookupTVC *invoiceTermLookupTVC = segue.destinationViewController;
        invoiceTermLookupTVC.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"SelectEstimateSegue"]) {
        SelectEstimateTVC *selectEstimateSegueTVC = segue.destinationViewController;
        selectEstimateSegueTVC.delegate = self;
    }
    
    else if ([segue.identifier isEqualToString:@"SelectInvoiceTaxPointDateSegue"]) {
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"date"];
        dateTimePickerTVC.tag = [NSNumber numberWithInt:1];
    }
    else if ([segue.identifier isEqualToString:@"SelectInvoiceDueDateSegue"]) {
        DateTimePickerTVC *dateTimePickerTVC = segue.destinationViewController;
        dateTimePickerTVC.delegate = self;
        dateTimePickerTVC.inputDate = [self.managedObject valueForKey:@"due"];
        dateTimePickerTVC.tag = [NSNumber numberWithInt:2];
    }
    else if ([segue.identifier isEqualToString:@"ReceivePaymentSegue"]) {
        [self SaveTest];
        InvoicePaymentTVC *invoicePaymentTVC = segue.destinationViewController;
        invoicePaymentTVC.managedObjectContext = managedObjectContext;
        [self SaveTest]; // TODO: tidy up name
        Invoice *invoice = (Invoice *)self.managedObject;
        invoicePaymentTVC.invoice = invoice;
    }
    else if ([segue.identifier isEqualToString:@"viewAssociatedPaymentsSegue"]) {
        [self SaveTest];
        PaymentsTVC *paymentsTVC = segue.destinationViewController;
        paymentsTVC.invoiceNo = self.uniqueInvoiceNoLabel.text;
        paymentsTVC.invoice = (Invoice *)self.managedObject;
    }
    else if ([segue.identifier isEqualToString:@"viewInvoiceSegue"]) {
        [self SaveTest];
        PDFInvoiceViewController *pdfView = segue.destinationViewController;
        Invoice *invoice;
        pdfView.mode = @"view";
        if ([self.managedObject isKindOfClass:[Invoice class]]) {
            invoice = (Invoice *) self.managedObject;
        }
        pdfView.currentInvoice = invoice;
        pdfView.managedObjectContext = managedObjectContext;
    }
    else if ([segue.identifier isEqualToString:@"emailInvoiceSegue"]) {
        [self SaveTest];
        PDFInvoiceViewController *pdfView = segue.destinationViewController;
        Invoice *invoice;
        pdfView.mode = @"email";
        if ([self.managedObject isKindOfClass:[Invoice class]]) {
            invoice = (Invoice *) self.managedObject;
        }
        pdfView.currentInvoice = invoice;
        pdfView.managedObjectContext = managedObjectContext;
     }
     else if ([segue.identifier isEqualToString:@"printInvoiceSegue"]) {
         [self SaveTest];
         PDFInvoiceViewController *pdfView = segue.destinationViewController;
         Invoice *invoice;
         pdfView.mode = @"print";
         if ([self.managedObject isKindOfClass:[Invoice class]]) {
             invoice = (Invoice *) self.managedObject;
         }
         pdfView.currentInvoice = invoice;
         pdfView.managedObjectContext = managedObjectContext;
     }
    else if ([segue.identifier isEqualToString:@"dropboxSegue"]) {

        [self SaveTest];
        PDFInvoiceViewController *pdfView = segue.destinationViewController;
        Invoice *invoice;
        pdfView.mode = @"dropbox";
        if ([self.managedObject isKindOfClass:[Invoice class]]) {
            invoice = (Invoice *) self.managedObject;
        }
        pdfView.currentInvoice = invoice;
        pdfView.managedObjectContext = managedObjectContext;
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"viewInvoiceSegue"] ||
        [identifier isEqualToString:@"emailInvoiceSegue"] ||
        [identifier isEqualToString:@"printInvoiceSegue"]
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




-(void)calculateSummaryTotals
{
        NSMutableArray * items = [[NSMutableArray alloc] init];
    
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"InvoiceItem"];
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (invoiceUniqueNo == %@)", SDObjectDeleted, self.uniqueInvoiceNoLabel.text]];
        
    items = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    
    if ([items count] > 0) {
    
        NSLog(@"invoiceItems count: %i", [self.invoiceItems count]);
        
        NSMutableArray * totalArray = [[NSMutableArray alloc] init];
        NSMutableArray * vatArray = [[NSMutableArray alloc] init];
        
        float vat = 0;
        
        for (int i = 0; i < [items count]; ++i) {
            InvoiceItem *invItem = [items objectAtIndex:i];
           
            NSLog(@"invoice Item %@", invItem);
            
            [totalArray addObject:[NSNumber numberWithFloat:[invItem.total floatValue]]];

            NSLog(@"float item total: %.2f", [invItem.total floatValue]);
        
            [vatArray addObject:[NSNumber numberWithFloat:[invItem.vatAmount floatValue]]];
            
        float itemVat = [invItem.vatAmount floatValue];
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
             
        
        NSString *paidString = [self.managedObject valueForKey:@"paid"];
        float paid = [paidString doubleValue];
        self.paidLabel.text = [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], paid]];
       
         [self.managedObject setValue:[NSString checkForNilString:[NSString stringWithFormat:@"%.2f",paid]] forKey:@"paid"];
        
        double balanceDue = totalSum - paid;
        self.balanceDueLabel.text = [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], balanceDue]];
       
        
        [self.managedObject setValue:[NSString checkForNilString:[NSString stringWithFormat:@"%.2f",balanceDue]] forKey:@"balanceDue"];
       
        self.numberOfInvoiceItemsLabel.text = [NSString stringWithFormat:@"%i items", [items count]];
        
    }
    
    [self SaveTest];
    
}

- (void)loadInvoiceItemsDataFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
    
        [self.invoiceItems removeAllObjects];
        
        NSLog(@"invoice items count: %i", self.invoiceItems.count );
        
        //  [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"InvoiceItem"];
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (invoiceUniqueNo == %@)", SDObjectDeleted, self.uniqueInvoiceNoLabel.text]];
  
           NSLog(@"invoice item: %@", self.uniqueInvoiceNoLabel.text);
        
        
        self.invoiceItems = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
        
        NSLog(@"self.invoiceItems at end: %i", self.invoiceItems.count);
    }];
}


- (IBAction)saveButtonTouched:(id)sender {
    
    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.uniqueInvoiceNoLabel.text] forKey:@"uniqueInvoiceNo"];
    [self.managedObject setValue:[NSString checkForNilString:self.referenceTextField.text] forKey:@"reference"];
    [self.managedObject setValue:[NSString checkForNilString:self.workOrderReferenceTextField.text] forKey:@"workOrderReference"];
    
    
    [self.managedObject setValue:[NSString checkForNilString:self.commentsTextField.text] forKey:@"comment"];
    [self.managedObject setValue:[NSString checkForNilString:self.termsLabel.text] forKey:@"terms"];
    
    NSLog(@"total: %@", [self.managedObject valueForKey:@"total"]);
    
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
   // updateCompletionBlock();
}

-(void)SaveTest
{
    
    
    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.referenceTextField.text] forKey:@"reference"];
    [self.managedObject setValue:[NSString checkForNilString:self.workOrderReferenceTextField.text] forKey:@"workOrderReference"];
    
    
    [self.managedObject setValue:[NSString checkForNilString:self.uniqueInvoiceNoLabel.text] forKey:@"uniqueInvoiceNo"];
    [self.managedObject setValue:[NSString checkForNilString:self.commentsTextField.text] forKey:@"comment"];
    [self.managedObject setValue:[NSString checkForNilString:self.termsLabel.text] forKey:@"terms"];
    
    
    NSLog(@"total: %@", [self.managedObject valueForKey:@"total"]);
 
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
    
   // [self.navigationController popViewControllerAnimated:YES];
   // updateCompletionBlock();
}


-(void)theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller
{
    //set Date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMMM yyyy"];
    NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:controller.inputDate]];
   
    if (controller.tag == [NSNumber numberWithInt:1]) {
        [self.managedObject setValue:controller.inputDate forKey:@"date"];
           self.dateLabel.text = dateLabelString;
    }
    else if(controller.tag == [NSNumber numberWithInt:2])
    {
        [self.managedObject setValue:controller.inputDate forKey:@"due"];
        self.dueDateLabel.text = dateLabelString;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theSaveButtonPressedOnTheInvoiceAddressDetails:(InvoiceAddressDetailsTVC *)controller
{
    self.customerNameLabel.text = controller.customerAddressName.text;
    self.customerAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", controller.customerAddressLine1.text, controller.customerPostcode.text];
    
    [self.managedObject setValue:controller.customerIdLabel.text forKey:@"customerId"];
}

-(void)theSaveButtonPressedOnTheEstimateAddressDetails:(EstimateSiteAddressTVC *)controller
{
    self.siteNameLabel.text = controller.siteAddressName.text;
    self.siteAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", controller.siteAddressLine1.text, controller.sitePostcode.text];
    
    [self.managedObject setValue:controller.siteIdLabel.text forKey:@"siteId"];
}

-(void)theInvoiceTermWasSelectedFromTheList:(InvoiceTermsLookupTVC *)controller
{
    self.termsLabel.text = controller.selectedInvoiceTerm.name;
    [self.managedObject setValue:controller.selectedInvoiceTerm.name forKey:@"terms"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theEstimateWasSelectedFromTheList:(SelectEstimateTVC *)controller
{
    self.referenceTextField.text = controller.selectedEstimate.reference;
    self.workOrderReferenceTextField.text = controller.selectedEstimate.workOrderReference;
    
    self.customerNameLabel.text = controller.selectedEstimate.customerName;
    self.customerAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", controller.selectedEstimate.customerAddressLine1, controller.selectedEstimate.customerPostcode];

    if (controller.selectedEstimate.siteName.length > 0) {
        self.siteNameLabel.text = controller.selectedEstimate.siteName;
        self.siteAddressPreviewLabel.text = [NSString stringWithFormat:@"%@, %@", controller.selectedEstimate.siteAddressLine1, controller.selectedEstimate.sitePostcode];
    }
    
    
    [self.managedObject setValue:controller.selectedEstimate.customerName forKey:@"customerName"];
    [self.managedObject setValue:controller.selectedEstimate.customerAddressLine1 forKey:@"customerAddressLine1"];
    [self.managedObject setValue:controller.selectedEstimate.customerAddressLine2 forKey:@"customerAddressLine2"];
    [self.managedObject setValue:controller.selectedEstimate.customerAddressLine3 forKey:@"customerAddressLine3"];
    [self.managedObject setValue:controller.selectedEstimate.customerPostcode forKey:@"customerPostcode"];
    [self.managedObject setValue:controller.selectedEstimate.customerTelephone forKey:@"customerTelephone"];
    [self.managedObject setValue:controller.selectedEstimate.customerMobile forKey:@"customerMobile"];
    [self.managedObject setValue:controller.selectedEstimate.customerId forKey:@"customerId"];
    [self.managedObject setValue:controller.selectedEstimate.customerEmail forKey:@"customerEmail"];
    
    
    [self.managedObject setValue:controller.selectedEstimate.siteName forKey:@"siteName"];
    [self.managedObject setValue:controller.selectedEstimate.siteAddressLine1 forKey:@"siteAddressLine1"];
    [self.managedObject setValue:controller.selectedEstimate.siteAddressLine2 forKey:@"siteAddressLine2"];
    [self.managedObject setValue:controller.selectedEstimate.siteAddressLine3 forKey:@"siteAddressLine3"];
    [self.managedObject setValue:controller.selectedEstimate.sitePostcode forKey:@"sitePostcode"];
    
    [self.managedObject setValue:controller.selectedEstimate.siteId forKey:@"siteId"];
    [self.managedObject setValue:controller.selectedEstimate.siteMobile forKey:@"siteMobile"];
    [self.managedObject setValue:controller.selectedEstimate.siteTelephone forKey:@"siteTelephone"];


    [self loadEstimateItemsDataFromCoreData:controller.selectedEstimate.uniqueEstimateNo];

    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];

    
    [self copyEstimateItemsToInvoiceItems];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)copyEstimateItemsToInvoiceItems
{
    
    for (EstimateItem *estimate in self.estimateItems) {
        
        self.invoiceItemsManagedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
        NSManagedObject *invoiceManagedObject;
        
       invoiceManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"InvoiceItem" inManagedObjectContext:self.invoiceItemsManagedObjectContext];
        
        [invoiceManagedObject setValue:self.uniqueInvoiceNoLabel.text forKey:@"invoiceUniqueNo"];
        [invoiceManagedObject setValue:estimate.itemDescription forKey:@"itemDescription"];
        [invoiceManagedObject setValue:estimate.total forKey:@"total"];
        [invoiceManagedObject setValue:estimate.vat forKey:@"vat"];
        [invoiceManagedObject setValue:estimate.quantity forKey:@"quantity"];
        [invoiceManagedObject setValue:estimate.unitPrice forKey:@"unitPrice"];
        [invoiceManagedObject setValue:estimate.discountRate forKey:@"discountRate"];
        [invoiceManagedObject setValue:estimate.vatAmount forKey:@"vatAmount"];
        
        
        [invoiceManagedObject.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [invoiceManagedObject.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
    }
}

- (void)loadEstimateItemsDataFromCoreData:(NSString *)uniqueEstimateNo {
    [self.managedObjectContext performBlockAndWait:^{
        
        [self.estimateItems removeAllObjects];
        
        //  [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"EstimateItem"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(estimateNo == %@)",uniqueEstimateNo]];
        
        self.estimateItems = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
