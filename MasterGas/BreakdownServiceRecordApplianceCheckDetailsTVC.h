//
//  BreakdownServiceRecordApplianceCheckDetailsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 23/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"
#import "LocationLookupTVC.h"
#import "ApplianceTypeLookupTVC.h"
#import "ApplianceMakeLookupTVC.h"
#import "ModelLookupTVC.h"

@interface BreakdownServiceRecordApplianceCheckDetailsTVC : UITableViewController <LocationLookupTVCDelegate, ApplianceTypeLookupTVCDelegate, ApplianceMakeLookupTVCDelegate, ModelLookupTVCDelegate>


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceMakeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceModelTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceSerialNumberField;
@property (strong, nonatomic) IBOutlet UITextField *applianceBurnerMakeField;
@property (strong, nonatomic) IBOutlet UITextField *applianceBurnerModelField;

@property (strong, nonatomic) IBOutlet UITextField *operatingPressureTextField;
@property (strong, nonatomic) IBOutlet UITextField *heatInputTextField;

@property (strong, nonatomic) IBOutlet UITextField *combustion1stCOReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion1stCO2ReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion1stRatioReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion2ndCOReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion2ndCO2ReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion2ndRatioReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion3rdCOReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion3rdCO2ReadingTextField;
@property (strong, nonatomic) IBOutlet UITextField *combustion3rdRatioReadingTextField;

@property (strong, nonatomic) IBOutlet UISegmentedControl *gasTightnessTestCarriedOutSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *tightnessTestResult;

@property (strong, nonatomic) NSString *entityName;


@end
