//
//  MaintenanceServiceCheck.h
//  MasterGas
//
//  Created by Stephen Lalor on 02/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MaintenanceServiceCheck : NSManagedObject

@property (nonatomic, retain) NSString * applianceLocation;
@property (nonatomic, retain) NSString * applianceMake;
@property (nonatomic, retain) NSString * applianceModel;
@property (nonatomic, retain) NSString * applianceSerialNumber;
@property (nonatomic, retain) NSString * applianceType;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * customerAddressLine1;
@property (nonatomic, retain) NSString * customerAddressLine2;
@property (nonatomic, retain) NSString * customerAddressLine3;
@property (nonatomic, retain) NSString * customerAddressName;
@property (nonatomic, retain) NSString * customerEmail;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * customerMobileNumber;
@property (nonatomic, retain) NSString * customerPosition;
@property (nonatomic, retain) NSString * customerPostcode;
@property (nonatomic, retain) NSString * customerSignatureFilename;
@property (nonatomic, retain) NSDate * customerSignoffDate;
@property (nonatomic, retain) NSString * customerSignoffName;
@property (nonatomic, retain) NSString * customerTelNumber;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * engineerSignatureFilename;
@property (nonatomic, retain) NSString * engineerSignoffAddressLine1;
@property (nonatomic, retain) NSString * engineerSignoffAddressLine2;
@property (nonatomic, retain) NSString * engineerSignoffAddressLine3;
@property (nonatomic, retain) NSString * engineerSignoffCompanyGasSafeRegNumber;
@property (nonatomic, retain) NSDate * engineerSignoffDate;
@property (nonatomic, retain) NSString * engineerSignoffEngineerIDCardRegNumber;
@property (nonatomic, retain) NSString * engineerSignoffEngineerName;
@property (nonatomic, retain) NSString * engineerSignoffMobileNumber;
@property (nonatomic, retain) NSString * engineerSignoffPostcode;
@property (nonatomic, retain) NSString * engineerSignoffTelNumber;
@property (nonatomic, retain) NSString * engineerSignoffTradingTitle;
@property (nonatomic, retain) NSString * findingsApplianceSafeToUse;
@property (nonatomic, retain) NSString * findingsApplianceSafeWarningNoticeAttached;
@property (nonatomic, retain) NSString * findingsConformToMIandIS;
@property (nonatomic, retain) NSString * findingsRemedialWorkRequired;
@property (nonatomic, retain) NSString * gasTightnessTestCarriedOut;
@property (nonatomic, retain) NSString * gasTightnessTestResult;
@property (nonatomic, retain) NSString * jobType;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSString * safetyDevice;
@property (nonatomic, retain) NSString * safetyDeviceNotes;
@property (nonatomic, retain) NSString * safetyFlueFlowTest;
@property (nonatomic, retain) NSString * safetyFlueFlowTestNotes;
@property (nonatomic, retain) NSString * safetyFlueTermination;
@property (nonatomic, retain) NSString * safetyFlueTerminationNotes;
@property (nonatomic, retain) NSString * safetyOperatingPressureHeatInput;
@property (nonatomic, retain) NSString * safetyOperatingPressureHeatInputNotes;
@property (nonatomic, retain) NSString * safetyOther;
@property (nonatomic, retain) NSString * safetyOtherNotes;
@property (nonatomic, retain) NSString * safetySpilageTest;
@property (nonatomic, retain) NSString * safetySpilageTestNotes;
@property (nonatomic, retain) NSString * safetyVentilation;
@property (nonatomic, retain) NSString * safetyVentilationNotes;
@property (nonatomic, retain) NSString * serviceBurnerInjectors;
@property (nonatomic, retain) NSString * serviceBurnerInjectorsNotes;
@property (nonatomic, retain) NSString * serviceClosurePlate;
@property (nonatomic, retain) NSString * serviceClosurePlateNotes;
@property (nonatomic, retain) NSString * serviceControls;
@property (nonatomic, retain) NSString * serviceControlsNotes;
@property (nonatomic, retain) NSString * serviceElectrics;
@property (nonatomic, retain) NSString * serviceElectricsNotes;
@property (nonatomic, retain) NSString * serviceFans;
@property (nonatomic, retain) NSString * serviceFansNotes;
@property (nonatomic, retain) NSString * serviceFireplaceOpeningVoid;
@property (nonatomic, retain) NSString * serviceFireplaceOpeningVoidNotes;
@property (nonatomic, retain) NSString * serviceFlamePicture;
@property (nonatomic, retain) NSString * serviceFlamePictureNotes;
@property (nonatomic, retain) NSString * serviceGasConnections;
@property (nonatomic, retain) NSString * serviceGasConnectionsNotes;
@property (nonatomic, retain) NSString * serviceGasPipework;
@property (nonatomic, retain) NSString * serviceGasPipeworkNotes;
@property (nonatomic, retain) NSString * serviceGasWaterLeaks;
@property (nonatomic, retain) NSString * serviceGasWaterLeaksNotes;
@property (nonatomic, retain) NSString * serviceHeatExchanger;
@property (nonatomic, retain) NSString * serviceHeatExchangerNotes;
@property (nonatomic, retain) NSString * serviceIgnition;
@property (nonatomic, retain) NSString * serviceIgnitionNotes;
@property (nonatomic, retain) NSString * serviceLocation;
@property (nonatomic, retain) NSString * serviceLocationNotes;
@property (nonatomic, retain) NSString * serviceReturnAirPlenum;
@property (nonatomic, retain) NSString * serviceReturnAirPlenumNotes;
@property (nonatomic, retain) NSString * serviceSeals;
@property (nonatomic, retain) NSString * serviceSealsNotes;
@property (nonatomic, retain) NSString * serviceStability;
@property (nonatomic, retain) NSString * serviceStabilityNotes;
@property (nonatomic, retain) NSString * siteAddressLine1;
@property (nonatomic, retain) NSString * siteAddressLine2;
@property (nonatomic, retain) NSString * siteAddressLine3;
@property (nonatomic, retain) NSString * siteAddressName;
@property (nonatomic, retain) NSString * siteAddressPostcode;
@property (nonatomic, retain) NSString * siteMobileNumber;
@property (nonatomic, retain) NSString * siteTelNumber;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * uniqueSerialNumber;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * combustion1stCO2Reading;
@property (nonatomic, retain) NSString * combustion2ndCO2Reading;
@property (nonatomic, retain) NSString * combustion3rdCO2Reading;
@property (nonatomic, retain) NSString * combustion1stCOReading;
@property (nonatomic, retain) NSString * combustion2ndCOReading;
@property (nonatomic, retain) NSString * combustion3rdCOReading;
@property (nonatomic, retain) NSString * combustion1stRatioReading;
@property (nonatomic, retain) NSString * combustion2ndRatioReading;
@property (nonatomic, retain) NSString * combustion3rdRatioReading;

@end
