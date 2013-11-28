//
//  EstimateSiteAddressTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 24/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "EstimateSiteAddressTVC.h"
#import "SDCoreDataController.h"
#import "Estimate.h"
#import "Customer.h"
#import "NSString+Additions.h"
#import "SitesTVC.h"

@interface EstimateSiteAddressTVC ()
@property CGPoint originalCenter;
@end

@implementation EstimateSiteAddressTVC


@synthesize entityName;

@synthesize siteAddressName;
@synthesize siteAddressLine1;
@synthesize siteAddressLine2;
@synthesize siteAddressLine3;
@synthesize sitePostcode;
@synthesize siteTelNumber;
@synthesize siteMobileNumber;
@synthesize siteEmailAddress;

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
    self.siteAddressName.text = [self.managedObject valueForKey:@"siteName"];
    self.siteAddressLine1.text = [self.managedObject valueForKey:@"siteAddressLine1"];
    self.siteAddressLine2.text = [self.managedObject valueForKey:@"siteAddressLine2"];
    self.siteAddressLine3.text = [self.managedObject valueForKey:@"siteAddressLine3"];
    self.sitePostcode.text = [self.managedObject valueForKey:@"sitePostcode"];
    self.siteTelNumber.text = [self.managedObject valueForKey:@"siteTelephone"];
    self.siteMobileNumber.text = [self.managedObject valueForKey:@"siteMobile"];
    self.siteEmailAddress.text = [self.managedObject valueForKey:@"siteEmail"];
    
    self.siteIdLabel.text = [self.managedObject valueForKey:@"siteId"];
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
    
    /*if ([segue.identifier isEqualToString:@"ShowCustomersLookupSegue"]) {
        CustomerLookupTVC *customerLookupTVC = segue.destinationViewController;
        customerLookupTVC.delegate = self;
    } */
     if ([segue.identifier isEqualToString:@"ViewLinkedSitesSegue"]) {
        SiteLookupTVC *sitesTVC = segue.destinationViewController;
        sitesTVC.customerNo = [self.managedObject valueForKey:@"customerId"];
         sitesTVC.delegate = self;
    }

    
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
    self.siteEmailAddress.text = controller.selectedSite.email;
    
    self.siteIdLabel.text = controller.selectedSite.siteReferenceNo;
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonTouched:(id)sender {
    
    [self.managedObject setValue:[NSString checkForNilString:self.siteIdLabel.text] forKey:@"siteId"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressName.text] forKey:@"siteName"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressLine1.text] forKey:@"siteAddressLine1"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressLine2.text] forKey:@"siteAddressLine2"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteAddressLine3.text] forKey:@"siteAddressLine3"];
    [self.managedObject setValue:[NSString checkForNilString:self.sitePostcode.text] forKey:@"sitePostcode"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteTelNumber.text] forKey:@"siteTelephone"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteMobileNumber.text] forKey:@"siteMobile"];
    [self.managedObject setValue:[NSString checkForNilString:self.siteEmailAddress.text] forKey:@"siteEmail"];
    
    
    //   [self.managedObject setValue:[NSNumber numberWithInt:SDObjectEdited] forKey:@"syncStatus"];
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
    
    [self.delegate theSaveButtonPressedOnTheEstimateAddressDetails:self];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
