//
//  InvoicePaymentTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 30/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "InvoicePaymentTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Customer.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"
#import "PDFPaymentViewController.h"

@interface InvoicePaymentTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation InvoicePaymentTVC

@synthesize entityName;
@synthesize uniqueReferenceLabel;
@synthesize dateLabel;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize invoice;
@synthesize currentPaymentAmountTextField;
@synthesize commentTextField;

@synthesize updatedBalanceLabel;
@synthesize paymentTypeLabel;
@synthesize invoiceTotalLabel;
@synthesize previouslyPaidLabel;
@synthesize balanceDueLabel;

@synthesize updateCompletionBlock;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)calculateNewBalance
{
    float balanceDue = [invoice.balanceDue floatValue];
    float amountPaid = 0;
    
    if (self.currentPaymentAmountTextField.text.length > 0) {
        amountPaid = [self.currentPaymentAmountTextField.text floatValue];
    }
    
    float newBalance = balanceDue - amountPaid;
    self.updatedBalanceLabel.text = [NSString stringWithFormat:@"%.2f", newBalance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    
    [self.currentPaymentAmountTextField addTarget:self
                                           action:@selector(calculateNewBalance)
                                 forControlEvents:UIControlEventEditingChanged];
    
    
    NSLog(@"invoice no = %@", self.invoice.uniqueInvoiceNo);
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    
    if (self.managedObjectId == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        self.uniqueReferenceLabel.text =  [NSString stringWithFormat:@"%@-%@",@"PAY", [NSString generateUniqueNumberIdentifier]];
        self.dateFormatter = [[NSDateFormatter alloc] init];
      //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        
        [self.managedObject setValue:[NSDate date] forKey:@"date"];
        
        self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        
        invoiceTotalLabel.text = invoice.total;
        previouslyPaidLabel.text = invoice.paid;
        balanceDueLabel.text = invoice.balanceDue;
        
        [self calculateNewBalance];
        
    }
    else
    {
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
        self.uniqueReferenceLabel.text = [self.managedObject valueForKey:@"paymentId"];
      
        invoiceTotalLabel.text = invoice.total;
        previouslyPaidLabel.text = invoice.paid;
        balanceDueLabel.text = invoice.balanceDue;
     
        self.currentPaymentAmountTextField.text = [self.managedObject valueForKey:@"amount"];
        self.commentTextField.text = [self.managedObject valueForKey:@"comment"];
        self.paymentTypeLabel.text = [self.managedObject valueForKey:@"type"];
        
        
        [self calculateNewBalance];
        
        
        NSDate *certificateDate = [self.managedObject valueForKey:@"date"];
        
        if (certificateDate != nil) {
            self.dateFormatter = [[NSDateFormatter alloc] init];
         //   [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
            self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
        }
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



-(void)generatingHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Generating";
    [HUD show:YES];
}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if ([segue.identifier isEqualToString:@"SelectPaymentTypeSegue"]) {
         PaymentTypeLookupTVC *paymentTypeLookupTVC = segue.destinationViewController;
         paymentTypeLookupTVC.delegate = self;
     }
     else if ([segue.identifier isEqualToString:@"viewPaymentReceiptSegue"]) {
         [self saveAll];
         PDFPaymentViewController *pdfView = segue.destinationViewController;
         Payment *payment;
         pdfView.mode = @"view";
         if ([self.managedObject isKindOfClass:[Payment class]]) {
             payment = (Payment *) self.managedObject;
         }
         pdfView.currentPayment = payment;
         pdfView.invoice = self.invoice;
         pdfView.managedObjectContext = managedObjectContext;
     }
     else if ([segue.identifier isEqualToString:@"emailPaymentSegue"]) {
         [self saveAll];
         PDFPaymentViewController *pdfView = segue.destinationViewController;
         Payment *payment;
         pdfView.mode = @"email";
         if ([self.managedObject isKindOfClass:[Payment class]]) {
             payment = (Payment *) self.managedObject;
         }
         pdfView.currentPayment = payment;
         pdfView.invoice = self.invoice;
         pdfView.managedObjectContext = managedObjectContext;
     }
     else if ([segue.identifier isEqualToString:@"printPaymentSegue"]) {
         [self saveAll];
         PDFPaymentViewController *pdfView = segue.destinationViewController;
         Payment *payment;
         pdfView.mode = @"print";
         if ([self.managedObject isKindOfClass:[Payment class]]) {
             payment = (Payment *) self.managedObject;
         }
         pdfView.currentPayment = payment;
         pdfView.invoice = self.invoice;
         pdfView.managedObjectContext = managedObjectContext;
     }
     else if ([segue.identifier isEqualToString:@"dropboxPaymentSegue"]) {
         [self saveAll];
         PDFPaymentViewController *pdfView = segue.destinationViewController;
         Payment *payment;
         pdfView.mode = @"dropbox";
         if ([self.managedObject isKindOfClass:[Payment class]]) {
             payment = (Payment *) self.managedObject;
         }
         pdfView.currentPayment = payment;
         pdfView.invoice = self.invoice;
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


 -(void)thePaymentTypeWasSelected:(PaymentTypeLookupTVC *)controller
 {
     NSLog(@"called thePaymentTypeWasSelected");
     self.paymentTypeLabel.text = controller.selectedPaymentType.name;
     [self.navigationController popViewControllerAnimated:YES];
 }

- (IBAction)saveButtonTouched:(id)sender {
    [self saveAll];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)saveAll
{
    self.invoice.balanceDue = self.updatedBalanceLabel.text;
    
    float previouslyPaid = [self.previouslyPaidLabel.text floatValue];
    float currentPayment = [self.currentPaymentAmountTextField.text floatValue];
    float newPaidBalance = previouslyPaid + currentPayment;
    self.invoice.paid = [NSString stringWithFormat:@"%.2f", newPaidBalance];
    
    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    [self.managedObject setValue:self.uniqueReferenceLabel.text forKey:@"paymentId"];
    [self.managedObject setValue:self.invoice.uniqueInvoiceNo forKey:@"invoiceNo"];
    [self.managedObject setValue:self.currentPaymentAmountTextField.text forKey:@"amount"];
    [self.managedObject setValue:self.paymentTypeLabel.text forKey:@"type"];
    [self.managedObject setValue:self.commentTextField.text forKey:@"comment"];
    [self.managedObject setValue:invoice.customerId forKey:@"customerId"];

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
    [self saveAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
