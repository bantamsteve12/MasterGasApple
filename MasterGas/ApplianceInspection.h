//
//  ApplianceInspection.h
//  MasterGas
//
//  Created by Stephen Lalor on 15/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ApplianceInspection : NSManagedObject

@property (nonatomic, retain) NSString * applianceInspected;
@property (nonatomic, retain) NSString * applianceMake;
@property (nonatomic, retain) NSString * applianceModel;
@property (nonatomic, retain) NSString * applianceSafeToUse;
@property (nonatomic, retain) NSString * applianceServiced;
@property (nonatomic, retain) NSString * applianceType;
@property (nonatomic, retain) NSString * certificateReference;
@property (nonatomic, retain) NSString * combustion1stCO2Reading;
@property (nonatomic, retain) NSString * combustion1stCOReading;
@property (nonatomic, retain) NSString * combustion1stRatioReading;
@property (nonatomic, retain) NSString * combustion2ndCO2Reading;
@property (nonatomic, retain) NSString * combustion2ndCOReading;
@property (nonatomic, retain) NSString * combustion2ndRatioReading;
@property (nonatomic, retain) NSString * combustion3rdCO2Reading;
@property (nonatomic, retain) NSString * combustion3rdCOReading;
@property (nonatomic, retain) NSString * combustion3rdRatioReading;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * faultDetails;
@property (nonatomic, retain) NSString * fluePerformanceTests;
@property (nonatomic, retain) NSString * flueType;
@property (nonatomic, retain) NSString * heatInput;
@property (nonatomic, retain) NSString * landlordsAppliance;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * operatingPressure;
@property (nonatomic, retain) NSString * remedialActionTaken;
@property (nonatomic, retain) NSString * safetyDeviceInCorrectOperation;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * ventilationProvision;
@property (nonatomic, retain) NSString * visualConditionOfFlueSatisfactory;
@property (nonatomic, retain) NSString * warningNoticeLabelIssued;
@property (nonatomic, retain) NSString * warningNoticeNumber;

@end
