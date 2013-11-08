//
//  InvoiceStockItemDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 19/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "InvoiceStockItemDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"
#import "StockCategoryLookupTVC.h"



@interface InvoiceStockItemDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation InvoiceStockItemDetailTVC


@synthesize selectedInvoiceStockItem;
@synthesize entityName;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize itemDescriptionTextField;
@synthesize unitPriceTextField;
@synthesize discountRateTextField;
@synthesize vatAmountTextField;
@synthesize categoryLabel;

//@synthesize updateCompletionBlock;

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
    
    // set up delegates for the DONE key on the keyboards.
    self.discountRateTextField.delegate = self;
    self.unitPriceTextField.delegate = self;
    self.vatAmountTextField.delegate = self;
    
    if (self.selectedInvoiceStockItem == nil) {
        NSLog(@"insert new detail");
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"StockItem" inManagedObjectContext:self.managedObjectContext];
        
        self.vatAmountTextField.text = [LACHelperMethods getCompanyStandardVatRate];
    }
    else
    {
        self.managedObject = self.selectedInvoiceStockItem;
        
        itemDescriptionTextField.text = [self.managedObject valueForKey:@"itemDescription"];
        unitPriceTextField.text = [self.managedObject valueForKey:@"unitPrice"];
        vatAmountTextField.text = [self.managedObject valueForKey:@"vatRate"];
        discountRateTextField.text = [self.managedObject valueForKey:@"discountRate"];
        categoryLabel.text = [self.managedObject valueForKey:@"stockCategory"];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)calculateValues
{
   /* TODO
    
    float unitPrice = [[unitPriceTextField text] floatValue];
    float vatRate = [[vatAmountTextField text] floatValue];
    float discountAmount = [[discountRateTextField text] floatValue];
    
    float total = quantity * unitPrice;
    
    if (discountAmount > 0) {
        float discountMultiplier = (100 - discountAmount) / 100;
        NSLog(@"discount multiplier @%f", discountMultiplier);
        
        NSLog(@"total 1 @%f", total);
        
        total = (total * discountMultiplier);
        
        NSLog(@"total 2 @%f", total);
        
    }
    
    float totalWithVat;
    
    if (vatRate > 0) {
        
        float vatMultiplier = vatRate / 100 + 1;
        NSLog(@"vatMultiplier @%f", vatMultiplier);
        
        totalWithVat = (total * vatMultiplier);
        NSLog(@"totalWithVat @%f", totalWithVat);
        
    }
    else
    {
        totalWithVat = total;
    }
    
    totalAmountTextField.text = [NSString stringWithFormat:@"%.2f", totalWithVat];
    
    float vatAmount = totalWithVat - (quantity * unitPrice);
    
    NSLog(@"vatAmount 2: %@", [NSString stringWithFormat:@"@%.2f", vatAmount]);
    
    
    [self.managedObject setValue:[NSString stringWithFormat:@"@%.2f", vatAmount]forKey:@"vatAmount"];
 
    */
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
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


- (IBAction)saveButtonTouched:(id)sender {
    
    [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
    
    [self.managedObject setValue:self.itemDescriptionTextField.text forKey:@"itemDescription"];
    [self.managedObject setValue:self.unitPriceTextField.text forKey:@"unitPrice"];
    [self.managedObject setValue:self.discountRateTextField.text forKey:@"discountRate"];
    [self.managedObject setValue:self.vatAmountTextField.text forKey:@"vatRate"];
    [self.managedObject setValue:self.categoryLabel.text forKey:@"stockCategory"];
    
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
    
        [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)updateTotal:(id)sender
{
    [self calculateValues];
}


#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"LookupStockCategorySegue"]) {
        StockCategoryLookupTVC *stockCategoryLookupTVC = segue.destinationViewController;
        stockCategoryLookupTVC.delegate = self;
    }
}

-(void)theStockCategoryWasSelected:(StockCategoryLookupTVC *)controller
{
    self.categoryLabel.text = controller.selectedStockCategory.name;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

