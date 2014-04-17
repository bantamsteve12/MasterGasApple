//
//  InvoiceAddressDetailsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "InvoiceAddressDetailsTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Invoice.h"
#import "Customer.h"
#import "NSString+Additions.h"


@interface InvoiceAddressDetailsTVC ()
@property CGPoint originalCenter;

@end


@implementation InvoiceAddressDetailsTVC


@synthesize entityName;

@synthesize customerAddressName;
@synthesize customerAddressLine1;
@synthesize customerAddressLine2;
@synthesize customerAddressLine3;
@synthesize customerPostcode;
@synthesize customerTelNumber;
@synthesize customerMobileNumber;
@synthesize customerEmailAddress;

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize delegate;

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
   
    
    // load values if present
    self.customerAddressName.text = [self.managedObject valueForKey:@"customerName"];
    self.customerAddressLine1.text = [self.managedObject valueForKey:@"customerAddressLine1"];
    self.customerAddressLine2.text = [self.managedObject valueForKey:@"customerAddressLine2"];
    self.customerAddressLine3.text = [self.managedObject valueForKey:@"customerAddressLine3"];
    self.customerPostcode.text = [self.managedObject valueForKey:@"customerPostcode"];
    self.customerTelNumber.text = [self.managedObject valueForKey:@"customerTelephone"];
    self.customerMobileNumber.text = [self.managedObject valueForKey:@"customerMobile"];
    self.customerEmailAddress.text = [self.managedObject valueForKey:@"customerEmail"];

    self.customerIdLabel.text = [self.managedObject valueForKey:@"customerId"];
    
    NSLog(@"customerNo: %@", [self.managedObject valueForKey:@"customerId"]);
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowCustomersLookupSegue"]) {
        CustomerLookupTVC *customerLookupTVC = segue.destinationViewController;
        customerLookupTVC.delegate = self;
    }
}


- (void) theCustomerWasSelectedFromTheList:(CustomerLookupTVC *)controller
{
    self.customerAddressName.text = controller.selectedCustomer.name;
    self.customerAddressLine1.text = controller.selectedCustomer.addressLine1;
    self.customerAddressLine2.text = controller.selectedCustomer.addressLine2;
    self.customerAddressLine3.text = controller.selectedCustomer.addressLine3;
    self.customerPostcode.text = controller.selectedCustomer.postcode;
    self.customerTelNumber.text = controller.selectedCustomer.tel;
    self.customerMobileNumber.text = controller.selectedCustomer.mobileNumber;
    self.customerEmailAddress.text = controller.selectedCustomer.email;
   
    
    NSLog(@"controller.selectedCustomer.customerNo %@", controller.selectedCustomer.customerNo);
    
    self.customerIdLabel.text = controller.selectedCustomer.customerNo;
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonTouched:(id)sender {
    [self SaveAll];
    [self.delegate theSaveButtonPressedOnTheInvoiceAddressDetails:self];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)SaveAll
{
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressName.text] forKey:@"customerName"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressLine1.text] forKey:@"customerAddressLine1"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressLine2.text] forKey:@"customerAddressLine2"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressLine3.text] forKey:@"customerAddressLine3"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerPostcode.text] forKey:@"customerPostcode"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerTelNumber.text] forKey:@"customerTelephone"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerMobileNumber.text] forKey:@"customerMobile"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerEmailAddress.text] forKey:@"customerEmail"];
    
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
