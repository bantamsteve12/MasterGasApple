//
//  TightnessTestDetailsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 13/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "NSString+Additions.h"

@interface TightnessTestDetailsTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) IBOutlet UISegmentedControl *ttGasTypeSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttInstallationTypeSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttWeatherOrTempChangesSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *ttMeterType1TextField;
@property (strong, nonatomic) IBOutlet UITextField *ttMeterType2TextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttMeterBypassSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *ttInstallationVolumeTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttPipeworkFittingsTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttTotalInstallationVolumeTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttTestMediumSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *ttTightnessTestPressureValueTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttTightnessPressureUnitSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *ttPressureGuageTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttMPLRorMAPDValueTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttMPLRorMAPDUnitSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *ttLetbyTestPeriodTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttStabilisationPeriodTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttTightnessTestDurationTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttInadequateAreasToCheckSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttBarometricPressureConnectionNecessarySegmentControl;

@property (strong, nonatomic) IBOutlet UITextField *ttActualLeakRateTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttActualPressureDropTextField;


@property (strong, nonatomic) IBOutlet UISegmentedControl *ttInadequatelyVentilatedAreasCheckedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ttPassOrFailSegmentControl;

@property (strong, nonatomic) NSString *entityName;


@end
