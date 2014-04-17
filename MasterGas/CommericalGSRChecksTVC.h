//
//  CommericalGSRChecksTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/02/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "NSString+Additions.h"


@interface CommericalGSRChecksTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationAccessibleSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationAdequatelyVentilatedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationClearOfCombustiblesSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationControlValveHandleFittedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationECVWithEmergencyNoticeSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationEmergencyControlAccessibleSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationLockKeyLabelledSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationRoomSecureSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meterInstallationECVLabelledDirectionSegmentControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl * meterInstallationMeterAdequatelySupported;


@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkColourCodeIdentifiedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkIsolationValveHandlesInPlaceSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkIsolationValvesFittedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkLineDiagramCurrentSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkLineDiagramNearMeterSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkSleevedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkStrengthTightnessTestSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkSupportedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pipeworkElectricalCrossBondingSegmentControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyResponsiblePersonNotifiedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyWarningRaisedAndLabelsAttachedSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *safetyWarningNoticeNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *safetyResponsiblePersonNameTextField;


@property (strong, nonatomic) IBOutlet UITextView *remedialWorkRequiredTextViewField;
@property (strong, nonatomic) IBOutlet UITextView *workCarriedOutTextViewField;

@property (strong, nonatomic) NSString *entityName;


@end
