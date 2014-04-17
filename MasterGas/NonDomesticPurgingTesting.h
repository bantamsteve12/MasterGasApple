//
//  NonDomesticPurgingTesting.h
//  MasterGas
//
//  Created by Stephen Lalor on 14/04/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NonDomesticPurgingTesting : NSManagedObject

@property (nonatomic, retain) NSString * certificateNumber;
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
@property (nonatomic, retain) NSString * declarationToUse;
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
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * ppCompletePurgeNotingFinalCriteriaReadings;
@property (nonatomic, retain) NSString * ppCompletePurgeNotingFinalCriteriaReadingsUnit;
@property (nonatomic, retain) NSString * ppElecticalBondsFitted;
@property (nonatomic, retain) NSString * ppGasDetector;
@property (nonatomic, retain) NSString * ppNitrogenCylindersCheckedforCorrectContent;
@property (nonatomic, retain) NSString * ppNoSmokingSigns;
@property (nonatomic, retain) NSString * ppPersonsVicinityAdvised;
@property (nonatomic, retain) NSString * ppPurgePassFail;
@property (nonatomic, retain) NSString * ppPurgeVolumeGasMeter;
@property (nonatomic, retain) NSString * ppPurgeVolumeInstallationPipeworkFittings;
@property (nonatomic, retain) NSString * ppRiskAssessmentCarriedOut;
@property (nonatomic, retain) NSString * ppSuitableFireExtinguishersAvailable;
@property (nonatomic, retain) NSString * ppTotalPurgeVolume;
@property (nonatomic, retain) NSString * ppTwoWayRadiosAvailable;
@property (nonatomic, retain) NSString * ppValvesToFromSectionLabelled;
@property (nonatomic, retain) NSString * ppWrittenProcedurePrepared;
@property (nonatomic, retain) NSString * referenceNumber;
@property (nonatomic, retain) NSString * siteAddressLine1;
@property (nonatomic, retain) NSString * siteAddressLine2;
@property (nonatomic, retain) NSString * siteAddressLine3;
@property (nonatomic, retain) NSString * siteAddressName;
@property (nonatomic, retain) NSString * siteAddressNumber;
@property (nonatomic, retain) NSString * siteAddressPostcode;
@property (nonatomic, retain) NSString * siteMobileNumber;
@property (nonatomic, retain) NSString * siteTelNumber;
@property (nonatomic, retain) NSString * stActualPressureDrop;
@property (nonatomic, retain) NSString * stActualPressureDropUnit;
@property (nonatomic, retain) NSString * stCalculatedPressureDrop;
@property (nonatomic, retain) NSString * stCalculatedPressureDropUnit;
@property (nonatomic, retain) NSString * stComponentsIsolated;
@property (nonatomic, retain) NSString * stInstallationType;
@property (nonatomic, retain) NSString * stPermittedPressureDrop;
@property (nonatomic, retain) NSString * stStabilisationPeriod;
@property (nonatomic, retain) NSString * stStrengthTestDuration;
@property (nonatomic, retain) NSString * stStrengthTestPassFail;
@property (nonatomic, retain) NSString * stStrengthTestPressure;
@property (nonatomic, retain) NSString * stStrengthTestPressureUnit;
@property (nonatomic, retain) NSString * stTestMedium;
@property (nonatomic, retain) NSString * stTestMethod;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * ttActualLeakRate;
@property (nonatomic, retain) NSString * ttActualPressureDrop;
@property (nonatomic, retain) NSString * ttBarometricPressureCorrectionNecessary;
@property (nonatomic, retain) NSString * ttGasType;
@property (nonatomic, retain) NSString * ttInadequatelyVentAreasChecked;
@property (nonatomic, retain) NSString * ttInAdequatelyVentAreasToCheck;
@property (nonatomic, retain) NSString * ttInstallationPipeworkAndFittings;
@property (nonatomic, retain) NSString * ttInstallationType;
@property (nonatomic, retain) NSString * ttInstallationVolume;
@property (nonatomic, retain) NSString * ttLetByTestPeriod;
@property (nonatomic, retain) NSString * ttMeterBypassInstalled;
@property (nonatomic, retain) NSString * ttMeterType;
@property (nonatomic, retain) NSString * ttMeterType2;
@property (nonatomic, retain) NSString * ttMPLR;
@property (nonatomic, retain) NSString * ttMPLRUnit;
@property (nonatomic, retain) NSString * ttPressureGuageType;
@property (nonatomic, retain) NSString * ttStabilisationPeriod;
@property (nonatomic, retain) NSString * ttTempAffectTest;
@property (nonatomic, retain) NSString * ttTestMedium;
@property (nonatomic, retain) NSString * ttTightnessTestDuration;
@property (nonatomic, retain) NSString * ttTightnessTestPassFail;
@property (nonatomic, retain) NSString * ttTightnessTestPressure;
@property (nonatomic, retain) NSString * ttTightnessTestPressureUnit;
@property (nonatomic, retain) NSString * ttTotalIV;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * workPurge;
@property (nonatomic, retain) NSString * workStrengthTest;
@property (nonatomic, retain) NSString * workTightnessTest;
@property (nonatomic, retain) NSString * installationSafeOrUnsafe;

@end
