//
//  EstimateSiteAddressTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 24/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerLookupTVC.h"
#import "SiteLookupTVC.h"

@class EstimateSiteAddressTVC;

@protocol EstimateSiteAddressDetailsTVCDelegate <NSObject>
- (void)theSaveButtonPressedOnTheEstimateAddressDetails:(EstimateSiteAddressTVC *)controller;
@end

@interface EstimateSiteAddressTVC : UITableViewController<SiteLookupTVCDelegate>

@property (nonatomic, weak) id delegate;

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextField *siteAddressName;
@property (strong, nonatomic) IBOutlet UITextField *siteAddressLine1;
@property (strong, nonatomic) IBOutlet UITextField *siteAddressLine2;
@property (strong, nonatomic) IBOutlet UITextField *siteAddressLine3;
@property (strong, nonatomic) IBOutlet UITextField *sitePostcode;
@property (strong, nonatomic) IBOutlet UITextField *siteTelNumber;
@property (strong, nonatomic) IBOutlet UITextField *siteMobileNumber;
@property (strong, nonatomic) IBOutlet UITextField *siteEmailAddress;

@property (strong, nonatomic) IBOutlet UILabel *siteIdLabel;

@property (strong, nonatomic) NSString *entityName;

@end
