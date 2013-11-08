//
//  AddressDetailsCertificateTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 09/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerLookupTVC.h"
#import "SiteLookupTVC.h"
#import "NSString+Additions.h"

@interface AddressDetailsCertificateTVC : UITableViewController <CustomerLookupTVCDelegate, SiteLookupTVCDelegate>


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextField *customerAddressName;
@property (strong, nonatomic) IBOutlet UITextField *customerAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *customerAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *customerAddressLine3;
@property (strong, nonatomic) IBOutlet UITextField *customerPostcode;
@property (strong, nonatomic) IBOutlet UITextField *customerTelNumber;
@property (strong, nonatomic) IBOutlet UITextField *customerMobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *customerEmail;
@property (strong, nonatomic) IBOutlet UILabel *customerIdLabel;
@property (strong, nonatomic) IBOutlet UITextField *siteAddressName;
@property (strong, nonatomic) IBOutlet UITextField *siteAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *siteAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *siteAddressLine3;
@property (strong, nonatomic) IBOutlet UITextField *sitePostcode;
@property (strong, nonatomic) IBOutlet UITextField *siteTelNumber;
@property (strong, nonatomic) IBOutlet UITextField *siteMobileNumber;

@property (strong, nonatomic) NSString *entityName;



@end
