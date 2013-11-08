//
//  ExpenseItemDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 01/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ExpenseItemDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"
#import "LACHelperMethods.h"

@interface ExpenseItemDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation ExpenseItemDetailTVC


@synthesize selectedExpenseItem;
@synthesize entityName;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;


@synthesize descriptionTextField;
@synthesize typeTextField;
@synthesize categoryTextField;
@synthesize supplierTextField;
@synthesize subtotalAmountTextField;
@synthesize vatAmountTextField;
@synthesize totalAmountTextField;
@synthesize notesTextView;
@synthesize dateLabel;

@synthesize subtotalLabel;
@synthesize vatLabel;
@synthesize totalLabel;

@synthesize supplierId;

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
    
    subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: (%@)", [LACHelperMethods getDefaultCurrency]];
    vatLabel.text = [NSString stringWithFormat:@"VAT: (%@)", [LACHelperMethods getDefaultCurrency]];
    totalLabel.text = [NSString stringWithFormat:@"Total: (%@)", [LACHelperMethods getDefaultCurrency]];
            
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    
    if (self.selectedExpenseItem == nil) {
        NSLog(@"insert new appliance detail");
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItem" inManagedObjectContext:self.managedObjectContext];
    }
    else
    {
        self.managedObject = self.selectedExpenseItem;
        
      
    NSDate *expenseItemDate = [self.managedObject valueForKey:@"date"];
        
    if (expenseItemDate != nil) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
       // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
        self.dateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"date"]];
    }
    
        descriptionTextField.text = [self.managedObject valueForKey:@"itemDescription"];
        typeTextField.text = [self.managedObject valueForKey:@"type"];
        categoryTextField.text = [self.managedObject valueForKey:@"category"];
        supplierTextField.text = [self.managedObject valueForKey:@"supplier"];
        subtotalAmountTextField.text = [self.managedObject valueForKey:@"subTotalAmount"];
        vatAmountTextField.text = [self.managedObject valueForKey:@"vatAmount"];
        totalAmountTextField.text = [self.managedObject valueForKey:@"totalAmount"];
        notesTextView.text = [self.managedObject valueForKey:@"notes"];
        
        supplierId = [self.managedObject valueForKey:@"supplierId"];
        
          NSLog(@"item id = %@", self.supplierId);
    }
        
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


#pragma Delegate methods

-(void)theExpenseItemTypeWasSelectedFromTheList:(ExpenseItemTypeLookupTVC *)controller
{
    self.typeTextField.text = controller.selectedExpenseItemType.name;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theExpenseItemCategoryWasSelectedFromTheList:(ExpenseItemCategoryLookupTVC *)controller
{
    self.categoryTextField.text = controller.selectedExpenseItemCategory.name;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theExpenseItemSupplierWasSelectedFromTheList:(ExpenseItemSupplierLookupTVC *)controller
{
    self.supplierTextField.text = controller.selectedExpenseItemSupplier.name;
   
    NSLog(@"controller value = %@", controller.selectedExpenseItemSupplier.itemId);
    
    self.supplierId = controller.selectedExpenseItemSupplier.itemId;
    NSLog(@"supplier Id = %@", self.supplierId );
    
    
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"SelectExpenseItemTypeSegue"]) {
        ExpenseItemTypeLookupTVC *expenseItemTypeLookupTVC = segue.destinationViewController;
        expenseItemTypeLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectExpenseItemCategorySegue"]) {
        ExpenseItemCategoryLookupTVC *expenseItemCategoryLookupTVC = segue.destinationViewController;
        expenseItemCategoryLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectExpenseItemSupplierSegue"]) {
        ExpenseItemSupplierLookupTVC *expenseItemSupplierLookupTVC = segue.destinationViewController;
        expenseItemSupplierLookupTVC.delegate = self;
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
    
        [self.managedObject setValue:[LACUsersHandler getCurrentEngineerId] forKey:@"engineerId"];
        [self.managedObject setValue:[LACUsersHandler getCurrentCompanyId] forKey:@"companyId"];
    
        NSLog(@"saveButtonTouched for ApplianceInspection Detail");
        NSLog(@"uniqueClaimNo: %@", self.uniqueClaimNo);
    
        [self.managedObject setValue:[NSString checkForNilString:self.uniqueClaimNo] forKey:@"expenseUniqueReference"];

        [self.managedObject setValue:[NSString checkForNilString:self.descriptionTextField.text] forKey:@"itemDescription"];
        [self.managedObject setValue:[NSString checkForNilString:self.typeTextField.text] forKey:@"type"];
        [self.managedObject setValue:[NSString checkForNilString:self.categoryTextField.text] forKey:@"category"];
        [self.managedObject setValue:[NSString checkForNilString:self.supplierTextField.text] forKey:@"supplier"];
        [self.managedObject setValue:[NSString checkForNilString:self.subtotalAmountTextField.text] forKey:@"subTotalAmount"];
        [self.managedObject setValue:[NSString checkForNilString:self.vatAmountTextField.text] forKey:@"vatAmount"];
        [self.managedObject setValue:[NSString checkForNilString:self.totalAmountTextField.text] forKey:@"totalAmount"];
        [self.managedObject setValue:[NSString checkForNilString:self.notesTextView.text] forKey:@"notes"];
        [self.managedObject setValue:[NSString checkForNilString:self.supplierId] forKey:@"supplierId"];
        
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
