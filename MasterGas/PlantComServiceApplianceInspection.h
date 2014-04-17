//
//  PlantComServiceApplianceInspection.h
//  MasterGas
//
//  Created by Stephen Lalor on 01/04/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlantComServiceApplianceInspection : NSManagedObject

@property (nonatomic, retain) NSString * acAirGasPressureSwitchWorking;
@property (nonatomic, retain) NSString * acApplianceServiced;
@property (nonatomic, retain) NSString * acBurnerLockoutTime;
@property (nonatomic, retain) NSString * acChimneyInstalledwithStandards;
@property (nonatomic, retain) NSString * acFanFlueInterlockWorking;
@property (nonatomic, retain) NSString * acFlameProvingSafetyDevicesWorking;
@property (nonatomic, retain) NSString * acFlueFlowSatisfactory;
@property (nonatomic, retain) NSString * acGasBoostersCompressorsWorking;
@property (nonatomic, retain) NSString * acGasInstallationPipeworkSleevedLabelledPainted;
@property (nonatomic, retain) NSString * acGasInstallationPipeworkSupported;
@property (nonatomic, retain) NSString * acGasInstallationTightnessTestCarriedOut;
@property (nonatomic, retain) NSString * acSpilageTestSatisfactory;
@property (nonatomic, retain) NSString * acTempAndThermostatsWorking;
@property (nonatomic, retain) NSString * acVentilationSatisfactory;
@property (nonatomic, retain) NSString * burnerManufacturer;
@property (nonatomic, retain) NSString * ccHAirGasRatioSetting;
@property (nonatomic, retain) NSString * ccHAmbientRoomTemp;
@property (nonatomic, retain) NSString * ccHCarbonDioxide;
@property (nonatomic, retain) NSString * ccHCarbonMonoxide;
@property (nonatomic, retain) NSString * ccHCOCO2Ratio;
@property (nonatomic, retain) NSString * ccHCOFlueDilution;
@property (nonatomic, retain) NSString * ccHExcessAir;
@property (nonatomic, retain) NSString * ccHFlueDraughtPressure;
@property (nonatomic, retain) NSString * ccHFlueGasTemp;
@property (nonatomic, retain) NSString * ccHFlueGasTempNet;
@property (nonatomic, retain) NSString * ccHGasBurnerPressure;
@property (nonatomic, retain) NSString * ccHGasRate;
@property (nonatomic, retain) NSString * ccHGrossEfficiency;
@property (nonatomic, retain) NSString * ccHHeatInputRating;
@property (nonatomic, retain) NSString * ccHNOX;
@property (nonatomic, retain) NSString * ccHOxygen;
@property (nonatomic, retain) NSString * ccLAirGasRatioSetting;
@property (nonatomic, retain) NSString * ccLAmbientRoomTemp;
@property (nonatomic, retain) NSString * ccLCarbonDioxide;
@property (nonatomic, retain) NSString * ccLCarbonMonoxide;
@property (nonatomic, retain) NSString * ccLCOCO2Ratio;
@property (nonatomic, retain) NSString * ccLCOFlueDilution;
@property (nonatomic, retain) NSString * ccLExcessAir;
@property (nonatomic, retain) NSString * ccLFlueDraughtPressure;
@property (nonatomic, retain) NSString * ccLFlueGasTemp;
@property (nonatomic, retain) NSString * ccLFlueGasTempNet;
@property (nonatomic, retain) NSString * ccLGasBurnerPressure;
@property (nonatomic, retain) NSString * ccLGasRate;
@property (nonatomic, retain) NSString * ccLGrossEfficiency;
@property (nonatomic, retain) NSString * ccLHeatInputRating;
@property (nonatomic, retain) NSString * ccLNOX;
@property (nonatomic, retain) NSString * ccLOxygen;
@property (nonatomic, retain) NSString * certificateReference;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * faults;
@property (nonatomic, retain) NSString * flueType;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * manufacturer;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * remedial;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * warningNoticeIssued;
@property (nonatomic, retain) NSString * warningNoticeNumber;
@property (nonatomic, retain) NSString * workCarriedOut;
@property (nonatomic, retain) NSString * remedialWorkRequired;

@end
