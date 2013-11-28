//
//  FinalLandlordCertChecksTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "NSString+Additions.h"

@interface FinalLandlordCertChecksTVC : UITableViewController


//@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UISegmentedControl *ecvSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gasTightnessSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gasInstallationPipeworkControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *equipotentialBondingControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *coAlarmFittedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *coAlarmWorkingSegementControl;



@property (strong, nonatomic) IBOutlet UITextField *gasTightnessInitialValueTextField;
@property (strong, nonatomic) IBOutlet UITextField *gasTightnessFinalValueTextField;

// LPG additionals
@property (strong, nonatomic) IBOutlet UISegmentedControl *cylinderFinalConnectionControl;
@property (strong, nonatomic) IBOutlet UITextField *lpgRegulatorOperatingPressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *lpgRegulatorLockupPressureTextField;

@property (strong, nonatomic) NSString *entityName;


@end
