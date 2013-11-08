//
//  GasMaintenanceServiceChecksTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 24/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"

@interface GasMaintenanceServiceChecksTVC : UITableViewController


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceBurnerInjectorsSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceBurnerInjectorsTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceHeatExchangerSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceHeatExchangerTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceIgnitionSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceIgnitionTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceElectricsSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceElectricsTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceControlsSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceControlsTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceGasConnectionsSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceGasConnectionsTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceSealsSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceSealsTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceGasPipeworkSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceGasPipeworkTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceFansSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceFansTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceFireplaceOpeningVoidSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceFireplaceOpeningVoidTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceClosurePlateSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceClosurePlateTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceFlamePictureSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceFlamePictureTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceLocationSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceLocationTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceStabilitySegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceStabilityTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceReturnAirPlenumSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceReturnAirPlenumTextField;


@property (strong, nonatomic) IBOutlet UISegmentedControl *serviceGasWaterLeakSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *serviceGasWaterLeakTextField;



@property (strong, nonatomic) NSString *entityName;


@end
