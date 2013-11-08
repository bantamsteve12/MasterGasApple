//
//  VehicleRegistrationLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleRegistration.h"

@class VehicleRegistrationLookupTVC;

@protocol VehicleRegistrationLookupTVCDelegate <NSObject>

- (void)theVehicleRegistrationWasSelectedFromTheList:(VehicleRegistrationLookupTVC *)controller;
@end


@interface VehicleRegistrationLookupTVC : UITableViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *vehicleRegistrations;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) VehicleRegistration *selectedVehicleRegistration;

- (IBAction)refreshButtonTouched:(id)sender;

@end
