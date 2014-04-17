//
//  ApplianceInspectionDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationLookupTVC.h"
#import "ApplianceTypeLookupTVC.h"
#import "ApplianceMakeLookupTVC.h"
#import "ModelLookupTVC.h"
#import "ApplianceInspection.h"
#import "NSString+Additions.h"
#import "LACUsersHandler.h"

@interface ApplianceInspectionDetailTVC : UITableViewController <LocationLookupTVCDelegate, ApplianceTypeLookupTVCDelegate, ApplianceMakeLookupTVCDelegate, ModelLookupTVCDelegate>


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) ApplianceInspection *selectedApplianceInspection;
@property (strong, nonatomic) NSString *certificateNumber;

@property (strong, nonatomic) NSString *entityName;


@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceMakeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceModelTextField;

@property (strong, nonatomic) IBOutlet UISegmentedControl *landlordsApplianceSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *applianceInspectedSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *operatingPressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *heatInputTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *safetyDeviceInCorrectOperationSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ventilationProvisionSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *visualConditionOfFlueSatisfactorySegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *fluePerformanceTestsSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *fluePerformanceTestSpillageSegmentControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *applianceServicedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *applianceSafeToUseSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *flueTypeSegmentControl;
@property (strong, nonatomic) IBOutlet UITextView *faultDetailsTextView;
@property (strong, nonatomic) IBOutlet UITextView *remedialActionTakenTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *warningNoticeLabelIssuedSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *warningNoticeNumberTextField;

@property (strong, nonatomic) IBOutlet UITextField *combustion1stCOReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion1stCO2ReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion1stRatioReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion2ndCOReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion2ndCO2ReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion2ndRatioReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion3rdCOReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion3rdCO2ReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion3rdRatioReadingTextField;



@property (copy, nonatomic) void (^updateCompletionBlock)(void);



@end
