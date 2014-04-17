//
//  AddressDetailsCertificateTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 09/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "AddressDetailsCertificateTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Certificate.h"
#import "Customer.h"

@interface AddressDetailsCertificateTVC ()
@property CGPoint originalCenter;
@end

@implementation AddressDetailsCertificateTVC

@synthesize entityName;

@synthesize customerAddressName;
@synthesize customerAddressLine1;
@synthesize customerAddressLine2;
@synthesize customerAddressLine3;
@synthesize customerPostcode;
@synthesize customerTelNumber;
@synthesize customerMobileNumber;
@synthesize customerEmail;
@synthesize customerIdLabel;
@synthesize siteAddressName;
@synthesize siteAddressLine1;
@synthesize siteAddressLine2;
@synthesize siteAddressLine3;
@synthesize sitePostcode;
@synthesize siteTelNumber;
@synthesize siteMobileNumber;

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;



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
    
    NSLog(@"managaed object name: %@",  managedObject);
    
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    // load values if present
    self.customerAddressName.text = [self.managedObject valueForKey:@"customerAddressName"];
    self.customerAddressLine1.text = [self.managedObject valueForKey:@"customerAddressLine1"];
    self.customerAddressLine2.text = [self.managedObject valueForKey:@"customerAddressLine2"];
    self.customerAddressLine3.text = [self.managedObject valueForKey:@"customerAddressLine3"];
    self.customerPostcode.text = [self.managedObject valueForKey:@"customerPostcode"];
    self.customerTelNumber.text = [self.managedObject valueForKey:@"customerTelNumber"];
    self.customerMobileNumber.text = [self.managedObject valueForKey:@"customerMobileNumber"];
    self.customerIdLabel.text = [self.managedObject valueForKey:@"customerId"];
    
    self.customerEmail.text = [self.managedObject valueForKey:@"customerEmail"];
    self.siteAddressName.text = [self.managedObject valueForKey:@"siteAddressName"];
    self.siteAddressLine1.text = [self.managedObject valueForKey:@"siteAddressLine1"];
    self.siteAddressLine2.text = [self.managedObject valueForKey:@"siteAddressLine2"];
    self.siteAddressLine3.text = [self.managedObject valueForKey:@"siteAddressLine3"];
    self.sitePostcode.text = [self.managedObject valueForKey:@"siteAddressPostcode"];
    self.siteTelNumber.text = [self.managedObject valueForKey:@"siteTelNumber"];
    self.siteMobileNumber.text = [self.managedObject valueForKey:@"siteMobileNumber"];

    
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
    else if ([segue.identifier isEqualToString:@"ShowSitesLookupSegue"]) {
        SiteLookupTVC *siteLookupTVC = segue.destinationViewController;
        siteLookupTVC.customerNo = self.customerIdLabel.text;
        siteLookupTVC.delegate = self;
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
    self.customerEmail.text = controller.selectedCustomer.email;
    self.customerIdLabel.text = controller.selectedCustomer.customerNo;
    
    [self.managedObject setValue:controller.selectedCustomer.customerNo forKey:@"customerId"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)theSiteWasSelectedFromTheList:(SiteLookupTVC *)controller
{
    self.siteAddressName.text = controller.selectedSite.name;
    self.siteAddressLine1.text = controller.selectedSite.addressLine1;
    self.siteAddressLine2.text = controller.selectedSite.addressLine2;
    self.siteAddressLine3.text = controller.selectedSite.addressLine3;
    self.sitePostcode.text = controller.selectedSite.postcode;
    self.siteTelNumber.text = controller.selectedSite.tel;
    self.siteMobileNumber.text = controller.selectedSite.mobileNumber;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)copyAddressDetailsButtonPressed:(id)sender
{
    self.siteAddressName.text = self.customerAddressName.text;
    self.siteAddressLine1.text = self.customerAddressLine1.text;
    self.siteAddressLine2.text = self.customerAddressLine2.text;
    self.siteAddressLine3.text = self.customerAddressLine3.text;
    self.sitePostcode.text = self.customerPostcode.text;
    self.siteTelNumber.text = self.customerTelNumber.text;
    self.siteMobileNumber.text = self.customerMobileNumber.text;
}


- (IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonTouched:(id)sender {
    
    [self SaveAll];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)SaveAll
{
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressName.text] forKey:@"customerAddressName"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressLine1.text] forKey:@"customerAddressLine1"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressLine2.text] forKey:@"customerAddressLine2"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerAddressLine3.text] forKey:@"customerAddressLine3"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerPostcode.text] forKey:@"customerPostcode"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerTelNumber.text] forKey:@"customerTelNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerMobileNumber.text] forKey:@"customerMobileNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerEmail.text] forKey:@"customerEmail"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerIdLabel.text] forKey:@"customerId"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressName.text] forKey:@"siteAddressName"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressLine1.text] forKey:@"siteAddressLine1"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressLine2.text] forKey:@"siteAddressLine2"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressLine3.text] forKey:@"siteAddressLine3"];
    [self.managedObject setValue:[NSString checkForNilString:self.sitePostcode.text] forKey:@"siteAddressPostcode"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteTelNumber.text] forKey:@"siteTelNumber"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteMobileNumber.text] forKey:@"siteMobileNumber"];
    
    
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
