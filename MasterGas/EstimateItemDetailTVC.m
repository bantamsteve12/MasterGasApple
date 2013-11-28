//
//  EstimateItemDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "EstimateItemDetailTVC.h"
#import "SDCoreDataController.h"
#import "LACHelperMethods.h"


@interface EstimateItemDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

static int quantityValue = 0;
static float vatAmountFloat = 0;

@implementation EstimateItemDetailTVC

@synthesize selectedEstimateItem;
@synthesize entityName;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize itemDescriptionTextField;
@synthesize quantityTextField;
@synthesize unitPriceTextField;
@synthesize discountRateTextField;
@synthesize vatAmountTextField;
@synthesize totalAmountTextField;

@synthesize quantityStepper;
@synthesize estimateUniqueNo;
@synthesize updateCompletionBlock;

@synthesize currencyLabel;
@synthesize currencyLabel2;

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
    
    self.currencyLabel.text = [LACHelperMethods getDefaultCurrency];
    self.currencyLabel2.text = [LACHelperMethods getDefaultCurrency];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    // set up delegates for the DONE key on the keyboards.
    self.quantityTextField.delegate = self;
    self.discountRateTextField.delegate = self;
    self.unitPriceTextField.delegate = self;
    self.vatAmountTextField.delegate = self;
    
    if (self.selectedEstimateItem == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"EstimateItem" inManagedObjectContext:self.managedObjectContext];
        
        self.vatAmountTextField.text = [LACHelperMethods getCompanyStandardVatRate];
        
    }
    else
    {
        self.managedObject = self.selectedEstimateItem;
        
        itemDescriptionTextField.text = [self.managedObject valueForKey:@"itemDescription"];
        quantityTextField.text = [self.managedObject valueForKey:@"quantity"];
        
        unitPriceTextField.text = [NSString stringWithFormat:@"%@", [self.managedObject valueForKey:@"unitPrice"]];
        
        totalAmountTextField.text = [NSString stringWithFormat:@"%@", [self.managedObject valueForKey:@"total"]];
        
        NSLog(@"total %@", [NSString stringWithFormat:@"%@", [self.managedObject valueForKey:@"total"]]);
        
        vatAmountTextField.text = [NSString stringWithFormat:@"%@", [self.managedObject valueForKey:@"vat"]];
        
        discountRateTextField.text = [self.managedObject valueForKey:@"discountRate"];
        
        // TODO Check value is int.
        int value = [quantityTextField.text intValue];
        quantityValue = value;
        self.quantityStepper.value = quantityValue;
        
        
        NSLog(@"companyId = %@", [self.managedObject valueForKey:@"companyId"]);
        
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)calculateValues
{
    
    float quantity = [[quantityTextField text] floatValue];
    float unitPrice = [[unitPriceTextField text] floatValue];
    float vatRate = [[vatAmountTextField text] floatValue];
    float discountAmount = [[discountRateTextField text] floatValue];
    
    float discountMultiplier = 1;
    
    float total = quantity * unitPrice;
    
    if (discountAmount > 0) {
        discountMultiplier = (100 - discountAmount) / 100;
        total = (total * discountMultiplier);
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
    
    totalAmountTextField.text = [NSString stringWithFormat:@"%.2f",totalWithVat];
    
    float vatAmount = totalWithVat - ((quantity * unitPrice) * discountMultiplier);
    
    vatAmountFloat = vatAmount;
    
    // [self.managedObject setValue:[NSString stringWithFormat:@"@%.2f", vatAmount]forKey:@"vatAmount"];
    
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

#pragma Delegate methods

-(void)theStockItemWasSelectedFromTheList:(StockItemLookupTVC *)controller
{
    self.itemDescriptionTextField.text = controller.selectedStockItem.itemDescription;
    self.unitPriceTextField.text = controller.selectedStockItem.unitPrice;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SelectStockItemSegue"]) {
        StockItemLookupTVC *stockItemLookupTVC = segue.destinationViewController;
        stockItemLookupTVC.delegate = self;
    }
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
    [self.managedObject setValue:self.quantityTextField.text forKey:@"quantity"];
    [self.managedObject setValue:self.unitPriceTextField.text forKey:@"unitPrice"];
    [self.managedObject setValue:self.discountRateTextField.text forKey:@"discountRate"];
    [self.managedObject setValue:self.totalAmountTextField.text forKey:@"total"];
    [self.managedObject setValue:self.vatAmountTextField.text forKey:@"vat"];
    [self.managedObject setValue:self.estimateUniqueNo forKey:@"estimateNo"];
    
    NSLog(@"vatAmount string: %@",[NSString stringWithFormat:@"@%.2f", vatAmountFloat] );
    
    [self.managedObject setValue:[NSString stringWithFormat:@"%.2f", vatAmountFloat]forKey:@"vatAmount"];
    
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
    updateCompletionBlock();
    
}


- (IBAction)quantityValueChanged:(UIStepper *)sender {
    NSLog(@"stepper changed");
    double value = [sender value];
    quantityTextField.text = [NSString stringWithFormat:@"%d", (int)value];
    
    [self calculateValues];
}

- (IBAction)updateTotal:(id)sender
{
    [self calculateValues];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
