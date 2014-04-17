//
//  PlantCommissioningServiceApplianceInspectionTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationLookupTVC.h"
#import "ApplianceTypeLookupTVC.h"
#import "ApplianceMakeLookupTVC.h"
#import "ModelLookupTVC.h"

//#import "ApplianceInspection.h"
#import "PlantComServiceApplianceInspection.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"

@interface PlantCommissioningServiceApplianceInspectionTVC : UITableViewController <LocationLookupTVCDelegate, ApplianceTypeLookupTVCDelegate, ApplianceMakeLookupTVCDelegate, ModelLookupTVCDelegate>


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) PlantComServiceApplianceInspection *selectedApplianceInspection;
@property (strong, nonatomic) NSString *certificateNumber;

@property (strong, nonatomic) NSString *entityName;


@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceMakeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceModelTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceFlueTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *burnerManufacturerTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceSerialNumberTextField;


@property (strong, nonatomic) IBOutlet UITextField *ccLHeatInputRatingTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHHeatInputRatingTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLGasBurnerPressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHGasBurnerPressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLGasRateTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHGasRateTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLAirGasRatioControlTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHAirGasRatioControlTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLAmbientRoomTempTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHAmbientRoomTempTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLFlueGasTempTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHFlueGasTempTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLFlueGasTempNetTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHFlueGasTempNetTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLFlueDraughtPressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHFlueDraughtPressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLOxygenTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHOxygenTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLCarbonMonoxideTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHCarbonMonoxideTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLCarbonDioxideTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHCarbonDioxideTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLNoxTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHNoxTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLExcessAirTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHExcessAirTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLCOCO2RatioTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHCOCO2RatioTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLGrossEfficiencyTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHGrossEfficiencyTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccLCODilutionTextField;
@property (strong, nonatomic) IBOutlet UITextField *ccHCODilutionTextField;


@property (strong, nonatomic) IBOutlet UISegmentedControl *asAirGasPressureSwitchWorkingSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asFlueFlowSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asSpilageTestSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asVentilationSatisfactorySegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asFlameProvingSafetyWorkingSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *asBurnerLockoutTimeTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asTemperatureAndLimitStatsWorkingSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asApplianceServicedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asGasBoosterCompressorWorkingFlowSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asGasInstallationTightnessTestCarriedOutSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asGasInstallationPipeworkSleevedLabelledPaintedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asChimneyInstalledInAccordanceWithStandardsSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asFanFlueInterlockWorkingSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *asGasInstallationPipeworkSupportedSegmentControl;

@property (strong, nonatomic) IBOutlet UITextView *workCarriedOutTextView;
@property (strong, nonatomic) IBOutlet UITextView *remedialWorkRequiredTextView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *warningNoticeIssuedSegmentControl;

@property (strong, nonatomic) IBOutlet UITextField *warningNoticeNumberTextField;

@property (copy, nonatomic) void (^updateCompletionBlock)(void);



@end
