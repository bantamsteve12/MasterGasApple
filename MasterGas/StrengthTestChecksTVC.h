//
//  StrengthTestChecksTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 15/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"

@interface StrengthTestChecksTVC : UITableViewController


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) IBOutlet UISegmentedControl *stTestMethodSegmentControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *stInstallationTypeSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stComponentsNotSuitableRemovedSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *stCalculatedStrengthTestPressureValueTextField;
@property (strong, nonatomic) IBOutlet UITextField *stPermittedPressureDropValueTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stCalculatedStrengthTestPressureUnitSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *stTestMediumTextField;
@property (strong, nonatomic) IBOutlet UITextField *stStabilisationPeriodTextField;
@property (strong, nonatomic) IBOutlet UITextField *stStrengthTestDurationTextField;
@property (strong, nonatomic) IBOutlet UITextField *stCalculatedPressureDropValueTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stCalculatedPressureDropUnitSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *stActualPressureDropValueTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stActualPressureDropUnitSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stStrengthTestPassFailSegmentControl;

@property (strong, nonatomic) NSString *entityName;


@end
